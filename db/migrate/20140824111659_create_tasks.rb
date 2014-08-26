class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.integer :weight
      t.integer :original_task_id
      t.integer :previous_task_id
      t.string :logging_type
      t.string :task_state

      t.timestamps

      t.index :name
      t.index :original_task_id
      t.index :previous_task_id
      t.index :task_state
    end
  end
end
