# encoding: utf-8
class UsersController < ApplicationController

  def index
    respond_to do |format|
      format.html 
    end
  end

  def show

    @user = User.find(params[:id].upcase) #upcase para la letra del codigo
    #raise @user.to_yaml
    if session[:user_id] == @user.id
      @info = @user.info
      @cursos = tabla_notas_de @user
      respond_to do |format|
        format.html 
        format.json { render json: @user, :only =>[:codigo, :created_at], :include => :info }
        format.pdf do
          pdf = UserPdf.new(@user, @cursos)
          send_data pdf.render, filename: "#{@user.codigo}.pdf",
                                type: "application/pdf",
                                disposition: "inline"
        end
      end
    else
      redirect_to root_path, notice: "Acceso denegado"
    end
  end

  def new
    @user = User.new

    respond_to do |format|
      format.html 
      format.json { render json: @user, :only =>[:codigo, :created_at] }
    end
  end

  def edit
    @user = User.find(params[:id])
    if session[:user_id] != @user.id
      redirect_to users_url, notice: "Acceso denegado"
    end
  end

  def create
    if valid? params[:user]
      @user = User.find_or_create_by_codigo_and_password(params[:user][:codigo].upcase, params[:user][:password])
      @info = @user.build_info if @user.info == nil
      session[:user_id] = @user.id
      @ses = session[:user_id]
      redirect_to @user
    else
      redirect_to new_user_path
    end
  end

  def update
    @user = User.find(params[:id])
    if session[:user_id] == @user.id
      respond_to do |format|
        if @user.update_attributes(params[:user])
          @info = @user.build_info if @user.info == nil
          format.html { redirect_to @user } 
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to users_url, notice: "Acceso denegado"
    end
  end

  def destroy
    @user = User.find(params[:id])
    if session[:user_id] == @user.id
      
      session[:user_id] = nil
      @info = Info.delete @user.info.user_id
      @user.destroy

      respond_to do |format|
        format.html { redirect_to users_url }
        format.json { head :no_content }
      end
    else
      redirect_to users_url, notice: "Acceso denegado"
    end
  end
end
