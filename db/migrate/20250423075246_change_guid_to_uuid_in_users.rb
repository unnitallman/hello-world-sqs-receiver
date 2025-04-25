class ChangeGuidToUuidInUsers < ActiveRecord::Migration[8.0]
  def change
    change_column :users, :guid, :string
    add_index :users, :guid, unique: true
  end
end
