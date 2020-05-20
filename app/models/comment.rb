class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :procedure_document
end
