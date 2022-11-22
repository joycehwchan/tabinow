class ItinerariesController < ApplicationController
  def index
    @itineraries = policy_scope(Itinerary)
  end
end
