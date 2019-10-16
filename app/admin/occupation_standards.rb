ActiveAdmin.register OccupationStandard do
  menu parent: 'OccupationStandards'

  includes :organization, :occupation, :parent_occupation_standard, :creator

  permit_params :type, :organization_id, :creator_id, :occupation_id, :data_trust_approval, :parent_occupation_standard_id, :industry_id, :completed_at, :published_at, :pdf_file_url, :excel_file_url, :source_file_url, :title, skill_ids: [], work_process_ids: []

  SUBMODELS = %w(FrameworkStandard RegisteredStandard GuidelineStandard UnregisteredStandard)

  preserve_default_filters!
  filter :type, as: :select, collection: SUBMODELS
  remove_filter :occupation_standard_skills
  remove_filter :occupation_standard_work_processes

  action_item :clone_master_skill, only: :show do
    link_to 'Clone', clone_master_skill_admin_occupation_standard_path(occupation_standard)
  end

  action_item :generate_master_skill_pdf, only: :show do
    link_to 'Generate PDF', generate_pdf_admin_occupation_standard_path(occupation_standard), method: :post
  end

  member_action :clone_master_skill, method: [:get, :post] do
    if request.post?
      args = params.require(resource.type.underscore.to_sym).permit(:creator_id, :organization_id).to_h.symbolize_keys
      os = resource.clone_as_unregistered!(args)
      if os.persisted?
        redirect_to admin_occupation_standard_path(os)
      else
        render :clone_master_skill
      end
    end
  end

  member_action :generate_pdf, method: [:post] do
    GenerateMasterSkillPdfJob.perform_later(resource.id)
    flash[:notice] = "PDF is being generated"
    redirect_to admin_occupation_standard_path(resource)
  end

  index do
    selectable_column
    column :id
    column :type
    column :organization
    column :title
    column :creator
    column :occupation
    column :data_trust_approval
    column :parent_occupation_standard
    column :completed_at
    column :published_at
    column :created_at
    column :updated_at
    actions
  end

  show do |os|
    attributes_table do
      row :id
      row :type
      row :organization
      row :title
      row :creator
      row :occupation
      row :data_trust_approval
      row :parent_occupation_standard
      row :industry
      table_for os.occupation_standard_work_processes.includes(:work_process) do
        column "Work Processes" do |oswp|
          link_to oswp.work_process.to_s, admin_occupation_standard_work_process_path(oswp)
        end
      end
      table_for os.occupation_standard_skills.includes(:skill) do
        column "Skills" do |oss|
          link_to oss.skill.to_s, admin_occupation_standard_skill_path(oss)
        end
      end
      row :completed_at
      row :published_at
      row :pdf do |occupation_standard|
        if occupation_standard.pdf.attached?
          link_to occupation_standard.pdf.filename, url_for(occupation_standard.pdf)
        end
      end
      row :excel_file_url
      row :source_file_url
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :type, as: :select, collection: SUBMODELS, include_blank: false
      f.input :organization
      f.input :title
      f.input :creator
      f.input :occupation
      f.input :data_trust_approval
      f.input :parent_occupation_standard
      f.input :industry
      f.input :skills, include_blank: true
      f.input :work_processes, include_blank: true
      f.input :completed_at
      f.input :published_at
      f.input :pdf_file_url
      f.input :excel_file_url
      f.input :source_file_url
    end
    f.actions
  end
end
