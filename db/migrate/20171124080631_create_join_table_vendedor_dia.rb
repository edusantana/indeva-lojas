class CreateJoinTableVendedorDia < ActiveRecord::Migration[5.1]
  def change
    create_join_table :vendedores, :dias do |t|
      t.index [:vendedor_id, :dia_id]
      t.index [:dia_id, :vendedor_id]
    end
  end
end
