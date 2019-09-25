class Occupation < ApplicationRecord
  validates :rapids_code, presence: true, uniqueness: true
  has_many :occupation_standards
  has_many :industries, through: :occupation_standards

  def title_aliases=(list)
    if list.is_a?(String)
      super list.split(/;\s+/)
    else
      super list
    end
  end
end