require "rails_helper"

RSpec.describe "Procedure", js: true do
  let!(:academic_process) { create(:academic_process) }
  let!(:academic_program) { create(:academic_program, name: "Academic program") }

  before do
    create(:user, :confirmed, email: "test@ufps.edu.co", password: "defaultpw", id_number: "1090", role: "admin")
    visit(new_user_session_path)
    login(email: "test@ufps.edu.co", password: "defaultpw")
  end

  it "Create process workflow" do    
    # click on Facultades menu button
    click_on "Facultades"

    # navigate to procedures of a academic process
    page.find("#academic_program_button").click
    page.find("#academic_process_button").click
    page.find("#procedure_button").click

    # click on button for open modal
    page.find("#add_procedure_button").click

    # set value of hidden field
    page.execute_script("document.getElementById('procedure_procedure_date').value= 'Fri May 01 2020 16:41:00 GMT-0500 (Colombia Standard Time)'")

    # save procedure
    sleep 2
    click_on "Aceptar"

    expect(page).to have_text("El tramite fue creado exitosamente")

    click_on "Volver"

    expect(page).to have_text("2020-05-01")
    expect(Procedure.count).to eq(1)
  end
end
