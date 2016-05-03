class MainPageController < ApplicationController
    #Question counter needed
    def home
        @categories = Question.uniq.pluck(:category)
    end
    
    def home_new_question
        session[:category] = params[:category]
        session[:question_counter] = Question.where("category = ?", params[:category]).first.id if params[:category].present?
        session[:question_counter_max] = Question.where("category = ?", params[:category]).last.id - session[:question_counter] + 1 if params[:category].present?
        session[:question_counter_current] = 1 if params[:category].present?
        @question = Question.find(session[:question_counter]) 
    end
end
