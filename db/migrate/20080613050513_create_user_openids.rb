class CreateUserOpenids < ActiveRecord::Migration
  def self.up
    create_table :user_openids do |t|
      t.column  :openid_url, :string,  :null => false
      t.column  :user_id,    :integer, :null => false
      t.timestamps
    end
    add_column :users, :identity_url, :string
    add_index :user_openids, :openid_url
    add_index :user_openids, :user_id
  end

  def self.down
    drop_table :user_openids
    remove_column :users, :identity_url
  end
end
