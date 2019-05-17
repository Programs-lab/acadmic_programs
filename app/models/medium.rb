class Medium < ApplicationRecord
  mount_uploader :file_name, MediaUploader
  belongs_to :medical_record
end
