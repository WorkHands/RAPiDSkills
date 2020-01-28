class API::V1::OccupationStandardPolicy < ApplicationPolicy
  attr_reader :user, :os

  def initialize(user, os)
    @user = user
    @os = os
  end

  def update?
    owned_by_user?
  end

  def destroy?
    owned_by_user?
  end

  private

  def owned_by_user?
    os.creator == user
  end
end
