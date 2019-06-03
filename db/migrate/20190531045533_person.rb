class Person < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :name
      t.string :last_name
      t.string :user_name
    end
  end
end
