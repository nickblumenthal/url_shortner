# == Schema Information
#
# Table name: tag_topics
#
#  id         :integer          not null, primary key
#  tag        :string
#  created_at :datetime
#  updated_at :datetime
#

class TagTopic < ActiveRecord::Base
  has_many(
    :taggings,
    class_name: 'Tagging',
    primary_key: :id,
    foreign_key: :tag_id
  )

  has_many(
    :urls,
    through: :taggings,
    source: :url
  )

  def most_popular
    ShortenedUrl.find_by_sql [<<-SQL, self.id].first
      SELECT
        shortened_urls.*
      FROM
        tag_topics
      JOIN
        taggings ON tag_topics.id = taggings.tag_id
      JOIN
        shortened_urls ON taggings.url_id = shortened_urls.id
      JOIN
        visits on shortened_urls.id = visits.url_id
      WHERE
        tag_id = ?
      GROUP BY
        shortened_urls.id
      ORDER BY
        COUNT(visits.id) DESC
      LIMIT
        1
    SQL

  end
end
