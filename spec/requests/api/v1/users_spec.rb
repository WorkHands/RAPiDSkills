require 'rails_helper'

RSpec.describe API::V1::UsersController, type: :request do
  describe "POST #create" do
    let(:path) { "/api/v1/users" }

    context "with valid params" do
      let(:params) {
        {
          data: {
            type: "user",
            attributes: {
              email: "foo@example.com",
              password: "supersecret",
              name: "Mickey Mouse",
              organization_title: "Acme Computing",
            }
          }
        }
      }

      context "with existing organization" do
        let!(:organization) { create(:organization, title: "Acme Computing") }

        it "creates new User record" do
          expect {
            post path, params: params
          }.to change(User, :count).by(1)

          user = User.last
          expect(user.email).to eq "foo@example.com"
          expect(user.name).to eq "Mickey Mouse"
          expect(user.employer).to eq organization
          expect(user.basic?).to be true
          expect(user.valid_password?("supersecret")).to be true
        end

        it "returns user resource" do
          post path, params: params
          user = User.last
          expect(response).to have_http_status(:created)
          expect(json["data"]["id"]).to eq user.id.to_s
          expect(json["data"]["type"]).to eq "user"
          expect(json["data"]["attributes"]["email"]).to eq "foo@example.com"
          expect(json["data"]["attributes"]["name"]).to eq "Mickey Mouse"
          expect(json["data"]["attributes"]["role"]).to eq "basic"
          expect(json["data"]["relationships"]["employer"]["data"]["id"]).to eq organization.id.to_s
          expect(json["data"]["relationships"]["employer"]["data"]["type"]).to eq "organization"
          expect(json["included"][0]["id"]).to eq organization.id.to_s
          expect(json["included"][0]["type"]).to eq "organization"
          expect(json["included"][0]["attributes"]["title"]).to eq "Acme Computing"
        end
      end

      context "with new organization" do
        let(:params) {
          {
            data: {
              type: "user",
              attributes: {
                email: "foo@example.com",
                password: "supersecret",
                name: "Mickey Mouse",
                organization_title: "Acme Computing",
              }
            }
          }
        }

        it "creates new Organization record" do
          expect {
            post path, params: params
          }.to change(Organization, :count).by(1)

          organization = Organization.last
          expect(organization.title).to eq "Acme Computing"
        end

        it "returns user resource" do
          post path, params: params
          user = User.last
          organization = Organization.last
          expect(response).to have_http_status(:created)
          expect(json["data"]["id"]).to eq user.id.to_s
          expect(json["data"]["type"]).to eq "user"
          expect(json["data"]["attributes"]["email"]).to eq "foo@example.com"
          expect(json["data"]["attributes"]["name"]).to eq "Mickey Mouse"
          expect(json["data"]["attributes"]["role"]).to eq "basic"
          expect(json["data"]["relationships"]["employer"]["data"]["id"]).to eq organization.id.to_s
          expect(json["data"]["relationships"]["employer"]["data"]["type"]).to eq "organization"
          expect(json["included"][0]["id"]).to eq organization.id.to_s
          expect(json["included"][0]["type"]).to eq "organization"
          expect(json["included"][0]["attributes"]["title"]).to eq "Acme Computing"
        end
      end

      context "with no organization" do
        let(:params) {
          {
            data: {
              type: "user",
              attributes: {
                email: "foo@example.com",
                password: "supersecret",
                name: "Mickey Mouse",
              }
            }
          }
        }

        it "does not create new Organization record" do
          expect {
            post path, params: params
          }.to_not change(Organization, :count)
        end

        it "returns user resource" do
          post path, params: params
          user = User.last
          expect(response).to have_http_status(:created)
          expect(json["data"]["id"]).to eq user.id.to_s
          expect(json["data"]["type"]).to eq "user"
          expect(json["data"]["attributes"]["email"]).to eq "foo@example.com"
          expect(json["data"]["attributes"]["name"]).to eq "Mickey Mouse"
          expect(json["data"]["attributes"]["role"]).to eq "basic"
          expect(json["data"]["relationships"]["employer"]["data"]).to be nil
          expect(json.has_key?("included")).to be false
        end
      end
    end

    context "with invalid params" do
      context "without email" do
        let(:params) {
          {
            data: {
              type: "user",
              attributes: {
                email: "",
                password: "supersecret",
                name: "Mickey Mouse",
              }
            }
          }
        }

        it "does not create new User record" do
          expect {
            post path, params: params
          }.to_not change(User, :count)
        end

        it "returns 422 with error message" do
          post path, params: params
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json["errors"].count).to eq 1
          expect(json["errors"][0]["status"]).to eq "422"
          expect(json["errors"][0]["detail"]).to eq "Email can't be blank"
        end
      end

      context "with email already in use" do
        let!(:user) { create(:user, email: "foo@example.com", name: "Foo Bar", role: :basic) }
        let(:params) {
          {
            data: {
              type: "user",
              attributes: {
                email: "foo@example.com",
                password: "supersecret",
                name: "Mickey Mouse",
                organization_title: "Acme Computing",
              }
            }
          }
        }

        it "does not create new user record" do
          expect {
            post path, params: params
          }.to_not change(User, :count)
        end

        it "returns 422 with error message" do
          post path, params: params
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json["errors"].count).to eq 1
          expect(json["errors"][0]["status"]).to eq "422"
          expect(json["errors"][0]["detail"]).to eq "Email has already been taken"
        end
      end

      context "when missing attributes data" do
        let(:params) {
          {
            data: {
              type: "user",
              attributes: {
              }
            }
          }
        }

        it "returns 422 http status" do
          post path, params: params
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json["errors"][0]["status"]).to eq "422"
          expect(json["errors"][0]["detail"]).to match "empty: attributes"
        end
      end
    end
  end
end
