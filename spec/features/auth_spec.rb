require 'spec_helper'
require 'rails_helper'

feature "the signup process" do

  scenario "has a new user page" do
    visit new_user_url
    expect(page).to have_content "New User"
  end

  feature "signing up a user" do

    before(:each) do
      visit new_user_url
      fill_in 'Username', :with => "testing_username"
      fill_in 'Password', :with => "password"
      click_on 'Create User'
    end

    scenario "shows username on the homepage after signup" do
      expect(page).to have_content("testing_username")
    end

  end

end

feature "logging in" do

  before(:each) do
    FactoryGirl.create(:user)
    visit new_session_url
    fill_in 'Username', :with => "ActionJackson"
    fill_in 'Password', :with => "password"
    click_on 'Sign In'
  end

  scenario "shows username on the homepage after login" do
    expect(page).to have_content("ActionJackson")
  end

end

feature "logging out" do

  scenario "begins with a logged out state" do
    visit new_session_url
    expect(page).to_not have_content("Signed in as:")
  end

  scenario "doesn't show username on the homepage after logout" do
    FactoryGirl.create(:user)
    visit new_session_url
    fill_in 'Username', :with => "ActionJackson"
    fill_in 'Password', :with => "password"
    click_on 'Sign In'
    click_on 'Sign Out'
    expect(page).to_not have_content("ActionJackson")
  end

end
