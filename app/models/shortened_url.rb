# == Schema Information
#
# Table name: shortened_urls
#
#  id           :integer          not null, primary key
#  short_url    :string
#  long_url     :string
#  submitter_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class ShortenedUrl < ActiveRecord::Base
  validates :short_url, :long_url, presence: true, uniqueness: true
  validates :long_url, length: { maximum: 1024 }
  validate :too_many_inputs

  belongs_to(
    :submitter,
    class_name: "User",
    primary_key: :id,
    foreign_key: :submitter_id
  )

  has_many(
    :visits,
    class_name: "Visit",
    primary_key: :id,
    foreign_key: :url_id
  )

  has_many(
    :visitors,
    -> { distinct },
    through: :visits,
    source: :visitor
  )

  has_many(
    :taggings,
    class_name: 'Tagging',
    primary_key: :id,
    foreign_key: :url_id
  )

  has_many(
    :tag_topics,
    through: :taggings,
    source: :tag_topic
  )

  def self.random_code
    shorter_url = SecureRandom::urlsafe_base64
    ShortenedUrl.exists?(short_url: shorter_url) ? self.random_code : shorter_url
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(
      short_url: self.random_code,
      long_url: long_url,
      submitter_id: user.id
    )
  end

  def num_clicks
     visits.count
  end

  def num_uniques
    visitors.count
  end

  def num_recent_uniques
    visitors.where("visits.created_at > ?", 10.minutes.ago).count
  end

  private

  def too_many_inputs
    url_count = self.class.where("created_at > ? AND submitter_id = ?", 1.minute.ago, submitter_id).count

    if url_count > 5
      errors[:submitter_id] << "Too many submissions"
    end
  end
end
