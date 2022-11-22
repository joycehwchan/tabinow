class ItinerariesController < ApplicationController
  before_action :set_itinerary, except: %i[index new create]
  skip_before_action :authenticate_user!, only: :create

  def index
    @itineraries = policy_scope(Itinerary)
  end

  def show
    # this is to create a new day in the itinerary show page
    # @itinerary.day = Day.new
  end

  def new
    @itinerary = Field.new
    authorize @itinerary
  end

  def create
    set_new_itinerary
    set_new_day
  end

  def update
    @itinerary.update(itinerary_params)
    redirect_to itineraries_path
  end

  def destroy
    # Night not be necessary
    @itinerary.destroy
    redirect_to itineraries_path
  end

  def send_draft
    # Sending draft to the client for feedback.
  end

  def draft
    # Client can give my feedback on the itinerary.
  end

  def payment
    # Client can make the payment
  end

  def send_confirmation
    # Client gets a confirmation email with a pdf of the booked itinerary
  end

  private

  def set_new_day
    @days.times do |i|
      day = Day.new(number: i + 1)
      day.itinerary = @itinerary
      day.save
    end
  end

  def set_itinerary
    @itinerary = Itinerary.find(params[:id])
    authorize @itinerary
  end

  def set_new_itinerary
    @itinerary = Itinerary.new(itineraries_params)
    @days = params[:number_of_days].to_i
    name = "#{@days} in #{itineraries_params[:location]}"
    generic_password = "tabinow"
    client = User.new(email: params[:email], password: generic_password)
    client.save
    @itinerary.name = name
    @itinerary.client = client
    authorize @itinerary
    @itinerary.save
  end

  def itineraries_params
    params.require(:itinerary).permit(:name, :location, :status, :employee_id, :client_id)
  end
end
