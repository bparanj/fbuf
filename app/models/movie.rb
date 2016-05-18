class Movie < ApplicationRecord
  searchkick
  has_attached_file :poster, styles: { medium: "400x600#" }
  validates_attachment_content_type :poster, content_type: /\Aimage\/.*\Z/
  has_many :reviews
end
