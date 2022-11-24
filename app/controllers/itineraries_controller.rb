class ItinerariesController < ApplicationController
  before_action :set_itinerary, except: %i[index new create]
  skip_before_action :authenticate_user!, only: :create

  def index
    @itineraries = policy_scope(Itinerary)
    @itinerary = Itinerary.new
  end

  def show
    @day = @itinerary.days[params[:day].to_i - 1]
    @contents = Content.where('location ILIKE ?', "%#{params[:query]}%") unless params[:query].present?
  end

  def new
    @itinerary = itinerary.new
    authorize @itinerary
  end

  def create
    set_new_itinerary
    set_new_day
    if @itinerary.save
      set_employee
    elsif user_signed_in?
      @itineraries = policy_scope(Itinerary)
      render :index, status: :unprocessable_entity
      flash[:alert] = @itinerary.errors.full_messages.first
    else
      render 'pages/home', status: :unprocessable_entity
      flash[:alert] = @itinerary.errors.full_messages.first
    end
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
    return unless @itinerary.save

    @days.times do |i|
      day = Day.new(number: i + 1)
      day.itinerary = @itinerary
      day.save!
      new_category_and_item("Accomodation")
    end
  end

  def new_category_and_item(item_category)
    if item_category == "Accomodation"
      category = Category.new(title: "Accomodation",
                              sub_category: "Not Set",
                              day: day)
      if category.save!
        set_accomodation
      else
        # Category Failed
      end
    end
  end

  def set_accomodation
    # Need to set price for accomodation.
    accomodations = AccomodationApiService.new(location: params[:location],
                                               date_from: params[:date_from],
                                               date_to: params[:date_to],
                                               number_people: params[:number_people],
                                               price_from: accomodation_night_price_min,
                                               price_to: accomodation_night_price_max)
    accomodations_results = accomodations.call
    accomodation = accomodations_results.first
    accomodation = Item.new(accomodation)
    accomodation.category = Category.last
    if accomodation.save!
      update_category = Category.last.sub_category = "Hotel"
      update_category.save!
    else
      # Accomodation Failed
    end
  end

  def set_itinerary
    @itinerary = Itinerary.find(params[:id])
    authorize @itinerary
  end

  def set_new_itinerary
    @itinerary = Itinerary.new(itineraries_params)
    @days = params[:number_of_days].to_i
    name = "#{@days} in #{itineraries_params[:location].capitalize}"
    set_new_client
    @itinerary.name = name
    authorize @itinerary
  end

  def set_new_client
    return unless
     params[:email]

    generic_password = "tabinow"
    client = User.new(email: params[:email], password: generic_password)
    client.save
    @itinerary.client = client
  end

  def set_employee
    if user_signed_in?
      @itinerary.employee = current_user
      redirect_to itinerary_path(@itinerary)
    else
      redirect_to root_path
      flash[:success] = "Information submitted!"
    end
  end

  def itineraries_params
    params.require(:itinerary).permit(:name, :location, :status, :employee_id, :client_id, :max_budget, :min_budget,
                                      :special_request)
  end
end
