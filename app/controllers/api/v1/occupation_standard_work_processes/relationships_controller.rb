class API::V1::OccupationStandardWorkProcesses::RelationshipsController < API::V1::APIController
  skip_before_action :authenticate
  before_action :set_occupation_standard_work_process

  private

  def set_occupation_standard_work_process
    @oswp = OccupationStandardWorkProcess.find(params[:id])
  end
end
