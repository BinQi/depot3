class AddGenreToProducts < ActiveRecord::Migration
  def change
    add_column :products, :genre, :string, default: "technology"
  end
end
