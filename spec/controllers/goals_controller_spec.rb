require 'rails_helper'
require 'spec_helper'

RSpec.describe GoalsController, type: :controller do
  let(:jack_bruce) { User.create!(username: "jack_bruce", password: "abcdef") }
  describe "GET #new" do
    context "when logged in" do
      before do
        allow(controller).to receive(:current_user) { jack_bruce }
      end
      it "renders the new goal page" do
        get :new
        expect(response).to render_template("new")
        expect(response).to have_http_status(200)
      end
    end
    context "when logged out" do
      before do
        allow(controller).to receive(:current_user) { nil }
      end

      it "redirects to the login page" do
          get :new
          expect(response).to redirect_to(new_session_url)
        end
      end
  end

  describe "POST #create" do
    context "when logged in" do
      before do
        allow(controller).to receive(:current_user) { jack_bruce }
      end

      it "redirects the user to the goal page on completion" do
        post :create, goal: {
                              title: "Test goal",
                              description: "desc",
                              status: "active",
                              private_goal: false
                            }
        goal = Goal.all.last
        expect(response).to redirect_to(goal_url(goal))
        expect(jack_bruce.goals.last).to eq(goal)
      end


      it "re-renders the new page for invalid goals" do
        post :create, goal: {
                              title: "Test goal",
                              description: "desc",
                              status: "wrongstatus",
                              private_goal: false
                            }
        expect(response).to render_template("new")
        expect(flash[:errors]).to be_present
      end
    end

    context "when logged out" do
      before do
        allow(controller).to receive(:current_user) { nil }
      end

      it "redirects to the login page" do
          get :new
          expect(response).to redirect_to(new_session_url)
        end
      end

  end

  describe "GET #index" do
    context "when logged in" do
      before do
        allow(controller).to receive(:current_user) { jack_bruce }
      end

      it "renders the Goal index page" do
        get :index
        expect(response).to render_template("index")
        expect(response).to have_http_status(200)
      end
    end

    context "when logged out" do
      before do
        allow(controller).to receive(:current_user) { nil }
      end

      it "redirects to the login page" do
          get :new
          expect(response).to redirect_to(new_session_url)
        end
      end
  end

  describe "GET #show" do
    create_jill_with_goals
    context "when logged in as goal author" do
      before do
        allow(controller).to receive(:current_user) { jill }
      end

      it "does show you your own private goal" do
        get :show, id: jill_goal_private.id
        expect(response).to render_template("show")
      end
    end

    context "when logged in as a different user" do
      before do
        allow(controller).to receive(:current_user) { jack_bruce }
      end

      it "shows another user's public goal" do
        get :show, id: jill_goal_public.id
        expect(response).to render_template("show")
      end

      it "doesn't show a private goal to another user" do
        get :show, id: jill_goal_private.id
        expect(response).to redirect_to(goals_url)
      end
    end

    context "when logged out" do
      before do
        allow(controller).to receive(:current_user) { nil }
      end

      it "redirects to the login page" do
          get :new
          expect(response).to redirect_to(new_session_url)
        end
      end
  end

  describe "GET #edit" do
    create_jill_with_goals

    context "when logged in as goal author" do
      before do
        allow(controller).to receive(:current_user) { jill }
      end
      it "allows you to edit your own post" do
        get :edit, id: jill_goal_private.id
        expect(response).to render_template("edit")
      end
    end

    context "when logged in as another user" do
      before do
        allow(controller).to receive(:current_user) { jack_bruce }
      end

      it "doesn't allow you to edit other user's goals" do
        get :edit, id: jill_goal_private.id
        expect(response).to redirect_to(goals_url)
      end
    end

    context "when logged out" do
      before do
        allow(controller).to receive(:current_user) { nil }
      end

      it "redirects to the login page" do
          get :new
          expect(response).to redirect_to(new_session_url)
        end
      end
  end

  describe "PATCH #update" do
    create_jill_with_goals

    context "when logged in as a goal's author" do
      before do
        allow(controller).to receive(:current_user) { jill }
      end

      it "should allow the user to edit their own goal with valid input" do
        patch :update, id: jill_goal_private.id, goal: {title: "New goal title"}
        expect(response).to redirect_to goal_url(jill_goal_private)
        expect(jill.goals.first.title).to eq("New goal title")
      end

      it "should re-render the edit page after invalid input" do
        patch :update, id: jill_goal_private.id, goal: {status: "not real status"}
        expect(response).to render_template("edit")
        expect(flash[:errors]).to be_present
      end
    end

    context "when logged in as a different user" do
      before do
        allow(controller).to receive(:current_user) { jack_bruce }
      end

      it "does not allow you to update another user's goals" do
        patch :update, id: jill_goal_private.id, goal: {title: "New goal title"}
        expect(response).to redirect_to goals_url
        expect(jill_goal_private.title).to_not eq("New goal title")
      end
    end

    context "when logged out" do
      before do
        allow(controller).to receive(:current_user) { nil }
      end

      it "redirects to the login page" do
          get :new
          expect(response).to redirect_to(new_session_url)
        end
      end
  end

  describe "DELETE #destroy" do
    create_jill_with_goals

    context "when logged in as a goal's author" do
      before do
        allow(controller).to receive(:current_user) { jill }
      end

      it "allows a user to delete their own goal" do
        delete :destroy, id: jill_goal_private.id
        expect(jill.goals.length).to eq(1)
      end
    end

    context "when logged in as a different user" do

      before do
        allow(controller).to receive(:current_user) { jack_bruce }
      end
      it "doesn't allow a user to delete another user's goal" do
        delete :destroy, id: jill_goal_private.id
        expect(response).to redirect_to goals_url
        expect(Goal.find(jill_goal_private.id)).to eq(jill_goal_private)
      end
    end
    context "when logged out" do
      before do
        allow(controller).to receive(:current_user) { nil }
      end

      it "redirects to the login page" do
          get :new
          expect(response).to redirect_to(new_session_url)
        end
      end
  end
end
