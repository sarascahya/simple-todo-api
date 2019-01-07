class Todo < ApplicationRecord
  validates :label, presence: true
end
