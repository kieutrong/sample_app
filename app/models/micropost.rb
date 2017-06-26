class Micropost < ApplicationRecord
  belongs_to :user

  scope :feed_by_user, -> id{where("user_id = #{id}").order created_at: :desc}
  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.maximum_length_content}
  validate :picture_size

  private

  def picture_size
    if picture.size > Settings.micropost.maximum_size_picture.megabytes
      errors.add :picture, I18n.t(".should_be_less_than_5MB")
    end
  end
end
