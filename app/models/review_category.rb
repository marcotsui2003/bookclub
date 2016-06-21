class ReviewCategory < ActiveRecord::Base
  belongs_to :review
  belongs_to :category
end
