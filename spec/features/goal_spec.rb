require 'spec_helper'
require 'rails_helper'

feature "creating a new goal" do
  before(:each) do
    FactoryGirl.create(:user)
    visit new_session_url
    fill_in 'Username', :with => "ActionJackson"
    fill_in 'Password', :with => "password"
    click_on 'Sign In'
    click_on 'Create New Goal'
  end

  scenario "has a new goal page" do
    expect(page).to have_content("Create a new goal!")
  end

  scenario "It takes a title, description, status, private_goal" do
    expect(page).to have_content("Title")
    expect(page).to have_content("Description")
    expect(page).to have_content("Status")
    expect(page).to have_content("Privacy")
  end

  scenario "redirects to the goal show page on success" do
    fill_in 'Title', with: "Jill's Goal"
    fill_in 'Description', with: "Jill's Description"
    select "Active", :from => "StatusSelect"
    choose("Private")
    click_on "Create New Goal"
    expect(page).to have_content("Jill's Goal")
  end

  scenario "renders the page with flash errors displayed when invalid" do
    fill_in 'Title', with: ""
    fill_in 'Description', with: "Jill's Description"
    select "Active", :from => "StatusSelect"
    choose("Private")
    save_page_and_open
    click_on "Create New Goal"
    expect(page).to have_content("Title can't be blank")
  end
end
