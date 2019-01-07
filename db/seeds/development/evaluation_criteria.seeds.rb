require_relative 'helper'

after 'development:courses' do
  puts 'Seeding Evaluation Criteria'

  Course.all.each do |course|
    EvaluationCriterion.create!(name: 'Quality', description:'The default evaluation criteria', course: course)
  end
end
