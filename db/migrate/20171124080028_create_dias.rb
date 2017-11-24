class CreateDias < ActiveRecord::Migration[5.1]
  def change
    create_table :dias do |t|
      t.float :valor
      t.references :meta, foreign_key: true
      t.date :data

      t.timestamps
    end
  end
end
