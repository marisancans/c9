class MainPageController < ApplicationController
    #Question counter needed
    def home
        @categories = Question.uniq.pluck(:category)
        Visiter.create(ip: request.remote_ip, total_question_count: 0) if !Visiter.exists?(ip: request.remote_ip) 
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
    
    def visiters
        @visiters = Visiter.all
    end
end
