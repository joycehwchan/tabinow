class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :start]

  def home
  end

  def start
    @itinerary = Itinerary.new
  end
end
