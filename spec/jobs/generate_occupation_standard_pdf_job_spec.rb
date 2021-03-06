require 'rails_helper'

RSpec.describe GenerateOccupationStandardPdfJob, type: :job do
  describe "#perform" do
    before do
      allow(OccupationStandard).to receive(:find).with(os.id).and_return(os)
    end

    context "when os should generate pdf" do
      let(:os) { create(:occupation_standard) }

      before do
        allow(os).to receive(:should_generate_attachment?).with('pdf').and_return(true)
      end

      it "calls pdf writer and attaches file" do
        expect(OccupationStandardPdf).to receive(:new).and_call_original
        described_class.new.perform(os.id)
        os.reload
        expect(os.pdf.attached?).to be true
      end
    end

    context "when os should not generate pdf" do
      let(:os) { create(:occupation_standard) }

      before do
        allow(os).to receive(:should_generate_attachment?).with('pdf').and_return(false)
      end

      context "without force flag" do
        it "does not calls pdf writer" do
          expect(OccupationStandardPdf).to_not receive(:new)
          described_class.new.perform(os.id)
          os.reload
          expect(os.pdf.attached?).to be false
        end
      end

      context "with force flag" do
        it "calls pdf writer and attaches file" do
          expect(OccupationStandardPdf).to receive(:new).and_call_original
          described_class.new.perform(os.id, force: true)
          os.reload
          expect(os.pdf.attached?).to be true
        end
      end
    end
  end
end
