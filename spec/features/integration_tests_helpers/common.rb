module IntegrationTestHelpers
  module Common
    def login(email:, password:)
      ensure_on new_user_session_path
      fill_in "user[email]", with: email
      fill_in "user[password]", with: password
      click_button "Iniciar sesion"
    end

    def ensure_on(path)
      visit(path) unless current_path == path
    end

    def in_browser(name)
      old_session = Capybara.session_name

      Capybara.session_name = name
      yield

      Capybara.session_name = old_session
    end
  end
end
