class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :facebook_app
  # Ahora usando 
  # http://www.orce.uni.edu.pe/recordNotas.php?op=cursos&flag=notas
  # http://www.orce.uni.edu.pe/recordNotas.php?op=notas&tipo=Teoria&codcur=GP102&facul=I&codsec=V
  # http://www.orce.uni.edu.pe/recordNotas.php?op=notas&tipo=Practicas&codcur=GP102&facul=I&codsec=V
  # Se muestran las tablas tal cual, para evitar problemas en # de practicas, monografias, laboratorios, etc
  def tabla_notas_de codigo, password
    cursos = []
    agent = Mechanize.new
    uri = "http://www.orce.uni.edu.pe/"
    params = {"txtusu" => "20072531G", "txtcla" => "91424"}
    agent.post( uri + "logeo.php", params)
    agent.get uri + "recordNotas.php?op=cursos&flag=notas"

    pag = agent.page
    a=[]
    pag.parser.css('tr.fila td').each do |f|
      a << f.text
    end

    n = a.size/5

    (1..n).each do |i|   #0..4, 5..9, 10..14, 15..19
      ind = (i-1)*5
      curso = a[ind.. ind+4]
      ans = { curso: "", codigo: "", seccion: "", html: "" }
      ans[:codigo] = curso[0]
      ans[:curso] = curso[1]
      ans[:seccion] = curso[2]

      agent.get uri + "recordNotas.php?op=notas&tipo=Practicas&codcur=#{ans[:codigo]}&facul=I&codsec=#{ans[:seccion]}"
      pag_practicas = agent.page
      ans[:html] = pag_practicas.body.html_safe

      agent.get uri + "recordNotas.php?op=notas&tipo=Teoria&codcur=#{ans[:codigo]}&facul=I&codsec=#{ans[:seccion]}"
      pag_examenes = agent.page
      ans[:html] += pag_examenes.body.html_safe

      cursos << ans
    end

    cursos
  end

  # v1.0 
  # Obsoleto
  # def cursos codigo, password
  # 	cursos = Hash.new{ |a, b| a[b] = Hash.new { |hash, key| hash[key] =Array.new  } }

  #   # notas = { 'practicas' => [1,2,3], 'examenes' => [10,20] }

  #   agent1 = Mechanize.new
  #   agent1.get("http://www.orce.uni.edu.pe/movil/") do |page| 

  #     page2 = page.form do |f|  
  #       f.clave = @user.password
  #       f.codigo = @user.codigo
  #     end.submit

  #     page3 = page2.links.first.click   # practicas
  #     page4 = page2.links[1].click      # examenes
  #     examenes = []

  #     page4.parser.css("tr td").each do |cont|
  #       examenes << cont.content
  #     end
  #     ind = (examenes.size - 1)/4

  #     (1..ind).each do |i|
  #       y = i * 4
  #       x = y - 2
  #       z = x - 1
  #       cursos[examenes[z][0..-2]]['examenes'] = examenes[x..y]
  #     end

  #     practicas =[]

  #     page3.parser.xpath("//tr/td").each do |cont|
  #       practicas << cont.content
  #     end

  #     periodo = practicas[0]

  #     index = (practicas.size - 1)/7
  #     (1..index).each do |i|
  #       y = i * 7
  #       x = y - 5
  #       z = x - 1
  #       cursos[practicas[z][0..-2]]['practicas'] = practicas[x..y]
  #     end
  #   end
  #   cursos
  # end

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
