class RenameFilesToMediaUrls < ActiveRecord::Migration[5.0]
  def change
    rename_column :videos, :files, :media_urls
  end
end
