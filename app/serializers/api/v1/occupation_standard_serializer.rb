class API::V1::OccupationStandardSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title,
             :organization_title,
             :occupation_title,
             :industry_title

  attribute :pdf_filename do |object|
    object.pdf.filename if object.pdf.attached?
  end

  attribute :pdf_url do |object|
    if object.pdf.attached?
      Rails.application.routes.url_helpers.url_for(object.pdf)
    end
  end

  attribute :pdf_created_at do |object|
    object.pdf.created_at if object.pdf.attached?
  end

  attribute :should_generate_attachments do |object|
    flag = false
    %w(pdf excel).each do |kind|
      flag = true if object.should_generate_attachment?(kind)
    end
    flag
  end
end
