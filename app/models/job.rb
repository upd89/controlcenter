# A collection of tasks, triggered by a single user's action
class Job < ActiveRecord::Base
  belongs_to :user
  has_many :tasks, dependent: :destroy #destroys all tasks as well!

  def decorated_started_at
    started_at.to_formatted_s(:short)
  end

  def get_note
    note ? note.truncate_words(6) : ( is_in_preview ? ('<span class="successText">Ready to be sent!</span>' ).html_safe : "" )
  end
end
