class CreateDropboxstrgfields < ActiveRecord::Migration
  def up
    add_column :cloudstrgusers, :dropbox_akey, :string 
    add_column :cloudstrgusers, :dropbox_asecret, :string 
    
    Cloudstrglist.create :plugin_name => "dropbox"
  end

  def down
    remove_column :cloudstrgusers, :dropbox_akey
    remove_column :cloudstrgusers, :dropbox_asecret

    Cloudstrglist.delete_all :plugin_name => "dropbox"
  end
end
