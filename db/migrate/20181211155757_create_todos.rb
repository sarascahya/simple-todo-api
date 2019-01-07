class CreateTodos < ActiveRecord::Migration[5.1]
  def change
    create_table :todos do |t|
      t.string :label
      t.boolean :is_done, default: false
      t.boolean :is_valid, default: true

      t.timestamps
    end
  end
end
