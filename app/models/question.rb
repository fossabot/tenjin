class Question < ApplicationRecord
  has_many :answers
  has_many :asked_questions
  has_many :quizzes, through: :asked_questions
  belongs_to :topic

  enum question_type: %i[short_answer boolean multiple]
end
