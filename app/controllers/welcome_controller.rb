class WelcomeController < ApplicationController
  def index
    render plain: "Welcome to my project"
  end
end
