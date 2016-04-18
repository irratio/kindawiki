class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.text :text
      t.string :slug
      t.integer :parent_id

      t.timestamps null: false
    end
  end
end
