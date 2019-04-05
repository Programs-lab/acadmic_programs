class Company < ApplicationRecord
  has_many :users
  has_many :procedure_companies
end
