class MainPageController < ApplicationController
    #Question counter needed
    def home
        @categories = Question.uniq.pluck(:category)
        Visiter.create(ip: request.remote_ip, total_question_count: 0) if !Visiter.exists?(ip: request.remote_ip)
        session[:previous_question_ids] = []
        session[:previous_question_selected] = []
        session[:random] = false
    end
    
    def home_new_question
      session[:category] = params[:category]
      if params[:category].present?
        session[:question_counter] = Question.where("category = ?", params[:category]).first.id
        session[:question_counter_max] = Question.where("category = ?", params[:category]).last.id - session[:question_counter] + 1 
        session[:question_counter_current] = 1 
        session[:correct_questions] = 0
      end
      @question = Question.find(session[:question_counter]) 
    end
    
    def random_questions
      session[:question_counter] = 0
      session[:correct_questions] = 0
      session[:previous_question_ids] = []
      @question = Question.random(session[:previous_question_ids])
      session[:previous_question_ids] << @question.id
      session[:question_counter_max] = 50
      session[:question_counter_current] = 1
      session[:random] = true
    end

    def visiters
        @visiters = Visiter.order('last_active DESC')
    end

    def log
      @logs = []
      File.open("./log/log.log", "r").each_line do |line|
        @logs.push("#{line}")
      end

        #@logs = `tail -n 100 log/log.log`
    end

    def clear_logs
      File.truncate("./log/log.log", 0)
      redirect_to root_url
    end

end
