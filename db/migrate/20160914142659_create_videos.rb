class CreateVideos < ActiveRecord::Migration
  def change

    create_table :videos do |t|

      t.string :title
      t.text :description
      t.string :meta_description

      t.attachment :file
      t.attachment :preview
      t.attachment :thumb

      t.string :file_meta
      t.text :files

      t.boolean :published, default: false
      t.string :slug, null: false
      t.integer :views, default: 0
      t.string :length, default: "0:00"
      t.string :dimensions, default: "0x0"
      t.integer :width, default: 0
      t.integer :height, default: 0
      t.string :sid
      
      t.timestamps

    end

    add_index :videos, :created_at
    add_index :videos, :height
    add_index :videos, :length
    add_index :videos, :sid
    add_index :videos, :slug
    add_index :videos, :title
    add_index :videos, :views

  end
end
