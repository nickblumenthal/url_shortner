# == Schema Information
#
# Table name: visits
#
#  id         :integer          not null, primary key
#  visitor_id :integer
#  url_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

class Visit < ActiveRecord::Base
  validates(:visitor_id, :url_id, presence: true)

  belongs_to(
    :visitor,
    class_name: 'User',
    primary_key: :id,
    foreign_key: :visitor_id
  )

  belongs_to(
    :url,
    class_name: 'ShortenedUrl',
    primary_key: :id,
    foreign_key: :url_id
  )

  def self.record_visit!(user, shortened_url)
    Visit.create!(visitor_id: user.id, url_id: shortened_url.id)
  end
end
