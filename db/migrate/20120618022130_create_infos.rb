class CreateInfos < ActiveRecord::Migration
  def change
    create_table :infos do |t|
      t.string :fullname
      t.string :facultad
      t.string :esp
      t.string :situacion
      t.string :medisc
      t.string :ciclo
      t.string :pic

      t.timestamps
    end
  end
end
