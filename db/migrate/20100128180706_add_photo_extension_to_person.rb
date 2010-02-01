class AddPhotoExtensionToPerson < ActiveRecord::Migration
  def self.up
  	add_column :people, :extension, :string
  end

  def self.down
  	remove_column :people, :extension
  end
end
