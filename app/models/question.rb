class Question < ActiveRecord::Base
    has_many :answers, dependent: :destroy
    belongs_to :visiter
    accepts_nested_attributes_for :answers
    
    def self.random(prev_q_ids)
      #prev_q_ids = previous question ids
      count = Question.count
      random_from_count = rand(count)

      question = Question.find(random_from_count)
      until question.answered? prev_q_ids, question.id
        #next_question rand(count)
        question = Question.find(rand(count))
      end
      
     question
    end
  
    
    def answered?(ids, question_id)
      true if ids.all? { |id| id != question_id }
    end
    
    def next_question(random_from_count)
      until Question.exists? random_from_count
        Question.last.id == random_from_count ? random_from_count : random_from_count = rand(count)
      end
    end
  
end

=begin

=end