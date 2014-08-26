class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.integer :weight
      t.integer :original_task_id
      t.integer :previous_task_id
      t.integer :super_task_id
      t.string :history_type
      t.string :task_state
      t.string :sub_task_type

      t.timestamps

      t.index :name
      t.index :original_task_id
      t.index :previous_task_id
      t.index :super_task_id
      t.index :task_state
      t.index :sub_task_type
    end
  end
end
