class Document < ApplicationRecord
  belongs_to :academic_process
  mount_uploader :template, MediaUploader
end
