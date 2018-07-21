class FollowUser < ApplicationRecord
  belongs_to :user

  scope :find_follow, ->(follower){where follower: follower}
end
