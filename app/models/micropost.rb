class Micropost < ApplicationRecord
  belongs_to :user

  scope :order_by, ->{order created_at: :desc}
  scope :feed_by_user, -> following_ids, id do
    where "user_id IN (:following_ids) OR user_id = :user_id",
      following_ids: following_ids, user_id: id
  end

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
