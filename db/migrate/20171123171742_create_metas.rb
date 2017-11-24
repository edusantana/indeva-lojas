class CreateMetas < ActiveRecord::Migration[5.1]
  def change
    create_table :metas do |t|
      t.integer :mes
      t.integer :ano
      t.date :inicio
      t.date :fim
      t.float :valor
      t.references :loja, foreign_key: true

      t.timestamps
    end
  end
end
