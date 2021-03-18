class AddPhotoGalleryLink < ActiveRecord::Migration[6.0]
  def change
    add_column :properties, :photo_gallery_link, :string
  end
end
