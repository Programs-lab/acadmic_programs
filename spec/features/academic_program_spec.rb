require "rails_helper"

RSpec.describe "Academic Program", js: true do
  let!(:faculty) { create(:faculty) }

  before do
    create(:user, :confirmed, email: "test@ufps.edu.co", password: "defaultpw", id_number: "1090", role: "admin")
    visit(new_user_session_path)
    login(email: "test@ufps.edu.co", password: "defaultpw")
  end

  it "Create academic program workflow" do    
    # click on Facultades menu button
    click_on "Facultades"

    # click on button for visit index of academic programs
    page.find("#academic_program_button").click

    # click on button for create a academic program
    click_on "Crear un programa academico"

    # fill academic program form data
    fill_in "academic_program[name]", with: "Program test"
    fill_in "academic_program[code]", with: "115"
    fill_in "academic_program[email]", with: "academic_program@test.edu.co"

    click_on "Registrar"

    expect(page).to have_current_path(faculty_academic_programs_path(faculty))
    expect(page).to have_text("El programa fue creado exitosamente")
    expect(page).to have_text("Program test")
    expect(AcademicProgram.count).to eq(1)
  end
  
  it "Edit academic program workflow" do
    create(:academic_program, name: "Program test", faculty: faculty)

    # click on Facultades menu button
    click_on "Facultades"
    
    # click on button for visit index of academic programs
    page.find("#academic_program_button").click

    # click on edit academic program button
    page.find("#edit_academic_program").click

    # re-fill academic program form data
    fill_in "academic_program[name]", with: "Program updated"
    fill_in "academic_program[email]", with: "academic_program@test.edu.co"

    click_on "Registrar"

    expect(page).to have_current_path(faculty_academic_programs_path(faculty))
    expect(page).to have_text("El programa fue actualizado exitosamente")
    expect(page).to have_text("Program updated")
    expect(AcademicProgram.count).to eq(1)
  end

  it "Delete academic program workflow" do
    create(:academic_program, name: "Program test", faculty: faculty)

    # click on Facultades menu button
    click_on "Facultades"

    # click on button for visit index of academic programs
    page.find("#academic_program_button").click

    # click on edit academic program button
    page.find("#edit_academic_program").click

    # click on trash button and open the modal
    page.find("#myBtn").click

    # click on eliminar button for delete the academic program
    sleep 1
    click_on "Eliminar"

    expect(page).to have_current_path(faculty_academic_programs_path(faculty))
    expect(page).to have_text("El programa fue eliminado exitosamente")
    expect(page).not_to have_text("Program test")
    expect(AcademicProgram.count).to eq(0)
  end
end
