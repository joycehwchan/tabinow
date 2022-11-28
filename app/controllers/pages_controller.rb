class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @itinerary = Itinerary.new
  end
end
