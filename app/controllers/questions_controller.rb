class QuestionsController < ApplicationController
    
    def new
        @question = Question.new
        4.times { @question.answers.build }
    end
    
    def create
        Question.create(question_params)
        redirect_to action: "new"
    end
    
    def index
        @questions = Question.all.order(:nr).includes(:answers)
    end
    
    
    private
    # Using a private method to encapsulate the permissible parameters is
    # just a good pattern since you'll be able to reuse the same permit
    # list between create and update. Also, you can specialize this method
    # with per-user checking of permissible attributes.
    def question_params
      params.require(:question).permit(:id, :name, :nr, :correct_answer, answers_attributes: [:id , :name, :question_id])
    end
end
