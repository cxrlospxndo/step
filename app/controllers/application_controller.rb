class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :facebook_app
  #http://www.orce.uni.edu.pe/recordNotas.php?op=notas&tipo=Practicas&codcur=GP102&facul=I&codsec=V

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
      examenes = []

      page4.parser.css("tr td").each do |cont|
        examenes << cont.content
      end

      #examenes = Hash.new{ |a,b| a[b]= Array.new }
      ind = (examenes.size - 1)/4

      (1..ind).each do |i|
        y = i * 4
        x = y - 2
        z = x - 1
        #examenes[ex[z][0..-2]] = ex[x..y]
        cursos[examenes[z][0..-2]]['examenes'] = examenes[x..y]
      end

      practicas =[]

      page3.parser.xpath("//tr/td").each do |cont|
        practicas << cont.content
      end

      periodo = practicas[0]

      index = (practicas.size - 1)/7
      (1..index).each do |i|
        y = i * 7
        x = y - 5
        z = x - 1
        #cod = a[z][0..-2]
        #cursos[cod] = { 'practicas' => a[ x..y], 'examenes' => examenes[cod] }
        cursos[practicas[z][0..-2]]['practicas'] = practicas[x..y]
      end

      # puts periodo
      # cursos.each {|curso| puts curso.inspect }
      # puts cursos.inspect 
      # puts cursos['GP102V'].inspect
    end
    cursos
  end
  public
  def valid? params
    param = { "txtcla" => params[:password], "txtusu" => params[:codigo]}
    url = URI('http://www.orce.uni.edu.pe/logeo.php')
    res = Net::HTTP.post_form url, param
    if res.body =~ /Error/ 
      return false
    end 
    true
  end

  private
  
  def current_user
    @current_user ||= User.find( session[:user_id] ) if session[:user_id]
  end

  def facebook_app
    if session[:uid]
      @facebook_app = true
    else
      @facebook_app = false
    end
  end

  def user_from_signed_request signed_request
    oauth = Koala::Facebook::OAuth.new(ENV['facebook-id'], ENV['facebook-secret'], "/auth/facebook/callback")
    signed_request = oauth.parse_signed_request( signed_request ) 
    uid = signed_request["user_id"]
    graph = Koala::Facebook::API.new(signed_request["oauth_token"])
    info = graph.get_object( uid )
    image = graph.get_picture( uid )
    # fql = graph.fql_query("SELECT name, email FROM user WHERE uid=#{signed_request["user_id"]}")
    user = User.find_by_provider_and_uid( "facebook", uid) || User.create_from_app(uid, info["name"], image, info["email"])
  end
end
