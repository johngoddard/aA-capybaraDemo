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

  feature "handles errrors on new form " do
    before(:each) do
      fill_in 'Title', with: ""
      fill_in 'Description', with: "Jill's Description"
      select "Active", :from => "StatusSelect"
      choose("Private")
      click_on "Create New Goal"
    end

    scenario "renders the page with flash errors displayed when invalid" do
      expect(page).to have_content("Title can't be blank")
    end

    scenario "still allows for a successful save" do
      fill_in 'Title', with: "Valid title"
      click_on "Create New Goal"
      expect(page).to have_content("Valid title")
    end
  end
end

feature "Seeing all goals" do
  let(:jill) { User.create!(username: 'jill_bruce', password: 'abcdef') }

  before(:each) do
    FactoryGirl.create(:user)

    Goal.create!(title: 'Jill Goal',
                                  description: 'goal desc',
                                  status: 'active',
                                  private_goal: false, user: User.first)
     Goal.create!(title: 'Jill Private Goal',
                        description: 'goal desc',
                        status: 'active',
                        private_goal: true, user: User.first)

    visit new_session_url
    fill_in 'Username', :with => "ActionJackson"
    fill_in 'Password', :with => "password"
    click_on 'Sign In'

    visit goals_url
  end

  scenario "It has a link to create a new goal" do
    expect(page).to have_content("Create a new goal")
  end

  scenario "It shows all public goals for all users" do
    expect(page).to have_content("Jill Goal")
    expect(page).to_not have_content("Jill Private Goal")
  end

  scenario "links to each of the goals's show pages via goal titles" do
    click_link 'Jill Goal'
    expect(current_path).to eq('/goals/1')
  end

end
