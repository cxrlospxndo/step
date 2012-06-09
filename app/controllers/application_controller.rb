class ApplicationController < ActionController::Base
  protect_from_forgery

  public
  def info codigo
  	agent = Mechanize.new
    cod = codigo.upcase
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
  	cursos = Hash.new{ |a, b| a[b] = Hash.new { |hash, key| hash[key] =Array.new  } }

    # notas = { 'practicas' => [1,2,3], 'examenes' => [10,20] }
    # cursos['cbalgo'] = notas

    # puts cursos.inspect
    # puts cursos['cbalgo']['practicas'].inspect

    agent1 = Mechanize.new
    agent1.get("http://www.orce.uni.edu.pe/movil/") do |page| 

      page2 = page.form do |f|  
        f.clave = @user.password
        f.codigo = @user.codigo
      end.submit

      page3 = page2.links.first.click   # practicas
      page4 = page2.links[1].click      # examenes
      ex = []

      page4.parser.css("tr td").each do |cont|
        ex << cont.content
      end

      examenes = Hash.new{ |a,b| a[b]= Array.new }
      ind = (ex.size - 1)/4

      (1..ind).each do |i|
        y = i * 4
        x = y - 2
        z = x - 1
        examenes[ex[z][0..-2]] = ex[x..y]
      end

      a =[]

      page3.parser.xpath("//tr/td").each do |cont|
        a << cont.content
      end

      periodo = a[0]

      index = (a.size - 1)/7
      (1..index).each do |i|
        y = i * 7
        x = y - 5
        z = x - 1
        cod = a[z][0..-2]
        cursos[cod] = { 'practicas' => a[ x..y], 'examenes' => examenes[cod] }
      end

      # puts periodo
      # cursos.each {|curso| puts curso.inspect }
      # puts cursos.inspect 
      # puts cursos['GP102V'].inspect
    end
    cursos
  end
  def valid? params
    url = URI('http://www.orce.uni.edu.pe/logeo.php')
    res = Net::HTTP.post_form url, params
    res.body =~ /Error/ ? true:false
  end
end
