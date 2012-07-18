# encoding: UTF-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :facebook_app
  URL = "http://www.orce.uni.edu.pe/"
  # http://www.orce.uni.edu.pe/recordNotas.php?op=cursos&flag=notas
  # http://www.orce.uni.edu.pe/recordNotas.php?op=notas&tipo=Teoria&codcur=GP102&facul=I&codsec=V
  # http://www.orce.uni.edu.pe/recordNotas.php?op=notas&tipo=Practicas&codcur=GP102&facul=I&codsec=V
  # Se muestran las tablas tal cual, para evitar problemas en # de practicas, monografias, laboratorios, etc
  def tabla_notas_de user
    cursos = []

    agent = Mechanize.new
    params = {"txtusu" => user.codigo, "txtcla" => user.password}
    agent.post( URL + "logeo.php", params)
    agent.get URL + "recordNotas.php?op=cursos&flag=notas"
    pag = agent.page
    a=[]
    pag.parser.css('tr.fila td').each do |f|
      a << f.text
    end

    n = a.size/5

    (1..n).each do |i|   
      ans = { curso: "", codigo: "", seccion: "", notas: {} }
      ind = (i-1)*5
      curso = a[ind.. ind+4]
      ans[:codigo] = curso[0]
      ans[:curso] = curso[1]
      ans[:seccion] = curso[2]

      practicas = obtener_notas_de "Practicas", ans[:codigo], ans[:seccion], agent
      examenes = obtener_notas_de "Teoria", ans[:codigo], ans[:seccion], agent

      ans[:notas] = { practicas: practicas, examenes: examenes}
      cursos << ans
    end
    cursos
  end

  def obtener_notas_de evaluacion, codigo, seccion, agent
    agent.get URL+"recordNotas.php?op=notas&tipo=#{evaluacion}&codcur=#{codigo}&facul=I&codsec=#{seccion}"
    pag_evaluacion = agent.page

    evaluacion=[]
    pag_evaluacion.parser.css("tr td").each_slice(4) do |f|
      ans = []
      f.each do |c|
         ans << c.content.gsub(/\u00a0/, '') #&nbsp
      end
      evaluacion<<ans
    end
    evaluacion.delete_at(0)
    evaluacion
  end

  # 	cursos = Hash.new{ |a, b| a[b] = Hash.new { |hash, key| hash[key] =Array.new  } }
  #   cursos = { 'practicas' => [1,2,3], 'examenes' => [10,20] }

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
