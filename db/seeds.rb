# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created
# alongside the database with db:setup).

f_user = User.create(name: 'Ale', email: 'ale@paraffin.com', password: 'password')
s_user = User.create(name: 'Cris', email: 'cris@paraffin.com', password: 'password')
t_user = User.create(name: 'Rony', email: 'rony@paraffin.com', password: 'password')
User.create(name: 'Cecy', email: 'cecy@paraffin.com', password: 'password')
first_curr = Curriculum.create(name: 'Fullstack Developer', description: 'El camino para convertiorse en un dev super cachilupi')
f_learning_unit = LearningUnit.create(name: 'Ruby', description: 'Aprendamos el lenguaje para el backend de una Web App')
s_learning_unit = LearningUnit.create(name: 'Rails', description: 'Aprendamos a crear el backend de una Web App')
CurriculumAffiliation.create(curriculum: first_curr,
                             learning_unit: f_learning_unit)
CurriculumAffiliation.create(curriculum: first_curr,
                             learning_unit: s_learning_unit)
f_resource = Resource.create(user: f_user, learning_unit: f_learning_unit,
                             name: 'Ruby for dummies', url: 'fakeurl.io', description: 'El mejor tutorial para los dummies')
s_resource = Resource.create(user: s_user, learning_unit: f_learning_unit,
                             name: 'The best Ruby', url: 'fakeurl.io', description: 'Aprendiendo a programar')
ResourceComment.create(user: s_user, resource: f_resource,
                       content: 'Vale pico tu wea')
ResourceEvaluation.create(user: t_user, resource: f_resource, evaluation: 5)
ResourceEvaluation.create(user: s_user, resource: f_resource, evaluation: 3)
ResourceEvaluation.create(user: t_user, resource: s_resource, evaluation: 1)
CompletedLearningUnit.create(user: f_user, learning_unit: f_learning_unit)
if Rails.env.development?
  AdminUser.create!(email: 'admin@example.com', password: 'password',
                    password_confirmation: 'password')
end
