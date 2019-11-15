require 'rails_helper'

RSpec.describe API::V1::OccupationStandardsController, type: :request do
  describe "GET #index" do
    let(:occupation) { create(:occupation) }
    let!(:os1) { create(:occupation_standard, occupation: occupation) }
    let!(:os2) { create(:occupation_standard) }
    let!(:os3) { create(:occupation_standard, occupation: occupation) }
    let(:path) { "/api/v1/occupation_standards" }

    it "returns the correct data" do
      # With no occupation_id parameter, returns all data
      get path
      expect(response).to have_http_status(:success)
      expect(json["links"]["self"]).to eq api_v1_occupation_standards_url
      expect(json["data"].count).to eq 3
      expect(json["data"][0]["id"]).to eq os3.id.to_s
      expect(json["data"][0]["type"]).to eq "occupation_standard"
      expect(json["data"][0]["attributes"]["title"]).to eq os3.title
      expect(json["data"][0]["attributes"]["organization_title"]).to eq os3.organization.title
      expect(json["data"][0]["attributes"]["occupation_title"]).to eq occupation.title
      expect(json["data"][0]["attributes"]["industry_title"]).to be nil

      expect(json["data"][1]["id"]).to eq os2.id.to_s
      expect(json["data"][1]["type"]).to eq "occupation_standard"
      expect(json["data"][1]["attributes"]["title"]).to eq os2.title
      expect(json["data"][1]["attributes"]["organization_title"]).to eq os2.organization.title
      expect(json["data"][1]["attributes"]["occupation_title"]).to eq os2.occupation.title
      expect(json["data"][1]["attributes"]["industry_title"]).to be nil

      expect(json["data"][2]["id"]).to eq os1.id.to_s
      expect(json["data"][2]["type"]).to eq "occupation_standard"
      expect(json["data"][2]["attributes"]["title"]).to eq os1.title
      expect(json["data"][2]["attributes"]["organization_title"]).to eq os1.organization.title
      expect(json["data"][2]["attributes"]["occupation_title"]).to eq occupation.title
      expect(json["data"][2]["attributes"]["industry_title"]).to be nil

      # With occupation_id parameter, returns matches
      get path, params: { occupation_id: occupation.id }
      expect(response).to have_http_status(:success)
      expect(json["data"].count).to eq 2
      expect(json["data"][0]["id"]).to eq os3.id.to_s
      expect(json["data"][0]["type"]).to eq "occupation_standard"
      expect(json["data"][0]["attributes"]["title"]).to eq os3.title
      expect(json["data"][0]["attributes"]["organization_title"]).to eq os3.organization.title
      expect(json["data"][0]["attributes"]["occupation_title"]).to eq occupation.title
      expect(json["data"][0]["attributes"]["industry_title"]).to be nil
      expect(json["data"][1]["id"]).to eq os1.id.to_s
      expect(json["data"][1]["type"]).to eq "occupation_standard"
      expect(json["data"][1]["attributes"]["title"]).to eq os1.title
      expect(json["data"][1]["attributes"]["organization_title"]).to eq os1.organization.title
      expect(json["data"][1]["attributes"]["occupation_title"]).to eq occupation.title
      expect(json["data"][1]["attributes"]["industry_title"]).to be nil

      # With bad occupation_id parameter, returns none
      get path, params: { occupation_id: 9999 }
      expect(response).to have_http_status(:success)
      expect(json["data"]).to be_empty
    end
  end

  describe "GET #show" do
    let(:path) { "/api/v1/occupation_standards/#{os.id}" }

    context "without attachments" do
      let(:os) { create(:occupation_standard) }

      it "returns the correct data" do
        get path
        expect(response).to have_http_status(:success)
        expect(json["links"]["self"]).to eq api_v1_occupation_standard_url(os)
        expect(json["data"]["id"]).to eq os.id.to_s
        expect(json["data"]["type"]).to eq "occupation_standard"
        expect(json["data"]["attributes"]["title"]).to eq os.title
        expect(json["data"]["attributes"]["organization_title"]).to eq os.organization.title
        expect(json["data"]["attributes"]["occupation_title"]).to eq os.occupation.title
        expect(json["data"]["attributes"]["industry_title"]).to be nil
        expect(json["data"]["attributes"]["should_generate_attachments"]).to be true
        expect(json["data"]["attributes"]["pdf_filename"]).to be nil
        expect(json["data"]["attributes"]["pdf_url"]).to be nil
        expect(json["data"]["attributes"]["pdf_created_at"]).to be nil
        expect(json["data"]["attributes"]["excel_filename"]).to be nil
        expect(json["data"]["attributes"]["excel_url"]).to be nil
        expect(json["data"]["attributes"]["excel_created_at"]).to be nil
      end
    end

    context "with attachments" do
      before { Timecop.freeze(Time.new(2019,8,13,12,13,14)) }
      after { Timecop.return }

      let(:os) { create(:occupation_standard, :with_attachments) }

      it "returns the correct data" do
        get path
        expect(response).to have_http_status(:success)
        expect(json["data"]["id"]).to eq os.id.to_s
        expect(json["data"]["type"]).to eq "occupation_standard"
        expect(json["data"]["attributes"]["title"]).to eq os.title
        expect(json["data"]["attributes"]["organization_title"]).to eq os.organization.title
        expect(json["data"]["attributes"]["occupation_title"]).to eq os.occupation.title
        expect(json["data"]["attributes"]["industry_title"]).to be nil
        expect(json["data"]["attributes"]["should_generate_attachments"]).to be false
        expect(json["data"]["attributes"]["pdf_filename"]).to eq "pixel1x1.pdf"
        expect(json["data"]["attributes"]["pdf_url"]).to_not be nil
        expect(json["data"]["attributes"]["pdf_created_at"]).to eq "2019-08-13T12:13:14.000Z"
        expect(json["data"]["attributes"]["excel_filename"]).to eq "test.csv"
        expect(json["data"]["attributes"]["excel_url"]).to_not be nil
        expect(json["data"]["attributes"]["excel_created_at"]).to eq "2019-08-13T12:13:14.000Z"
      end
    end
  end
end
