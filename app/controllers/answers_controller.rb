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
      @previous_question_selected_answer = selected_answer
      session[:question_counter] += 1
      @next_question = Question.find(session[:question_counter])
      session[:question_counter_current] += 1

      if current_question.correct_answer == selected_answer.id
        format.js { render action: "correct"}
      else
        format.js { render action: "wrong"}
      end
    end
  end
  
end