require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_db_column(:first_name).of_type(:string).with_options(null: false) }
  it { should have_db_column(:last_name).of_type(:string).with_options(null: false, unique: true) }
  it { should have_db_column(:id_number).of_type(:string).with_options(null: false) }
  it { should have_db_column(:email).of_type(:string).with_options(null: false) }

end
