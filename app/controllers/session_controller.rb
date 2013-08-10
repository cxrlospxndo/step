class SessionController < ApplicationController

	def new
  end

  def create
      session[:codigo] = params[:codigo]
      session[:password] = params[:password]
      redirect_to :action => 'show'
  end

  def show
    @notas = Uni.notas session[:codigo], session[:password]
    redirect_to(:action => 'create') unless @notas
    @data = Uni.data session[:codigo]

    respond_to do |format|
      format.html
      format.xls { send_data (ApplicationHelper.to_csv(@data, @notas, "\t")),
                             filename: "#{session[:codigo]}.xls", #.XLS
                             type: "application/vnd.ms-excel", #application/octet-stream
                             disposition: "attachment"}
      format.pdf do
        pdf = SessionPdf.new(@data, @notas)
        # cookies are not supported on some devices
        send_data pdf.render, filename: "#{session[:codigo]}.pdf",
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