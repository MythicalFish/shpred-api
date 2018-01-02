class RenamePrivateToForUpwork < ActiveRecord::Migration[5.0]
  def change
    rename_column :videos, :private, :for_upwork
  end
end
