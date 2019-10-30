require 'rails_helper'

RSpec.describe OccupationStandard, type: :model do
  it "has a valid occupation standard" do
    os = build(:occupation_standard)
    expect(os.valid?).to be true
  end

  describe ".search" do
    let(:occupation) { create(:occupation) }
    let!(:os1) { create(:occupation_standard, occupation: occupation) }
    let!(:os2) { create(:occupation_standard, occupation: occupation) }
    let!(:os3) { create(:occupation_standard) }

    it "returns all objects if options are empty" do
      expect(OccupationStandard.search).to contain_exactly os1, os2, os3
    end

    it "returns all objects if occupation_id is blank" do
      expect(OccupationStandard.search(occupation_id: nil)).to contain_exactly os1, os2, os3
    end

    it "returns filtered objects for valid occupation_id" do
      expect(OccupationStandard.search(occupation_id: occupation.id)).to contain_exactly os1, os2
    end

    it "returns no objects for invalid occupation_id" do
      expect(OccupationStandard.search(occupation_id: 9999)).to be_empty
    end
  end

  describe "#clone_as_unregistered!" do
    let!(:occupation_standard) { create(:occupation_standard, title: "OS Title", completed_at: Time.current, published_at: Time.current) }
    let!(:oswp) { create_list(:occupation_standard_work_process, 2, occupation_standard: occupation_standard) }
    let!(:oss) { create_list(:occupation_standard_skill, 2, occupation_standard: occupation_standard) }
    let(:user) { create(:user) }
    let(:organization) { create(:organization) }

    context "when successful" do
      it "creates UnregisteredStandard" do
        os = occupation_standard.clone_as_unregistered!(creator_id: user.id, organization_id: organization.id)
        expect(os).to be_a(UnregisteredStandard)
        expect(os.skills).to match_array occupation_standard.skills
        expect(os.work_processes).to match_array occupation_standard.work_processes
        expect(os.title).to eq "OS Title COPY"
        expect(os.occupation).to eq os.occupation
        expect(os.parent_occupation_standard).to eq occupation_standard
        expect(os.creator).to eq user
        expect(os.organization).to eq organization
        expect(os.completed_at).to be nil
        expect(os.published_at).to be nil
      end
    end

    context "when unsuccessful" do
      let(:error) { StandardError.new("error msg") }

      it "does not create new standard" do
        allow(UnregisteredStandard).to receive(:create!).and_raise(error)
        os = occupation_standard.clone_as_unregistered!(creator_id: user.id, organization_id: organization.id)
        expect(os).to be_new_record
        expect(occupation_standard.errors.full_messages.to_sentence).to eq "error msg"
      end
    end
  end
end
