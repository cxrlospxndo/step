class Info < ActiveRecord::Base
	belongs_to :user
  attr_accessible :ciclo, :esp, :facultad, :fullname, :medisc, :pic, :situacion

end

