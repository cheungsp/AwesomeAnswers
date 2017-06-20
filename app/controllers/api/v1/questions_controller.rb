class Api::V1::QuestionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :find_question, only: [:show]

  def show
    render json: @question
  end

  def index
    @questions = Question.all
    # by default, rails will to look for an instance variable named
    # after controller and it will render (in this case as json)
    render json: @questions
  end

  def create
    return render json: params
    question = Question.new(question_params)
    if question.save
      render json: { id: question.id }
    else
      render json: { errors: question.errors.full_messages}
    end
  end

  private
  def question_params
    params.require(:question).permit(:title, :body)
  end

  def find_question
    @question = Question.find(params[:id])
  end
end
