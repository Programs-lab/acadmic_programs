require "rails_helper"

RSpec.describe "Sign In", js: true do
  context "admin" do
    before do
      create(:user, :confirmed, email: "test@ufps.edu.co", password: "defaultpw", id_number: "1090", role: 1)
      visit(new_user_session_path)
    end

    it "successfully" do
      login(email: "test@ufps.edu.co", password: "defaultpw")
      expect(page).to have_current_path(admin_users_path)
      expect(page).to have_text("Sesión iniciada.")
    end

    it "invalid" do
      login(email: "test@ufps.edu.co", password: "defaultbadpw")
      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_text("Email o contraseña inválidos.")
    end
  end

  context "director" do
    before do
      create(:user, :confirmed, email: "test@ufps.edu.co", password: "defaultpw", id_number: "1090", role: 0)
      visit(new_user_session_path)
    end

    it "No assign to academic program" do
      login(email: "test@ufps.edu.co", password: "defaultpw")
      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_text("No tiene asignado ningun programa academico")
    end
  end
end
