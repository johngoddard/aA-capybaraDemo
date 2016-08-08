require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #new" do
    it "renders the new Users page" do
      get :new
      expect(response).to render_template("new")
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    it "redirects to goals index on user creation" do
      post :create, user: {username: "Henry", password: "password"}
      expect(response).to redirect_to(goals_url)
    end
    it "render with invalid credentials" do
      post :create, user: {username: "", password: "password"}
      expect(response).to render_template("new")
      expect(flash[:errors]).to be_present
    end
  end
end
