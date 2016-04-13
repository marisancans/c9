# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


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
  "Kura no minētajām operācijām ar rakstzīmju virknēm ir iespējama Pascal valodā":
    ["Jebkura aritmētiska operācija",
    "Virkņu apvienošana",
    "Vienas virknes reizināšana ar otru",
    "Vienas virknes dalīšana ar otru",
    "1.1.4", 2]
    
    
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