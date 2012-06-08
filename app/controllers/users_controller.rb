class UsersController < ApplicationController

  def index
    @users = User.all

    respond_to do |format|
      format.html 
      format.json { render json: @users, :only =>[:codigo]}
    end
  end

  def show
    @user = User.find(params[:id])
    ############ info [fn, fac, crr, pic]####3
    @info = info @user.codigo
    ############ cursos => {pp, ex}##########3
    @cur = cursos @user.codigo, @user.password
    #########################################3

    respond_to do |format|
      format.html 
      format.json { render json: @user, :only =>[:codigo, :created_at] }
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
    @user = User.new(params[:user])
    if valid? params[:user]
      @user.save
      redirect_to @user
    end
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user } 
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
