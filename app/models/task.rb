class Task < ActiveRecord::Base
  attr_accessor :sha1

  belongs_to :super_task, class_name: Task
  belongs_to :original, foreign_key: :original_task_id, class_name: Task
  belongs_to :previous_task, class_name: Task
  has_one  :next_task, foreign_key: :previous_task_id, class_name: Task
  has_many :histories, foreign_key: :original_task_id, class_name: Task
  has_many :sub_tasks, foreign_key: :super_task_id, class_name: Task

  validates :name, presence: true, length: { in: 0..120 }
  validates :weight, numericality: true
  validates :history_type, inclusion: { in: %w(original history) }
  validates :task_state, inclusion: { in: %w(todo doing pause done quit) }
  validates :original, presence: true, if: :history?
  validates :sha1_changed?, inclusion: { in: [false] }, if: :persisted?
  validates :sub_task_type, presence: true, inclusion: { in: %w(super sub) }

  scope :original, -> { where(history_type: "original") }
  scope :history, -> { where(history_type: "history") }
  scope :super_tasks, -> { where(sub_task_type: "super") }
  scope :sub_tasks, -> { where(sub_task_type: "sub") }

  after_initialize do |task|
    task.name          ||= ""
    task.weight        ||= 3
    task.history_type  ||= "original"
    task.task_state    ||= "todo"
    task.sub_task_type ||= "sub"
  end

  before_validation do |task|
    task.name = task.name[0..120]
  end

  before_update do |task|
    if changed?
      build_histroy
    end
  end

  after_update do |task|
    @sha1 = nil
  end

  def original?
    history_type == "original"
  end

  def history?
    history_type == "history"
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

  def super_task?
    sub_task_type == "super"
  end

  def sub_task?
    sub_task_type == "sub"
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

  def avatar_url
    "https://pbs.twimg.com/profile_images/491118499603812352/lb0pa6fo_bigger.png"
  end

  private

  def build_histroy
    histories.build name: name_was,
      weight: weight_was,
      task_state: task_state_was,
      history_type: "history",
      previous_task: self
  end
end
