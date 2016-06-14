class Question < ActiveRecord::Base
    has_many :answers, dependent: :destroy
    belongs_to :visiter
    accepts_nested_attributes_for :answers
    
    def self.random(prev_q_ids)
      question = Question.order("RANDOM()").first
      until question.answered? prev_q_ids, question.id
        question = Question.limit(1).order("RANDOM()")
      end
     question
    end
    
    def self.next(id)
      Question.where("id > ?", id).first
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