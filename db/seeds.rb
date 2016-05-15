# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
=begin
question_seed_hash = {  
  
  "Kādiem mērķiem programmēšanas valodās izmanto ciklus?":
    ["Lai izvadītu informāciju uz ekrāna",
    "Lai kādas darbības atkārtotu vairākas reizes",
    "Lai izēvētos vienu variantu no vairākiem",
    "Lai saīdzinātu divas vērtības",
    "1.1.1", 2],
  "Kas ir operators programmēšanas valodā?":
    ["Cilvēks, kurš strādā ar datoru",
    "Pabeigta valodas frāze, kas nosaka kādu etapu datu apstrādē",
    "Datu elements, kurš programmas izpildes gaitā maina savu vērtību",
    "Datu elements, kurš programmas izpildes gaitā namaina savu vērtību",
    "1.1.2", 2],
  "Kādā gadījumā vēlams lietot cikla operatoru for?":
    ["Kad nepieciešams, lai cikls izpildītos kaut venu reizi",
    "Kad ir zināms cikla izpildes reižu skaits",
    "Kad nav zināms cikla izpildes reižu skaits",
    "Tikai darbam ar veseliem mainīgajiem",
    "1.1.3", 2],
  "Kura no minētajām operācijām ar rakstzīmju virknēm ir iespējama Pascal valodā?":
    ["Jebkura aritmētiska operācija",
    "Virkņu apvienošana",
    "Vienas virknes reizināšana ar otru",
    "Vienas virknes dalīšana ar otru",
    "1.1.4", 2],
  "Kas ir viendimensiju masīva element indekss?":
    ["Masīva elementa vērtība",
    "Masīva elementa numurs",
    "Masīva rindas numurs",
    "Masīva kolonas numurs",
    "1.1.5",2],
  "Kā izpaužas rekursija?":
    ["Apakšprogramma izsauc pati sevi",
    "Apakšprogramma izsauc apakšprogrammu, kas uzrakstīta augstāk",
    "Apakšprogramma izsauc apaksprogrammu, kas uzrastīta zemāk",
    "apakšprogrmma izsauc standartprocedūru",
    "1.1.6", 1],
    "Kas ir 'klase'?":
    ["Programmēšanas valodas operators",
    "sakārtots vienāda tipa elementu kopums",
    "datu tips, kurš ietver datu elementus un to apstrādāšanas metodes",
    "funkcijas tips, kurš apstrādā dažādu tipu datu laukus",
    "1.1.7", 3],
    "Kā sauc algoritmu, kas ir pierakstīts datoram saprotamā formātā?":
    ["uzdevums",
    "komanda",
    "programma",
    "blok-shēma",
    "1.1.8", 3],
    "Kas ir programmas mazākā izpildāmā vērtība?":
    ["Operators",
    "operands",
    "teikums",
    "parametrs",
    "1.1.9", 1],
    "Kura ir programmēšanas valoda ir jūtīga pret operatoru burtu reģistru?":
    ["Pascal",
    "JavaScript",
    "HTML",
    "SQL",
    "1.1.10", 2],
    "Kādiem mērķiem programmēšanas valodās izmnto operatoru blokus?":
    ["lai izvadītu informāciju uz ekrāna",
    "lai noteiktā programmas vietā izpildītu nevis vienu, bet vairākus operatorus",
    "lai izvēlētos vienu variantu no vairākiem",
    "lai slīdzinātu divas vērības",
    "1.1.11", 3],
    "Kādiem mērķiem programmēšanas valodās izmanto sazrarojumus?":
    ["lai kādas darbībs atkārtotu vairākas reizes"]
    
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
 Question.create(nr: "0", title: "t", category: "c")
require 'roo'
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

Question.last.delete
Answer.last.delete
