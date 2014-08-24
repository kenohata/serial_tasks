class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.integer :weight

      t.timestamps

      t.index :name
    end
  end
end
