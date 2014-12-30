# == Schema Information
#
# Table name: taggings
#
#  id         :integer          not null, primary key
#  tag_id     :integer
#  url_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

class Tagging < ActiveRecord::Base
  belongs_to(
    :tag_topic,
    class_name: 'TagTopic',
    primary_key: :id,
    foreign_key: :tag_id
  )

  belongs_to(
    :url,
    class_name: 'ShortenedUrl',
    primary_key: :id,
    foreign_key: :url_id
  )
end
