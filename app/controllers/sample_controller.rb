class SampleController < ApplicationController

  def main
  end

  def index
  end

  def data
    @data = Uni.data params[:codigo]
    respond_to do |format|
      format.html
      format.json { render json: @data.to_json }
    end
  end
end
