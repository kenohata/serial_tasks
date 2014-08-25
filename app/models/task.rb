class Task < ActiveRecord::Base
  attr_accessor :sha1

  belongs_to :original, foreign_key: :original_task_id, class_name: Task
  has_many :logs, foreign_key: :original_task_id, class_name: Task

  validates :name, presence: true, length: { in: 0..120 }
  validates :weight, numericality: true
  validates :logging_type, inclusion: { in: %w(original history) }
  validates :task_state, inclusion: { in: %w(todo doing done) }
  validates :original, presence: true, if: :history?
  validates :sha1_changed?, inclusion: { in: [false] }, if: :persisted?

  scope :original, -> { where(logging_type: "original") }
  scope :history, -> { where(logging_type: "history") }

  after_initialize do |task|
    task.name         ||= ""
    task.weight       ||= 3
    task.logging_type ||= "original"
    task.task_state   ||= "todo"
  end

  before_validation do |task|
    task.name = task.name[0..120]
  end

  before_update do |task|
    if changed?
      history = logs.build name: name_was, weight: weight_was, logging_type: "history"
    end
  end

  after_update do |task|
    @sha1 = nil
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

  def sha1
    str = name + weight.to_s + task_state
    @sha1 ||= Digest::SHA1.hexdigest str
  end

  def sha1_was
    str = name_was + weight_was.to_s + task_state_was
    Digest::SHA1.hexdigest str
  end

  def sha1_changed?
    sha1 != sha1_was
  end
end
