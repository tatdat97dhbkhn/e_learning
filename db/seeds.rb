User.create!(name: "Example User",
  email: "thuynguyennhu97@gmail.com",
  password: "thuy123",
  password_confirmation: "thuy123",
  admin: true,
  activated: true,
  activated_at: Time.zone.now)

50.times do |n|
  name = Faker::Name.name
  email = "example#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now)
end
num = Random.new
3.times do |i|
  name = "Lorem Ipsum #{i}"
  cate = Category.create!(name: name)
  3.times do |j|
    course = cate.courses.create!(name: "Lorem Ipsum #{i}#{j}")
    3.times do |m|
      lesson = course.lessons.create!(name: "Lorem Ipsum #{i}#{j}#{m}")
    end
  end
  num.rand(20..40).times do |j|
    question = cate.questions.create!(meaning: "Lorem Ipsum #{i}#{j}",
      content: "Lorem Ipsum #{i}#{j}")
    num.rand(2..5).times do |m|
      question.answers.create!(content: "Lorem Ipsum #{i}#{j}#{m}",
        correct: num.rand(0..1))
    end
  end
end
