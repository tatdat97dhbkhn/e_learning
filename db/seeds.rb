User.create!(name: "Example User",
  email: "thuynguyennhu97@gmail.com",
  password: "thuy123",
  password_confirmation: "thuy123",
  admin: true,
  activated: true,
  activated_at: Time.zone.now)

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now)
end

5.times do |i|
  name = "Lorem Ipsum #{i}"
  cate = Category.create!(name: name)
  5.times do |j|
    course = cate.courses.create!(name: "Lorem Ipsum #{i}#{j}")
    3.times do |m|
      lesson = course.lessions.create!(name: "Lorem Ipsum #{i}#{j}#{m}")
    end
  end
  100.times do |j|
    question = cate.questions.create!(meaning: "Lorem Ipsum #{i}#{j}",
      content: "Lorem Ipsum #{i}#{j}")
    if question.id == 1
      question.answers.create!(content: "-1",
        correct: 0)
    end
    4.times do |m|
      if m== 0
        question.answers.create!(content: "Lorem Ipsum #{i}#{j}#{m}",
          correct: 1)
      else
        question.answers.create!(content: "Lorem Ipsum #{i}#{j}#{m}",
          correct: 0)
      end
    end
  end
end
