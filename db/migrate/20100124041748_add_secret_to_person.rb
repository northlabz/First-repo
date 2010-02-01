class AddSecretToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :secret, :string
  end

  def self.down
    remove_column :people, :secret
  end
end
