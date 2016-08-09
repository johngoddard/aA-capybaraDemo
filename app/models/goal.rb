# == Schema Information
#
# Table name: goals
#
#  id           :integer          not null, primary key
#  title        :string           not null
#  description  :text             not null
#  user_id      :integer          not null
#  status       :string           not null
#  private_goal :boolean          default(FALSE), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Goal < ActiveRecord::Base
  validates :user, :status, :title, :description, presence: true
  validates :status, inclusion: %w(active completed)
  validates :private_goal, inclusion: [true, false]
  belongs_to :user, inverse_of: :goals
end
