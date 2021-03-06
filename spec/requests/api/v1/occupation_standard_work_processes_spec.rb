require 'rails_helper'

RSpec.describe API::V1::OccupationStandardWorkProcessesController, type: :request do
  describe "GET #index" do
    let(:path) { "/api/v1/occupation_standards/#{os.id}/work_processes" }

    let(:os) { create(:occupation_standard) }
    let!(:oswp1) { create(:occupation_standard_work_process, occupation_standard: os, sort_order: 2) }
    let!(:oswp2) { create(:occupation_standard_work_process, occupation_standard: os, sort_order: 1) }

    context "with valid occupation standard id" do
      it "returns the correct data" do
        get path
        expect(response).to have_http_status(:success)
        expect(json["links"]["self"]).to eq api_v1_occupation_standard_occupation_standard_work_processes_url(os)
        expect(json["data"].count).to eq 2
        expect(json["data"][0]["id"]).to eq oswp2.id.to_s
        expect(json["data"][0]["type"]).to eq "work_process"
        expect(json["data"][0]["attributes"]["title"]).to eq oswp2.work_process.title
        expect(json["data"][0]["attributes"]["description"]).to eq oswp2.work_process.description
        expect(json["data"][0]["relationships"]["skills"]["links"]["self"]).to eq relationships_skills_api_v1_occupation_standard_work_process_url(oswp2)
        expect(json["data"][0]["relationships"]["skills"]["links"]["related"]).to eq api_v1_occupation_standard_work_process_occupation_standard_skills_url(oswp2)
        expect(json["data"][0]["relationships"]["skills"]["data"]).to be_empty
        expect(json["data"][1]["id"]).to eq oswp1.id.to_s
        expect(json["data"][1]["type"]).to eq "work_process"
        expect(json["data"][1]["attributes"]["title"]).to eq oswp1.work_process.title
        expect(json["data"][1]["attributes"]["description"]).to eq oswp1.work_process.description
        expect(json["data"][1]["relationships"]["skills"]["links"]["self"]).to eq relationships_skills_api_v1_occupation_standard_work_process_url(oswp1)
        expect(json["data"][1]["relationships"]["skills"]["links"]["related"]).to eq api_v1_occupation_standard_work_process_occupation_standard_skills_url(oswp1)
        expect(json["data"][1]["relationships"]["skills"]["data"]).to be_empty
      end
    end

    context "with bad standard id" do
      it_behaves_like "not found", :get do
        let(:path) { "/api/v1/occupation_standards/999/work_processes" }
        let(:params) { {} }
        let(:header) { {} }
      end
    end
  end

  describe "GET #show" do
    let(:path) { "/api/v1/work_processes/#{oswp.id}" }

    let(:os) { create(:occupation_standard) }
    let(:oswp) { create(:occupation_standard_work_process, occupation_standard: os) }
    let(:cat1) { create(:category, occupation_standard_work_process: oswp, sort_order: 2) }
    let(:cat2) { create(:category, occupation_standard_work_process: oswp, sort_order: 1) }
    let!(:oss1) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp, sort_order: 2) }
    let!(:oss2) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp, sort_order: 1) }
    let!(:oss3) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp, category: cat1, sort_order: 2) }
    let!(:oss4) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp, category: cat1, sort_order: 1) }
    let!(:oss5) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp, category: cat2, sort_order: 2) }
    let!(:oss6) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp, category: cat2, sort_order: 1) }

    context "with valid work process id" do
      it "returns the correct data" do
        get path
        expect(response).to have_http_status(:success)
        expect(json["links"]["self"]).to eq api_v1_occupation_standard_work_process_url(oswp)
        expect(json["data"]["id"]).to eq oswp.id.to_s
        expect(json["data"]["type"]).to eq "work_process"
        expect(json["data"]["attributes"]["title"]).to eq oswp.work_process.title
        expect(json["data"]["attributes"]["description"]).to eq oswp.work_process.description

        expect(json["data"]["relationships"]["skills"]["links"]["self"]).to eq relationships_skills_api_v1_occupation_standard_work_process_url(oswp)
        expect(json["data"]["relationships"]["skills"]["links"]["related"]).to eq api_v1_occupation_standard_work_process_occupation_standard_skills_url(oswp)
        expect(json["data"]["relationships"]["skills"]["data"].count).to eq 2
        expect(json["data"]["relationships"]["skills"]["data"][0]["type"]).to eq "skill"
        expect(json["data"]["relationships"]["skills"]["data"][0]["id"]).to eq oss2.id.to_s
        expect(json["data"]["relationships"]["skills"]["data"][1]["type"]).to eq "skill"
        expect(json["data"]["relationships"]["skills"]["data"][1]["id"]).to eq oss1.id.to_s

        expect(json["data"]["relationships"]["categories"]["links"]["self"]).to eq relationships_categories_api_v1_occupation_standard_work_process_url(oswp)
        expect(json["data"]["relationships"]["categories"]["links"]["related"]).to eq api_v1_occupation_standard_work_process_categories_url(oswp)
        expect(json["data"]["relationships"]["categories"]["data"].count).to eq 2
        expect(json["data"]["relationships"]["categories"]["data"][0]["type"]).to eq "category"
        expect(json["data"]["relationships"]["categories"]["data"][0]["id"]).to eq cat2.id.to_s
        expect(json["data"]["relationships"]["categories"]["data"][1]["type"]).to eq "category"
        expect(json["data"]["relationships"]["categories"]["data"][1]["id"]).to eq cat1.id.to_s

        expect(json["included"]).to include(a_hash_including("type" => "skill", "id" => oss1.id.to_s))
        expect(json["included"]).to include(a_hash_including("type" => "skill", "id" => oss2.id.to_s))
        expect(json["included"]).to include(a_hash_including("type" => "category", "id" => cat1.id.to_s))
        expect(json["included"]).to include(a_hash_including("type" => "category", "id" => cat2.id.to_s))
      end
    end

    context "with bad work process id" do
      it_behaves_like "not found", :get do
        let(:path) { "/api/v1/work_processes/999" }
        let(:params) { {} }
        let(:header) { {} }
      end
    end
  end

  describe "POST #create" do
    let(:path) { "/api/v1/work_processes" }
    let(:user) { create(:user) }
    let(:header) { auth_header(user) }
    let(:params) {
      {
        data: {
          type: "work_process",
          attributes: {
            title: "new work process title",
            description: "new work process desc",
            hours: 50,
            sort_order: 99,
          },
          relationships: {
            occupation_standard: {
              data: {
                type: "occupation_standard",
                id: os.id.to_s,
              }
            }
          }
        }
      }
    }

    context "when user belongs to occupation_standard" do
      let(:os) { create(:occupation_standard, creator: user) }

      it_behaves_like "authentication", :post

      context "with valid parameters" do
        context "when new work process title does not exist" do
          it "creates a new work process and new occupation standard work process" do
            expect{
              post path, params: params, headers: header
            }.to change(WorkProcess, :count).by(1)
              .and change(OccupationStandardWorkProcess, :count).by(1)
            wp = WorkProcess.last
            expect(wp.title).to eq "new work process title"
            expect(wp.description).to eq "new work process desc"
            oswp = OccupationStandardWorkProcess.last
            expect(oswp.work_process).to eq wp
            expect(oswp.occupation_standard).to eq os
            expect(oswp.hours).to eq 50
            expect(oswp.sort_order).to eq 99
          end

          it "returns correct response" do
            post path, params: params, headers: header
            expect(response).to have_http_status(:success)
            oswp = OccupationStandardWorkProcess.last
            expect(json["links"]["self"]).to eq api_v1_occupation_standard_work_process_url(oswp)
            expect(json["data"]["id"]).to eq oswp.id.to_s
            expect(json["data"]["type"]).to eq "work_process"
            expect(json["data"]["attributes"]["title"]).to eq "new work process title"
            expect(json["data"]["attributes"]["description"]).to eq "new work process desc"
            expect(json["data"]["attributes"]["hours"]).to eq 50
            expect(json["data"]["attributes"]["sort_order"]).to eq 99
            expect(json["data"]["links"]["self"]).to eq api_v1_occupation_standard_work_process_url(oswp)
          end
        end

        context "when new work process title and desc does exist" do
          let!(:wp) { create(:work_process, title: "new work process title", description: "new work process desc") }

          it "does not create a new work process but creates new oswp" do
            expect{
              post path, params: params, headers: header
            }.to change(WorkProcess, :count).by(0)
              .and change(OccupationStandardWorkProcess, :count).by(1)
            oswp = OccupationStandardWorkProcess.last
            expect(oswp.work_process).to eq wp
            expect(oswp.occupation_standard).to eq os
            expect(oswp.hours).to eq 50
            expect(oswp.sort_order).to eq 99
          end

          it "returns correct response" do
            post path, params: params, headers: header
            oswp = OccupationStandardWorkProcess.last
            expect(response).to have_http_status(:success)
            expect(json["links"]["self"]).to eq api_v1_occupation_standard_work_process_url(oswp)
            expect(json["data"]["id"]).to eq oswp.id.to_s
            expect(json["data"]["type"]).to eq "work_process"
            expect(json["data"]["attributes"]["title"]).to eq "new work process title"
            expect(json["data"]["attributes"]["description"]).to eq "new work process desc"
            expect(json["data"]["attributes"]["hours"]).to eq 50
            expect(json["data"]["attributes"]["sort_order"]).to eq 99
            expect(json["data"]["links"]["self"]).to eq api_v1_occupation_standard_work_process_url(oswp)
          end

          it "triggers pdf/excel generation" do
            expect(GenerateOccupationStandardPdfJob).to receive(:perform_later).with(os.id)
            expect(GenerateOccupationStandardExcelJob).to receive(:perform_later).with(os.id)
            post path, params: params, headers: header
          end
        end
      end

      context "with invalid parameters" do
        context "when title is blank" do
          let(:params) {
            {
              data: {
                type: "work_process",
                attributes: {
                  title: "",
                },
                relationships: {
                  occupation_standard: {
                    data: {
                      type: "occupation_standard",
                      id: os.id.to_s,
                    }
                  }
                }
              }
            }
          }

          it "does not create new work process or oswp" do
            expect{
              post path, params: params, headers: header
            }.to change(WorkProcess, :count).by(0)
              .and change(OccupationStandardWorkProcess, :count).by(0)
          end

          it "does not trigger pdf/excel generation" do
            expect(GenerateOccupationStandardPdfJob).to_not receive(:perform_later)
            expect(GenerateOccupationStandardExcelJob).to_not receive(:perform_later)
            post path, params: params, headers: header
          end


          it "returns 422 with an error message" do
            post path, params: params, headers: header
            expect(response).to have_http_status(:unprocessable_entity)
            expect(json["errors"][0]["status"]).to eq "422"
            expect(json["errors"][0]["detail"]).to eq "Title can't be blank"
          end
        end

        context "when missing relationships key" do
          let(:params) {
            {
              data: {
                type: "work_process",
                attributes: {
                  title: "new work process",
                }
              }
            }
          }

          it "returns 422 http status" do
            post path, params: params, headers: header
            expect(response).to have_http_status(:unprocessable_entity)
            expect(json["errors"][0]["status"]).to eq "422"
            expect(json["errors"][0]["detail"]).to match "empty: relationships"
          end
        end

        context "when missing attributes key" do
          let(:params) {
            {
              data: {
                type: "work_process",
                attributes: {
                },
                relationships: {
                  occupation_standard: {
                    data: {
                      type: "occupation_standard",
                      id: os.id.to_s,
                    }
                  }
                }
              }
            }
          }

          it "returns 422 http status" do
            post path, params: params, headers: header
            expect(response).to have_http_status(:unprocessable_entity)
            expect(json["errors"][0]["status"]).to eq "422"
            expect(json["errors"][0]["detail"]).to match "empty: attributes"
          end
        end
      end
    end

    context "when user does not belong to occupation standard" do
      it_behaves_like "forbidden", :post do
        let(:os) { create(:occupation_standard) }
      end
    end
  end

  describe "PATCH #update" do
    let(:path) { "/api/v1/work_processes/#{oswp.id}" }
    let(:user) { create(:user) }
    let(:os) { create(:occupation_standard) }
    let!(:oswp) { create(:occupation_standard_work_process, occupation_standard: os, hours: 10) }
    let(:header) { auth_header(user) }
    let(:params) {
      {
        data: {
          type: "work_process",
          id: oswp.id.to_s,
          attributes: {
            title: "this is an updated title",
            description: "this is an updated desc",
            hours: 40,
            sort_order: 99,
          }
        }
      }
    }

    context "when user belongs to occupation_standard" do
      let(:os) { create(:occupation_standard, creator: user) }

      it_behaves_like "authentication", :patch

      context "with valid parameters" do
        context "when new work process title/desc does not exist" do
          it "creates a new work process and links work process to oswp" do
            expect{
              patch path, params: params, headers: header
            }.to change(WorkProcess, :count).by(1)
              .and change(OccupationStandardWorkProcess, :count).by(0)
            work_process = WorkProcess.last
            expect(work_process.title).to eq "this is an updated title"
            expect(work_process.description).to eq "this is an updated desc"
            oswp.reload
            expect(oswp.work_process).to eq work_process
            expect(oswp.hours).to eq 40
            expect(oswp.sort_order).to eq 99
          end

          it "returns correct response" do
            patch path, params: params, headers: header
            expect(response).to have_http_status(:success)
            expect(json["links"]["self"]).to eq api_v1_occupation_standard_work_process_url(oswp)
            expect(json["data"]["id"]).to eq oswp.id.to_s
            expect(json["data"]["type"]).to eq "work_process"
            expect(json["data"]["attributes"]["title"]).to eq "this is an updated title"
            expect(json["data"]["attributes"]["description"]).to eq "this is an updated desc"
            expect(json["data"]["attributes"]["hours"]).to eq 40
            expect(json["data"]["attributes"]["sort_order"]).to eq 99
            expect(json["data"]["links"]["self"]).to eq api_v1_occupation_standard_work_process_url(oswp)
          end

          it "triggers pdf/excel generation" do
            expect(GenerateOccupationStandardPdfJob).to receive(:perform_later).with(os.id)
            expect(GenerateOccupationStandardExcelJob).to receive(:perform_later).with(os.id)
            patch path, params: params, headers: header
          end
        end

        context "when new work process title/desc does exist" do
          let!(:work_process) { create(:work_process, title: "this is an updated title", description: "this is an updated desc") }

          it "does not create a new work process but links work process to oswp" do
            expect{
              patch path, params: params, headers: header
            }.to change(WorkProcess, :count).by(0)
              .and change(OccupationStandardWorkProcess, :count).by(0)
            oswp.reload
            expect(oswp.work_process).to eq work_process
            expect(oswp.hours).to eq 40
            expect(oswp.sort_order).to eq 99
          end

          it "returns correct response" do
            patch path, params: params, headers: header
            expect(response).to have_http_status(:success)
            expect(json["links"]["self"]).to eq api_v1_occupation_standard_work_process_url(oswp)
            expect(json["data"]["id"]).to eq oswp.id.to_s
            expect(json["data"]["type"]).to eq "work_process"
            expect(json["data"]["attributes"]["title"]).to eq "this is an updated title"
            expect(json["data"]["attributes"]["description"]).to eq "this is an updated desc"
            expect(json["data"]["attributes"]["hours"]).to eq 40
            expect(json["data"]["attributes"]["sort_order"]).to eq 99
            expect(json["data"]["links"]["self"]).to eq api_v1_occupation_standard_work_process_url(oswp)
          end
        end
      end

      context "with invalid parameters" do
        let(:params) {
          {
            data: {
              type: "work_process",
              id: oswp.id.to_s,
              attributes: {
                title: "",
              }
            }
          }
        }

        it "does not create new work process" do
          expect{
            patch path, params: params, headers: header
          }.to_not change(WorkProcess, :count)
        end

        it "does not trigger pdf/excel generation" do
          expect(GenerateOccupationStandardPdfJob).to_not receive(:perform_later)
          expect(GenerateOccupationStandardExcelJob).to_not receive(:perform_later)
          patch path, params: params, headers: header
        end

        it "returns 422 with an error message" do
          patch path, params: params, headers: header
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json["errors"][0]["status"]).to eq "422"
          expect(json["errors"][0]["detail"]).to eq "Title can't be blank"
        end
      end

      context "with bad work process id" do
        it_behaves_like "not found", :patch do
          let(:path) { "/api/v1/work_processes/999" }
        end
      end
    end

    context "when user does not belong to occupation standard" do
      it_behaves_like "forbidden", :patch
    end
  end
end
