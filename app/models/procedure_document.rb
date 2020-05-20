class ProcedureDocument < ApplicationRecord
  belongs_to :document
  belongs_to :procedure
  has_many :comments
  mount_uploader :procedure_document_file, MediaUploader
end
