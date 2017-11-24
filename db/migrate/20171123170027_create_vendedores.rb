class CreateVendedores < ActiveRecord::Migration[5.1]
  def change
    create_table :vendedores do |t|
      t.string :nome
      t.references :loja, foreign_key: true

      t.timestamps
    end
  end
end
