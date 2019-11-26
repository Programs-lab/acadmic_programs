class Medium < ApplicationRecord
  mount_uploader :file_name, MediaUploader
  belongs_to :processes_academic_program
  after_create :asign_url
  
  def asign_url
    self.update(url: self.file_name.url)
  end
end
