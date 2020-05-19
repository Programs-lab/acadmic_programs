require "rails_helper"

RSpec.describe "Faculty", js: true do
  before do
    create(:user, :confirmed, email: "test@ufps.edu.co", password: "defaultpw", id_number: "1090", role: "admin")
    visit(new_user_session_path)
    login(email: "test@ufps.edu.co", password: "defaultpw")
  end

  it "Create faculty workflow" do
    # click on Facultades menu button
    click_on "Facultades"

    # click on button for create a new faculty
    click_on "Crear una facultad"

    # fill faculty form data
    fill_in "faculty[name]", with: "Faculty test"
    fill_in "faculty[code]", with: "123"
    click_on "Registrar"

    expect(page).to have_current_path(faculties_path)
    expect(page).to have_text("La facultad ha sido creada exitodamente")
    expect(page).to have_text("Faculty test")
    expect(Faculty.count).to eq(1)
  end
  
  it "Edit faculty workflow" do
    create(:faculty, name: "Faculty test", code: "123")

    # click on Facultades menu button
    click_on "Facultades"
    
    # click on button for edit a faculty
    click_on "edit_faculty"

    # re-fill faculty form data
    fill_in "faculty[name]", with: "Faculty test updated"
    fill_in "faculty[code]", with: "456"
    click_on "Registrar"

    expect(page).to have_current_path(faculties_path)
    expect(page).to have_text("La facultad fue actualizada exitosamente.")
    expect(page).to have_text("Faculty test updated")
    expect(Faculty.count).to eq(1)
  end

  it "Delete faculty workflow" do
    create(:faculty, name: "Faculty test", code: "123")

    # click on Facultades menu button
    click_on "Facultades"

    # click on button for edit a faculty
    click_on "edit_faculty"

    # click on trash button and open the modal
    page.find("#trash_button").click

    # click on eliminar button for delete the faculty
    sleep 1
    click_on "Eliminar"

    expect(page).to have_current_path(faculties_path)
    expect(page).to have_text("La facultad fue eliminada correctamente.")
    expect(page).not_to have_text("Faculty test")
    expect(Faculty.count).to eq(0)
  end
end
