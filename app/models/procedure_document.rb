class ProcedureDocument < ApplicationRecord
  belongs_to :document
  belongs_to :procedure
  mount_uploader :procedure_document_file, MediaUploader
end
