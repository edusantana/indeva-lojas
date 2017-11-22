class AddProprietarioToLoja < ActiveRecord::Migration[5.1]
  def change
    add_reference :lojas, :proprietario, foreign_key: { to_table: :users }
  end
end
