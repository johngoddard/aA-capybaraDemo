# == Schema Information
#
# Table name: goals
#
#  id           :integer          not null, primary key
#  title        :string           not null
#  description  :text             not null
#  user_id      :integer          not null
#  status       :string           not null
#  private_goal :boolean          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Goal, type: :model do
  it {should validate_presence_of(:user)}
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:description)}
  it {should validate_presence_of(:status)}
  it {should validate_inclusion_of(:status).in_array ['active', 'completed']}
  it {should validate_inclusion_of(:private_goal).in_array [false, true]}

  it {should belong_to(:user)}


end
