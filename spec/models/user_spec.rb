# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) do
    FactoryGirl.build(:user)
  end

  it {should validate_presence_of(:username) }
  it {should validate_uniqueness_of(:username) }
  it {should validate_presence_of(:password_digest) }
  it {should validate_presence_of(:session_token) }
  it {should validate_length_of(:password).is_at_least(6)}



  describe "#reset_session_token!" do
    it "changes session token" do
      old_token = user.session_token
      user.reset_session_token!
      expect(user.session_token).to_not eq(old_token)
    end

    it "sets the user's session token to it's return val" do
      new_token = user.reset_session_token!
      expect(user.session_token).to eq(new_token)
    end
  end

  describe "::find_by_credentials" do
    before(:each){user.save}

    it "finds a user with valid username and password" do
      expect(User.find_by_credentials("ActionJackson", "password")).to eq(user)
    end

    it "returns nil for a wrong password" do
      expect(User.find_by_credentials("ActionJackson", "p")).to be(nil)
    end

    it "returns nil for an invalid username" do
      expect(User.find_by_credentials("Actio", "password")).to be(nil)
    end
  end

  describe "valid_password?" do
      before(:each){user.save}

    it "returns true for the correct password" do
      expect(user.valid_password?("password")).to be(true)
    end

    it "returns false for the an invalid password" do
      expect(user.valid_password?("passrd")).to be(false)
    end
  end


end
