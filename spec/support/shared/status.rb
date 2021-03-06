require 'rails_helper'

RSpec.shared_examples "authentication" do |method|
  it "returns unauthorized if bad authentication" do
    send(method, path, params: params, headers: bad_auth_header)
    expect(response).to have_http_status(:unauthorized)
  end

  it "returns success if authorized" do
    send(method, path, params: params, headers: header)
    expect(response).to have_http_status(:success)
  end
end

RSpec.shared_examples "unauthorized" do |method|
  it "has unauthorized status" do
    send(method, path, params: params, headers: header)
    expect(response).to have_http_status(:unauthorized)
  end
end

RSpec.shared_examples "forbidden" do |method|
  it "has forbidden status" do
    send(method, path, params: params, headers: header)
    expect(response).to have_http_status(:forbidden)
    expect(json["errors"]["status"]).to eq "403"
    expect(json["errors"]["detail"]).to eq "User is not authorized to perform this action"
  end
end

RSpec.shared_examples "not found" do |method|
  it "has not found status" do
    send(method, path, params: params, headers: header)
    expect(response).to have_http_status(:not_found)
  end
end

RSpec.shared_examples "no content" do |method|
  it "has not found status" do
    send(method, path, params: params, headers: header)
    expect(response).to have_http_status(:no_content)
  end
end

RSpec.shared_examples "success" do |method|
  it "has success status" do
    send(method, path, params: params, headers: header)
    expect(response).to have_http_status(:success)
  end
end
