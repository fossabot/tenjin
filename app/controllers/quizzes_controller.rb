# Quizzes Controller
class QuizzesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_quiz, only: %i[show update]
  before_action :set_question, only: %i[show update]
  before_action :set_css_flavour, only: %i[new]
  rescue_from Pundit::NotAuthorizedError, with: :quiz_not_authorized

  def index
    quizzes = policy_scope(Quiz)
    redirect_to Quiz::SelectCorrectQuiz.new(quizzes: quizzes).call
  end

  def show
    authorize @quiz
    gon.quiz_id = @quiz.id
    @multiplier = Multiplier.where('score <= ?', @quiz.streak).last
    calculate_percent_completed
    render Quiz::RenderQuestionType.new(question: @question).call
  end

  def new
    set_subject
    authorize Quiz.new(subject: @subject)

    if @subject.blank?
      @subjects = current_user.subjects
      render 'new'
    else
      @css_flavour = current_user.dashboard_style
      @topics = @subject.topics.pluck(:name, :id)
      @topics.prepend(['Lucky Dip', 'Lucky Dip'])
      render 'select_topic'
    end
  end

  def create
    topic = quiz_params.dig(:topic_id)
    subject = Subject.find(quiz_params.dig(:subject))
    quiz = Quiz.new(subject: subject)
    authorize quiz, :new?
    return redirect_to new_quiz_path(subject: subject) if topic.blank?

    quiz = Quiz::CreateQuiz.new(user: current_user, topic: topic, subject: subject).call
    redirect_to quiz
  end

  def update
    authorize @quiz
    render(json: Quiz::CheckAnswer.new(quiz: @quiz, question: @question, answer_given: answer_params).call)
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:id])
  end

  def set_subject
    @subject = Subject.where('name = ?', params.permit(:subject).dig(:subject)).first
  end

  def set_question
    @question = Question.find(@quiz.question_order[@quiz.num_questions_asked - 1])
  end

  def set_css_flavour
    @css_flavour = current_user.dashboard_style
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def answer_params
    params.require(:answer).permit(:id, :short_answer)
  end

  def quiz_params
    params.require(:quiz).permit(:topic_id, :subject)
  end

  def quiz_not_authorized(exception)
    case exception.query
    when 'new?'
      flash[:alert] = if exception.record.subject.present?
                        ['Invalid subject ', exception.record.subject]
                      else
                        'Subject does not exist'
                      end
    when 'show?'
      return flash[:alert] = 'Quiz does not belong to you' if exception.record.active?

      flash[:notice] = 'The quiz has finished'

    end
    redirect_to dashboard_path
  end

  def calculate_percent_completed
    @percent_complete = (@quiz.num_questions_asked.to_f / @quiz.questions.length.to_f) * 100.to_f
  end
end
