=begin
question_seed_hash = {  
  
  "Kādiem mērķiem programmēšanas valodās izmanto ciklus?":
    ["Lai izvadītu informāciju uz ekrāna",
    "Lai kādas darbības atkārtotu vairākas reizes",
    "Lai izēvētos vienu variantu no vairākiem",
    "Lai saīdzinātu divas vērtības",
    "1.1.1", 2],
}

#puts "== CREATING =="
index = 0
question_seed_hash.each do |key, array|
  index += 1
  puts "#{index + 1}|#{[array[-1]]}|#{array[-1]}| #{key}"
  Question.create!(title: "#{key}", correct_answer: "#{array.last}", nr: "#{array[-2]}")
  answer_array = array.take(4)
  correct_answer_id = 0
  answer_array.each_with_index do |name, array_index|
    Answer.create!(name: "#{name}", question_id: Question.last.id)
    if array_index + 1 == array.last
      correct_answer_id = Answer.last.id
    end
    puts "#{array_index + 1} | #{name}"
  end
  Question.last.update(correct_answer: correct_answer_id)
end

=end

require 'roo'
#Uses roo gem to load all fields from xlsx file in same directory
#Fields are loaded based rows
#Answer is loaded if field has a value, in this case "x"
#xlsx = Roo::Spreadsheet.open('tests', extension: :xlsx)
xlsx = Roo::Excelx.new(Rails.root.join('db', 'tests.xlsx'))
category = ""                  #, max_rows: 39
xlsx.each_row_streaming(offset: 1) do |row|
  if !row[0].empty? && !row[1].empty? && row[2].empty?
    category = row[1] 
    puts category
  else 
    @question = Question.create(nr: row[0], title: row[1], category: category) if !row[0].empty? && !row[1].empty? && !row[2].empty?
    @question.save
    @answer = Answer.create(name: row[2], question_id: @question.id) if !row[2].empty?
    @answer.save
    puts @question.title if !row[0].empty? && !row[1].empty? && !row[2].empty?
    puts "#{@answer.id}" + " | " + "#{@answer.name}" 
    Question.last.update(correct_answer: @answer.id) if !row[3].try(:empty?)
  end
end

Question.last.answers.delete_all
Question.last.delete

#Deletes all questions without an answer including answers linked to question
c = 0
Question.find_each do |question|
  if !question.correct_answer.present?
    puts question.id
    answers = Answer.where("question_id = ?", question.id)
    puts "#{answers.count} --"
    answers.delete_all
    question.delete
    c += 1
  end
end
puts "deleted #{c} questions, including answers"

#Deletes all answers with name "x", proably gem fault of reading xlsx cells
c = 0
Answer.where("name = ?", "x").each do |answer|
  c += 1
  id = answer.question_id
  answers = Answer.where("question_id = ?", id)
  answers.delete_all
  Question.find(id).delete
end
puts Answer.where("name = ?", "x").count
puts "deleted #{c} wrongly loaded answers, inlucind questions"
