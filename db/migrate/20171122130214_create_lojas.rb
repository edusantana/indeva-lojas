class CreateLojas < ActiveRecord::Migration[5.1]
  def change
    create_table :lojas do |t|
      t.string :nome

      t.timestamps
    end
  end
end
