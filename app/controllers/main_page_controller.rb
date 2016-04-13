class MainPageController < ApplicationController
    #Question counter needed
    def home
        @question = Question.find(rand(1..Question.count))
    end
    
end
