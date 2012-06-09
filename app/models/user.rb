class User < ActiveRecord::Base
  attr_accessible :codigo, :password

  def fullname

    agent = Mechanize.new
    cod = self.codigo.upcase
    url = "http://www.orce.uni.edu.pe/detaalu.php?id=#{cod}&op=detalu"

    page = agent.get url  

    a = []
    i = 0
    p = [7, 10, 13]
    page.parser.css("tr td").each do |f|
      (a << f.text) if p.include? i+=1
    end
    @full = a[0]
  	a[0].split("-").join(" ").downcase.titleize 

  end

  def pic
  	agent = Mechanize.new
    cod = codigo.upcase
    url = "http://www.orce.uni.edu.pe/detaalu.php?id=#{cod}&op=detalu"

    page = agent.get url  

    b = page.parser.css("img")[3]['src']
    b = "http://www.orce.uni.edu.pe/" + b
    b
  end
end
