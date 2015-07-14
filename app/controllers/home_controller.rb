class HomeController < ApplicationController

	layout 'application'

  def landing
  	render template: "home/landing", layout: false
  end

  def login
  end
end