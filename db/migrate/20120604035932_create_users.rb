class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :codigo
      t.string :password

      t.timestamps
    end
  end
end
