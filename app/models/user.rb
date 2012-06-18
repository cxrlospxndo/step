# encoding: UTF-8 
# encoding: utf-8
class User < ActiveRecord::Base
  has_one :info, :dependent => :destroy
  attr_accessible :codigo, :password
  def build_info 
    agent = Mechanize.new
    cod = codigo.upcase 
    url = "http://www.orce.uni.edu.pe/detaalu.php?id=#{cod}&op=detalu"

    page = agent.get url  

    a = []
    page.parser.css("tr td").each do |f|
      a << f.text
    end
    info = Info.new
    info.user_id = id
    info.fullname = a[6].split("-").join(" ").downcase.titleize
    info.facultad = a[9].downcase.titleize.gsub(/Í/, 'í').gsub(/De/, 'de').gsub(/Y/, 'y')
    info.esp = a[12].downcase.titleize.gsub(/Í/, 'í').gsub(/De/, 'de')
    info.situacion = a[15].downcase
    info.medisc = a[18].downcase
    info.ciclo = page.parser.xpath('//td[@bgcolor="#ffffff"]').first.text[1].to_i - 1
    info.pic = "http://www.orce.uni.edu.pe/" + page.parser.css("img")[3]['src']
    info.save
   end

end
