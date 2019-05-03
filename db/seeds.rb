# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin = User.create(first_name: "Cristian", last_name: "Peñaranda", id_number: "1090534221", email: "cristian999@gmail.com", password: "123123123", password_confirmation: "123123123", role: 'admin', confirmed_at: Date.today)

patient_1 = User.create(first_name: "Mark", last_name: "Brown", id_number: "1090534222", email: "markpatient999@gmail.com", password: "123123123", password_confirmation: "123123123")

patient_2 = User.create(first_name: "Mark", last_name: "Brown", id_number: "1090534223", email: "markpatient999@gmail.com", password: "123123123", password_confirmation: "123123123")

doctor = User.create(first_name: "Jose", last_name: "Peñaranda", id_number: "1090534224", email: "josedoctor999@gmail.com", password: "123123123", password_confirmation: "123123123", role: 'doctor')

doctor_2 = User.create(first_name: "David", last_name: "Peñaranda", id_number: "10905342245", email: "daviddoctor999@gmail.com", password: "123123123", password_confirmation: "123123123", role: 'doctor')

procedure_type_1 = ProcedureType.create(procedure_type_name: "Consulta", cost: 20000, procedure_duration: 30)
procedure_type_2 = ProcedureType.create(procedure_type_name: "ECGP", cost: 30000, procedure_duration: 30)

working_week = WorkingWeek.create(initial_date: Date.new(2019, 4, 22), end_date: Date.new(2019, 4, 26), doctor_id: doctor.id)

working_day_monday = WorkingDay.create(working_week_id: working_week.id, working_date: Date.new(2019, 4, 22))
working_day_tuesday = WorkingDay.create(working_week_id: working_week.id, working_date: Date.new(2019, 4, 23))
working_day_wednesday = WorkingDay.create(working_week_id: working_week.id, working_date: Date.new(2019, 4, 24))
working_day_thursday = WorkingDay.create(working_week_id: working_week.id, working_date: Date.new(2019, 4, 25))
working_day_friday = WorkingDay.create(working_week_id: working_week.id, working_date: Date.new(2019, 4, 26))

working_hour_monday = WorkingHour.create(working_day_id: working_day_monday.id, initial_hour: DateTime.parse("2019-04-22 6:00 -0500"), end_hour: DateTime.parse("2019-04-22 12:00 -0500"))
working_hour_tuesday = WorkingHour.create(working_day_id: working_day_tuesday.id, initial_hour: DateTime.parse("2019-04-23 8:00 -0500"), end_hour: DateTime.parse("2019-04-23 10:00 -0500"))
working_hour_tuesday = WorkingHour.create(working_day_id: working_day_tuesday.id, initial_hour: DateTime.parse("2019-04-23 14:00 -0500"), end_hour: DateTime.parse("2019-04-23 18:00 -0500"))
working_hour_wednesday = WorkingHour.create(working_day_id: working_day_wednesday.id, initial_hour: DateTime.parse("2019-04-24 14:00 -0500"), end_hour: DateTime.parse("2019-04-24 18:00 -0500"))
# working_hour_thursday = WorkingHour.create(working_days_id: working_day_thursday.id, initial_hour: DateTime.new(2019, 4, 22, 14, 0, 0), end_hour: DateTime.new(2019, 18, 22, 12, 0, 0))
working_hour_friday = WorkingHour.create(working_day_id: working_day_friday.id, initial_hour: DateTime.parse("2019-04-26 10:00 -0500"), end_hour: DateTime.parse("2019-04-26 12:00 -0500"))

monday_current_week = Date.parse("Monday")
friday_current_week = Date.parse("Friday")

5.times.each do |week|
  current_week = (monday_current_week..friday_current_week).map.to_a
  working_week = WorkingWeek.create(initial_date: monday_current_week, end_date: friday_current_week, doctor_id: doctor.id)

  working_day_monday = WorkingDay.create(working_week_id: working_week.id, working_date: current_week[0])
  working_day_tuesday = WorkingDay.create(working_week_id: working_week.id, working_date: current_week[1])
  working_day_wednesday = WorkingDay.create(working_week_id: working_week.id, working_date: current_week[2])
  working_day_thursday = WorkingDay.create(working_week_id: working_week.id, working_date: current_week[3])
  working_day_friday = WorkingDay.create(working_week_id: working_week.id, working_date: current_week[4])

  working_hour_monday = WorkingHour.create(working_day_id: working_day_monday.id, initial_hour: DateTime.parse("#{current_week[0].to_s} 6:00 -0500"), end_hour: DateTime.parse("#{current_week[0].to_s} 12:00 -0500"))
  working_hour_tuesday = WorkingHour.create(working_day_id: working_day_tuesday.id, initial_hour: DateTime.parse("#{current_week[1].to_s} 8:00 -0500"), end_hour: DateTime.parse("#{current_week[1].to_s} 10:00 -0500"))
  working_hour_tuesday = WorkingHour.create(working_day_id: working_day_tuesday.id, initial_hour: DateTime.parse("#{current_week[1].to_s} 14:00 -0500"), end_hour: DateTime.parse("#{current_week[1].to_s} 18:00 -0500"))
  working_hour_wednesday = WorkingHour.create(working_day_id: working_day_wednesday.id, initial_hour: DateTime.parse("#{current_week[2].to_s} 14:00 -0500"), end_hour: DateTime.parse("#{current_week[2].to_s} 18:00 -0500"))
  # working_hour_thursday = WorkingHour.create(working_days_id: working_day_thursday.id, initial_hour: DateTime.new(2019, 4, 22, 14, 0, 0), end_hour: DateTime.new(2019, 18, 22, 12, 0, 0))
  working_hour_friday = WorkingHour.create(working_day_id: working_day_friday.id, initial_hour: DateTime.parse("#{current_week[4].to_s} 10:00 -0500"), end_hour: DateTime.parse("#{current_week[4].to_s} 12:00 -0500"))

  monday_current_week = monday_current_week.next_week
  friday_current_week = friday_current_week.next_week.sunday - 2
end
