# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[show update destroy reset_flags]

  def index
    @subjects = policy_scope(Question)
    raise Pundit::NotAuthorizedError if @subjects.blank?
  end

  def topic_questions
    redirect questions_path unless topic_question_params.present?

    @topic = Topic.find(topic_question_params)
    authorize @topic, :show?
    @topic_lessons = Lesson.where(topic: @topic)
    @questions = Question.with_rich_text_question_text_and_embeds
                         .includes(:question_statistic, :lesson)
                         .where(topic: @topic, active: true)

    render 'topic_question_index'
  end

  def reset_flags
    authorize current_user, :update?
    FlaggedQuestion.where(question: @question).delete_all
    Question.reset_counters @question.id, :flagged_questions_count
    redirect_to @question
  end

  def flagged_questions
    @subject = Subject.find(flagged_questions_params)
    authorize @subject, :flagged_questions?
    @questions = @subject.flagged_questions
    render :flagged_questions
  end

  def new
    @question = Question.new(question_params)
    authorize @question

    return unless @question.topic.present?

    check_answers
    build_answers
  end

  def create
    @question = Question.new(question_params)
    authorize @question
    check_answers

    if @question.save
      redirect_to topic_questions_questions_path(topic_id: @question.topic), notice: 'Question successfully created'
    else
      render :new
    end
  end

  def show
    @question.assign_attributes(question_params) if params[:question].present?
    authorize @question
    check_answers
    build_answers
  end

  def update
    @question.assign_attributes(question_params)
    authorize @question
    check_answers

    if @question.save
      redirect_to @question, notice: 'Question successfully updated'
    else
      render :show
    end
  end

  def destroy
    authorize @question
    redirect_to topic_questions_questions_path(topic_id: @question.topic)

    @question.update_attribute(:active, false)
  end

  def download_topic_questions
    @topic = Topic.find(topic_question_params)
    authorize @topic, :show?
    @questions = Question.where(topic: @topic).to_json(include: :answers)

    send_data @questions,
              type: 'application/json; header=present',
              disposition: "attachment; filename=#{@topic.name}.json"
  end

  def import_topic_questions
    @topic = Topic.find(topic_question_params)
    authorize @topic, :update?
  end

  def import
    @topic = Topic.find(topic_question_params)
    authorize @topic, :update?

    if params[:file].nil?
      flash[:alert] = 'Please attach a file'
      return render :import_topic_questions, topic_id: @topic
    end

    data = File.read(params[:file])
    result = Question::ImportQuestions.call(data, @topic)
    flash[:notice] = result.error
    redirect_to topic_questions_questions_path(topic_id: @topic)
  end

  private

  def topic_question_params
    params.require(:topic_id)
  end

  def flagged_questions_params
    params.require(:subject_id)
  end

  def question_params
    params.require(:question).permit(:question_text, :question_type, :lesson_id,
                                     :topic_id, answers_attributes: %i[correct id text _destroy])
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def setup_boolean_question
    @question.answers.build until @question.answers.length >= 2
    @question.answers = @question.answers.slice(0..1) if @question.answers.length > 2
    return if @question.valid?

    @question.answers.second.text = 'True'
    @question.answers.first.text = 'False'
  end

  def check_answers
    setup_boolean_question if @question.boolean?
    @question.answers.each { |a| a.correct = true } if @question.short_answer? || @question.question_type.nil?
  end

  def build_answers
    unless @question.answers.present?
      @question.answers.build if @question.short_answer? || @question.question_type.nil?
    end

    @question.answers.build until @question.answers.length >= 4 || !@question.multiple?
  end
end
