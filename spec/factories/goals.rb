# == Schema Information
#
# Table name: goals
#
#  id          :integer          not null, primary key
#  title       :string           not null
#  description :text             not null
#  user_id     :integer          not null
#  status      :string           not null
#  private     :boolean          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :goal do
    title "Test Goal"
    description "Goal description"
    user_id 1
    status "current"
    private_goal false

    factory :private_goal do
      private_goal true
    end

    factory :completed_goal do
      status "completed"
    end
  end
end
