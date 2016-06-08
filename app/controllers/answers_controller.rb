class AnswersController < ApplicationController
  
  def index
    @answers = Answer.all
  end
  
  def show
    @answer = Answer.find(params[:id])
  end
  
  def validate
    v = Visiter.where(ip: request.remote_ip).first
    v.total_question_count += 1
    v.last_active = Time.now
    v.save
    current_question = Question.find(params[:current_question])
    selected_answer = Answer.find(params[:id])
    respond_to do |format|
      @previous_question = current_question
      @previous_question_selected_answer = selected_answer
      session[:question_counter] += 1
      @next_question = Question.find(session[:question_counter])
      session[:question_counter_current] += 1
      session[:correct_questions] += 1 if current_question.correct_answer == selected_answer.id
      format.js { render action: "finish"} if session[:question_counter_current] == session[:question_counter_max] + 1
      if current_question.correct_answer == selected_answer.id
        format.js { render action: "correct"}
      else
        format.js { render action: "wrong"}
      end
    end
  end
  
end