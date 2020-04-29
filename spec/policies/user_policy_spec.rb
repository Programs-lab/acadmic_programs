require 'rails_helper'

RSpec.describe UserPolicy do
  subject { described_class }

   permissions :index?, :create?, :update?, :invite?, :enable?, :disable? do
    it "denies access if user is not admin", skip: true do
      expect(subject).not_to permit(User.new(role: :patient))
    end
   end

end
