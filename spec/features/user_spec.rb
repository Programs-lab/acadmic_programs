require "rails_helper"

RSpec.describe "User", js: true do
  before do
    create(:user, :confirmed, email: "test@ufps.edu.co", password: "defaultpw", id_number: "1090", role: "admin")
    visit(new_user_session_path)
    login(email: "test@ufps.edu.co", password: "defaultpw")
  end

  it "Create user workflow" do
    # click on Usuarios menu button
    click_on "Usuarios"

    # click on button for create a new user
    click_on "Crear un usuario"

    # fill user form data
    fill_in "user[first_name]", with: "Director test"
    fill_in "user[last_name]", with: "Last name"
    select "Cédula de Ciudadanía", from: "user[id_type]"
    fill_in "user[id_number]", with: "123"
    select "Pregrado", from: "user[modality]"
    fill_in "user[email]", with: "director@ufps.edu.co"
    select "Director", from: "user[role]"

    click_on "Registrar"

    expect(page).to have_current_path(admin_users_path)
    expect(page).to have_text("El usuario fue creado exitosamente.")
    expect(page).to have_text("Director test")
    expect(User.count).to eq(2)
  end
  
  it "Edit user workflow" do
    create(:user, :confirmed, first_name: "Director test", last_name: "Last name", id_number: "123", role: :director)

    # click on Usuarios menu button
    click_on "Usuarios"
    
    # click on button for edit an user
    click_on "edit_user"

    # re-fill user form data
    fill_in "user[first_name]", with: "Director updated"
    fill_in "user[last_name]", with: "Last name 2"
    select "Cédula de Ciudadanía", from: "user[id_type]"
    fill_in "user[id_number]", with: "456"
    select "Pregrado", from: "user[modality]"
    fill_in "user[email]", with: "director@ufps.edu.co"
    select "Director", from: "user[role]"

    click_on "Registrar"

    expect(page).to have_current_path(admin_users_path)
    expect(page).to have_text("El usuario fue actualizado exitosamente.")
    expect(page).to have_text("Director updated")
    expect(page).to have_text("Last name 2")
    expect(page).to have_text("Pregrado")
    expect(User.count).to eq(2)
  end

  it "Disable user workflow" do
    create(:user, :confirmed, first_name: "Director test", last_name: "Last name", id_number: "123", role: :director)

    # click on Usuarios menu button
    click_on "Usuarios"
    
    # click on button for edit an user
    click_on "edit_user"

    # click on Deshabilitar for open modal
    page.find("#myBtn").click

    # click on Deshabilitar for disable a user
    sleep 1
    click_on "Deshabilitar"

    expect(page).to have_text("El usuario fue deshabilitado exitosamente.")
    expect(User.count).to eq(2)
  end
end
