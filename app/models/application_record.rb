class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :using, ->(flag){where used: flag}
end
