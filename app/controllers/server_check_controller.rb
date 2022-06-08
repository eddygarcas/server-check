class ServerCheckController < ApplicationController

  def index
    render json: 'Server ok!', status: 200
  end

end
