class Task < ActiveRecord::Base
  belongs_to :original, foreign_key: :original_task_id, class_name: Task
  has_many :logs, foreign_key: :original_task_id, class_name: Task

  validates :name, presence: true, length: { in: 0..120 }
  validates :weight, numericality: true
  validates :logging_type, inclusion: { in: %w(original history) }
  validates :task_state, inclusion: { in: %w(todo doing done) }

  scope :original, -> { where(logging_type: "original") }
  scope :history, -> { where(logging_type: "history") }

  after_initialize do |task|
    task.name         ||= ""
    task.weight       ||= 3
    task.logging_type ||= "original"
    task.task_state   ||= "todo"
  end

  before_update do |task|
    if changed?
      history = logs.build name: name_was, weight: weight_was, logging_type: "history"
    end
  end

  def original?
    logging_type == "original"
  end

  def history?
    logging_type == "history"
  end

  def todo?
    task_state == "todo"
  end

  def doing?
    task_state == "doing"
  end

  def done?
    task_state == "done"
  end
end
