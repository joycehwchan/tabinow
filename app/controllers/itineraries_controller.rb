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
    @itinerary = Itinerary.new(itineraries_params)
    name = "#{params[:number_of_days]} in #{itineraries_params[:location]}"
    generic_password = "tabinow"
    client = User.new(email: params[:email], password: generic_password)
    client.save
    @itinerary.name = name
    @itinerary.client = client
    authorize @itinerary
    raise
    @itinerary.save
    # if @itinerary.save
    #   flash[:success] = "Information submitted!"
    #   redirect_to root_path
    # else
    #   render :new, status: :unprocessable_entity
    # end
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

  def set_itinerary
    @itinerary = Itinerary.find(params[:id])
    authorize @itinerary
  end

  def set_new_itinerary
    @itinerary = Itinerary.new(itineraries_params)
    @itinerary.user = current_user
    authorize @itinerary
  end

  def itineraries_params
    params.require(:itinerary).permit(:name, :location, :status, :employee_id, :client_id)
  end
end
