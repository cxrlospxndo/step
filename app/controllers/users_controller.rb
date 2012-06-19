# encoding: utf-8
class UsersController < ApplicationController

  def index
    @users = User.all

    respond_to do |format|
      format.html 
      format.json { render json: @users, :only =>[:codigo]}
    end
  end

  def show
    if current_user.id = params[:id]
      @user = User.find(params[:id])
      @info = @user.info
      @cur = cursos @user.codigo, @user.password

      respond_to do |format|
        format.html 
        format.json { render json: @user, :only =>[:codigo, :created_at], :include => :info }
      end
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
  end

  def create
    if valid? params[:user]
      @user = User.find_or_create_by_codigo_and_password(params[:user][:codigo].upcase, params[:user][:password])
      @info = @user.build_info if @user.info == nil
      session[:user_id] = @user.id
      redirect_to @user
    else
      redirect_to new_user_path
    end
  end

  def update
    @user = User.find(params[:id])

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
  end

  def destroy
    session[:user_id] = nil
    @user = User.find(params[:id])
    @info = @user.info.destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
