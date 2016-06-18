class AnswersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  
  def index
    @answers = Answer.all
  end
  
  def show
    @answer = Answer.find(params[:id])
  end
  
  def validate
    v = Visiter.where(ip: request.remote_ip).first
    v.total_question_count += 1
    v.last_active = Time.now.strftime("%H:%M:%S")
    v.save
    current_question = Question.find(params[:current_question])
    selected_answer = Answer.find(params[:id])
    respond_to do |format|
      @previous_question = current_question
      @previous_question_selected_answer = selected_answer
      session[:question_counter] += 1
      session[:question_counter_current] += 1
      session[:correct_questions] += 1 if current_question.correct_answer == selected_answer.id
      if session[:random] == false
        @next_question = Question.next(session[:question_counter])
      else
        @next_question = Question.random(session[:previous_question_ids])
      end
      session[:previous_question_ids] << @next_question.id
      if session[:question_counter_current] == session[:question_counter_max] + 1
        format.js { render action: "finish"} 
        Result.create(correct_question: session[:correct_questions],
                      question_count: session[:question_counter_max],
                      visiter_ip: v.ip)
      end
      if current_question.correct_answer == selected_answer.id
        session[:previous_question_selected] << selected_answer.id
        format.js { render action: "correct"}
      else
        session[:previous_question_selected] << selected_answer.id
        format.js { render action: "wrong"}
      end
    end
    logger.info "Question - #{current_question.id} | Answer - #{selected_answer.id} | ip - #{v.ip} time - #{Time.now.strftime("%H:%M:%S")}"
    open('./log/log.log', 'a+') { |f|
      f.puts "#{Time.now.strftime("%H:%M:%S")} | #{v.ip} | #{current_question.title } - #{current_question.id} | #{selected_answer.name} - #{selected_answer.id}"
    }
  end

  private

  def record_not_found
    session[:question_counter] += 1
    v = Visiter.where(ip: request.remote_ip).first
    current_question = Question.find(params[:current_question])
    open('./log/log.log', 'a+') { |f|
      f.puts "ERROR, RECORD NOT FOUND #{Time.now.strftime("%H:%M:%S")} | #{v.ip} | #{current_question.title } - #{current_question.id}"
    }
    @next_question = Question.find(session[:question_counter_current] + 1)
  end
  
end