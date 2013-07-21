# encoding: UTF-8 
# encoding: utf-8
class User < ActiveRecord::Base
  has_one :info, :dependent => :destroy
  attr_accessible :codigo, :password
  extend FriendlyId
  friendly_id :codigo
  def build_info 
    agent = Mechanize.new
    cod = codigo.upcase 
    url = "http://www.orce.uni.edu.pe/detaalu.php?id=#{cod}&op=detalu"

    page = agent.get url  

    a = []
    page.parser.css('tr td').each do |f|
      a << f.text
    end
    info = Info.new
    info.user_id = id
    info.fullname = a[6].split('-').join(' ').downcase.titleize
    info.facultad = a[9].downcase.titleize.gsub(/Í/, 'í').gsub(/De/, 'de').gsub(/Y/, 'y')
    info.esp = a[12].downcase.titleize.gsub(/Í/, 'í').gsub(/De/, 'de')
    info.situacion = a[15].downcase
    info.medisc = a[18].downcase
    info.ciclo = page.parser.xpath('//td[@bgcolor!="#ffffff"]').last.text.gsub(/[.]/, '').to_i rescue ' '
    info.pic = 'http://www.orce.uni.edu.pe/' + page.parser.css('img')[3]['src']
    info.save
  end

  def self.create_with_omniauth (auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      #user.image = (auth["info"]["image"] || "default.png")
      #user.email = auth["info"]["email"]
    end
  end
  def self.create_from_app uid, name, image, email
    create! do |user|
      user.provider = "facebook"
      user.uid = uid
      user.name = name
      user.image = (image || "default.png")
      #user.email = email
    end   
  end
  def to_csv cursos, f
    CSV.generate(f) do |csv|
      csv << [codigo, info.fullname]
      csv << []
      cursos.each do |c|
        csv << [c[:curso]+c[:codigo]+c[:seccion]]
        csv << ["Tipo de Examen", "Nota", "Reclamo", "%Desaprobados"]
        c[:notas][:practicas].each do |row|
          csv << row
        end  
        c[:notas][:examenes].each do |row|
          csv << row
        end
        csv << []
      end
    end
  end

end
