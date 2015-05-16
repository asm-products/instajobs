class HomeController < ApplicationController
  def landing
  	render template: "home/landing", layout: false
  end

  def index
  end
end