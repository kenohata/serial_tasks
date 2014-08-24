class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.integer :weight
      t.integer :original_task_id
      t.string :logging_type

      t.timestamps

      t.index :name
      t.index :original_task_id
    end
  end
end
