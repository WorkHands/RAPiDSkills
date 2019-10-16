require 'rails_helper'

RSpec.describe GenerateMasterSkillPdfJob, type: :job do
  let(:os) { create(:occupation_standard) }

  describe "#perform" do
    it "calls pdf writer and attaches file" do
      expect(MasterSkill).to receive(:new).and_call_original
      described_class.new.perform(os.id)
      os.reload
      expect(os.pdf.attached?).to be true
    end
  end
end
