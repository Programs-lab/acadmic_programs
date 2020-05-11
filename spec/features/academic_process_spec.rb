require "rails_helper"

RSpec.describe "Academic Process", js: true do
  before do
    create(:user, :confirmed, email: "test@ufps.edu.co", password: "defaultpw", id_number: "1090", role: "admin")
    visit(new_user_session_path)
    login(email: "test@ufps.edu.co", password: "defaultpw")
  end

  it "Create academic process workflow" do
    # click on Procesos menu button
    click_on "Procesos"

    # click on button for create a new academic process
    click_on "Crear un proceso"

    # fill academic process form data
    fill_in "academic_process[name]", with: "Process test"
    fill_in "academic_process[year_saces]", with: "1"
    fill_in "academic_process[month_saces]", with: "2"
    fill_in "academic_process[day_saces]", with: "3"
    fill_in "academic_process[year_academic_council]", with: "1"
    fill_in "academic_process[month_academic_council]", with: "2"
    fill_in "academic_process[day_academic_council]", with: "3"

    click_on "Registrar"

    expect(page).to have_current_path(academic_processes_path)
    expect(page).to have_text("El proceso ha sido creada exitodamente")
    expect(page).to have_text("Process test")
    expect(AcademicProcess.count).to eq(1)
  end
  
  it "Edit academic process workflow" do
    create(:academic_process, name: "Process test", year_saces: "1", month_saces: "2", day_saces: "3", year_academic_council: "1", month_academic_council: "2", day_academic_council: "3")

    # click on Procesos menu button
    click_on "Procesos"
    
    # click on button for edit an academic process
    click_on "edit_academic_process"

    # re-fill academic process form data
    fill_in "academic_process[name]", with: "Process test"
    fill_in "academic_process[year_saces]", with: "4"
    fill_in "academic_process[month_saces]", with: "5"
    fill_in "academic_process[day_saces]", with: "6"
    fill_in "academic_process[year_academic_council]", with: "7"
    fill_in "academic_process[month_academic_council]", with: "8"
    fill_in "academic_process[day_academic_council]", with: "9"

    click_on "Registrar"

    expect(page).to have_current_path(academic_processes_path)
    expect(page).to have_text("El proceso fue actualizada exitosamente.")
    expect(page).to have_text("4 Año/s 5 Mes/es 6 Dia/s")
    expect(page).to have_text("7 Año/s 8 Mes/es 9 Dia/s")
    expect(AcademicProcess.count).to eq(1)
  end

  it "Delete academic process workflow" do
    create(:academic_process, name: "Process test", year_saces: "1", month_saces: "2", day_saces: "3", year_academic_council: "1", month_academic_council: "2", day_academic_council: "3")

    # click on Procesos menu button
    click_on "Procesos"

    # click on button for edit an academic process
    click_on "edit_academic_process"

    # click on trash button and open the modal
    page.find("#trash_button").click

    # click on eliminar button for delete the academic process
    sleep 1
    click_on "Eliminar"

    expect(page).to have_current_path(academic_processes_path)
    expect(page).to have_text("El proceso fue eliminada correctamente.")
    expect(page).not_to have_text("1 Año/s 2 Mes/es 3 Dia/s")
    expect(AcademicProcess.count).to eq(0)
  end
end
