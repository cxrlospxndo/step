class ApplicationController < ActionController::Base
  protect_from_forgery
  public
  def info codigo
  	agent = Mechanize.new
    cod = codigo
    url = "http://www.orce.uni.edu.pe/detaalu.php?id=#{cod}&op=detalu"

    page = agent.get url  

    a = []
    i = 0
    p = [7, 10, 13]
    page.parser.css("tr td").each do |f|
      (a << f.text) if p.include? i+=1
    end
    b = page.parser.css("img")[3]['src']
    b = "http://www.orce.uni.edu.pe/" + b
    a<<b
    a
  end

  def cursos codigo, password
	cursos = Hash.new{ |a, b| a[b] = Array.new }
    agent1 = Mechanize.new
    agent1.get("http://www.orce.uni.edu.pe/movil/") do |page| 
      page2 = page.form do |f|  
        f.clave = @user.password
        f.codigo = @user.codigo
      end.submit

      page3 = page2.links.first.click

      a =[]
      page3.parser.xpath("//tr/td").each do |cont|
        a << cont.content
      end
	  #periodo = a[0]

      (1..4).each do |i|
        y = i * 7
        x = y - 5
        z = x - 1
        cursos[a[z][0..-2]] = a[ x..y ]
      end
    end
    cursos
  end
end
