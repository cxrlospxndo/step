class SessionController < ApplicationController

	def new

  end
  def create
    tmp = Uni.notas params[:codigo], params[:password]
    if tmp.empty?
      reset_session
      #flash['notice'] = 'codigo y/o password invalidos'
      render 'new'
    else
      session[:notas] = tmp
      session[:data] = Uni.data params[:codigo]
      session[:codigo] = params[:codigo]
      session[:password] = params[:password]
      redirect_to :action => 'show'
    end
  end
  def show
    @data = session[:data]
    @notas = session[:notas]
    respond_to do |format|
      format.html
      format.xls { send_data (ApplicationHelper.to_csv(@data, @notas, "\t")),
                             filename: "#{@data[:codigo]}.xls", #.XLS
                             type: "application/vnd.ms-excel", #application/octet-stream
                             disposition: "attachment"}
      format.pdf do
        pdf = SessionPdf.new(@data, @notas)
        send_data pdf.render, filename: "#{@data[:codigo]}.pdf",
                  type: "application/pdf",
                  disposition: "attachment"
      end
    end
  end

	def destroy
		reset_session
		redirect_to root_url, :notice => "Signed out"
	end

	def failure
		redirect_to root_url, :notice => "Access denied"
	end
end