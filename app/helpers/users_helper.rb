module UsersHelper

  def age(patient)
    if patient.birthdate
      if Date.today.month > patient.birthdate.month
        age = Date.today.year - patient.birthdate.year
      else
        age = Date.today.year - patient.birthdate.year - 1
      end
    else
      age = "Desconocido"  
    end
    age
  end
end
