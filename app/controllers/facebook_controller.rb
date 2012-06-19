class FacebookController < ApplicationController

	def create

		@user = user_from_signed_request params[:signed_request] 
		session[:user_id] = @user.id
		session[:uid] = @user.uid
		if @user.codigo == nil
			redirect_to edit_user_path @user
		else
			redirect_to @user
		end
	end

	def failure
		redirect_to root_url, :notice => "Access denied"
	end
end