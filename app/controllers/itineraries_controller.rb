class ItinerariesController < ApplicationController
  before_action :set_itinerary, except: %i[index new create]
  skip_before_action :authenticate_user!, only: :create

  def index
    @itineraries = policy_scope(Itinerary)
    @itinerary = Itinerary.new
  end

  def show
    @day = @itinerary.days[params[:day].to_i - 1]
    @contents = params[:query].present? ? Content.where('location ILIKE ?', "%#{params[:query]}%") : []
  end

  def new
    @itinerary = Itinerary.new
    authorize @itinerary
  end

  def create
    set_new_itinerary
    set_new_day
    if @itinerary.save
      set_employee
    elsif user_signed_in?
      @itineraries = policy_scope(Itinerary)
      flash[:alert] = @itinerary.errors.full_messages.first
      render :index, status: :unprocessable_entity
    else
      flash[:alert] = @itinerary.errors.full_messages.first
      render 'pages/home', status: :unprocessable_entity
    end
  end

  def update
    @itinerary.update(itineraries_params)
    redirect_to itinerary_path(@itinerary)
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
    @days = params[:number_of_days].present? ? params[:number_of_days].to_i : @itinerary.total_days
    @days.times do |i|
      day = Day.new(number: i + 1)
      day.itinerary = @itinerary
      day.save!
      new_category_and_item("Accomodation", day)
    end
  end

  def new_category_and_item(item_category, day)
    if item_category == "Accomodation"
      category = Category.new(title: "Accomodation",
                              sub_category: "Not Set",
                              day: day)
      if category.save!
        set_accomodation
      else
        # Category Failed
      end
    elsif item_category == "Restaurant"
      food_times = ["Lunch", "Dinner"]
      food_times.each do |food_time|
        category = Category.new(title: "Restaurant",
                                sub_category: food_time,
                                day: day)
        if category.save!
          set_restaurant(food_time)
        else
        # Category Failed
        end
      end
    else
      category = Category.new(title: "Acivity",
                              sub_category: "Not Set",
                              day: day)
      if category.save!
        set_activity
      else
        # Category Failed
      end
    end
  end

  def min_price_generator
    min_price = @itinerary.min_budget.to_i / 2
    return min_price
  end

  def max_price_generator
    max_price = @itinerary.max_budget.to_i / 2
    return max_price
  end

  def set_accomodation
    # Need to set price for accomodation.
    accomodations = AccommodationApiService.new(itineraries_params)
    accomodations.number_people = 2
    accomodations.price_from = min_price_generator
    accomodations.price_to = max_price_generator
    accomodations.start_date = @itinerary.start_date
    accomodations.end_date = @itinerary.end_date
    accomodations_results = accomodations.call
    accomodation = accomodations_results.sample
    accomodation = Content.new(name: accomodation["name"],
                            price: accomodation["price"]["lead"]["amount"],
                            location: "Tokyo", #call_accomodation_details(accomodation["id"])["location"]["address"]["addressLine"],
                            category: Category.last,
                            rating: accomodation["reviews"]["score"],
                            description: "2343errgg", #call_accomodation_details(accomodation["id"])["tagline"],
                            api: "",
                            status: 0)
    accomodation.category = Category.last
    if accomodation.save!
      Category.last.update!(sub_category: "Hotel")
    else
      # Accomodation Failed
    end
  end

  def set_restaurant(food_time)
    if food_time == "Lunch"
      restaurants = RestaurantApiService.new(location: params[:location],
                                             keyword: "Best Lunch restaurants",
                                             number_people: params[:number_people],
                                             price: restaurant_price)
      restaurants_results = restaurants.call
      restaurant = restaurants_results.first
      restaurant = Item.new(restaurant)
      restaurant.category = Category.last
      if restaurant.save!
        # Saved!
      else
        # Accomodation Failed
      end
    else
      restaurants = RestaurantApiService.new(location: params[:location],
                                             keyword: "Best Dinner restaurants",
                                             number_people: params[:number_people],
                                             price: restaurant_price)
      restaurants_results = restaurants.call
      restaurant = restaurants_results.first
      restaurant = Item.new(restaurant)
      restaurant.category = Category.last
      if restaurant.save!
        # Saved!
      else
        # Accomodation Failed
      end
    end
  end

  def set_activity
    activities = ActivityApiService.new(location: params[:location],
                                        keyword: "Fun Activities",
                                        number_people: params[:number_people],
                                        price: restaurant_price)
    activities_results = activities.call
    activity = activities_results.first
    activity = Item.new(activity)
    activity.category = Category.last
    if activity.save!
      Category.last.update!(sub_category: activity.description)
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
    name = "#{@itinerary.total_days} in #{itineraries_params[:location].capitalize}"
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
                                      :special_request, :start_date, :end_date, :archived)
  end
end
