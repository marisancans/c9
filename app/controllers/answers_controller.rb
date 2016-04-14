class AnswersController < ApplicationController
  
  def index
    @answers = Answer.all
  end
  
  def show
    @answer = Answer.find(params[:id])
  end
  
  def validate
    current_question = Question.find(params[:current_question])
    selected_answer = Answer.find(params[:id])
    respond_to do |format|
      @previous_question = current_question
      @previous_question_correct_answer = selected_answer
      @next_question = Question.find(rand(1..Question.count))
      if selected_answer.id == current_question.correct_answer
        format.js { render action: "correct"}
      else
        format.js { render action: "wrong"}
      end
    end
  end
  
end