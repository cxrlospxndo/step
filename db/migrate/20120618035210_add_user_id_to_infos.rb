class AddUserIdToInfos < ActiveRecord::Migration
  def change
    add_column :infos, :user_id, :integer
  end
end
