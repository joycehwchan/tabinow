class ItinerariesController < ApplicationController
  before_action :set_itinerary, except: %i[index new create move]
  skip_before_action :authenticate_user!, only: %i[create show]

  def index
    @itineraries = policy_scope(Itinerary)
    @itinerary = Itinerary.new
  end

  def show
    set_day_and_contents_and_markers

    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: "itineraries/results", locals: { contents: @contents }, formats: [:html] }
    end
  end

  def new
    @itinerary = Itinerary.new
    authorize @itinerary
  end

  def create
    set_new_itinerary
    if @itinerary.save
      @itinerary.new_day(@days)
      # redirect_to itinerary_path(@itinerary)

      set_day_and_contents_and_markers

      respond_to do |format|
        format.html { redirect_to itinerary_path(@itinerary) }
        format.text do
          render partial: "itineraries/generator",
                 locals: { itinerary: @itinerary, day: @day, contents: @contents, markers: @markers }, formats: [:html]
        end
      end

      # set_employee
    elsif user_signed_in?
      @itineraries = policy_scope(Itinerary)
      flash[:alert] = @itinerary.errors.full_messages.first
      render :index, status: :unprocessable_entity
    else
      flash[:alert] = @itinerary.errors.full_messages.first
      render 'pages/start', status: :unprocessable_entity
    end
  end

  def update
    @itinerary.update(itineraries_params)
    if @itinerary.archived
      @itineraries = policy_scope(Itinerary)
      redirect_to itineraries_path
    else
      redirect_to itinerary_path(@itinerary)
    end
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

  def move
    update_contents_position
    @itinerary = Itinerary.find(params[:itinerary_id].to_i)
    @day = @itinerary.days[params[:day].to_i - 1]
    respond_to do |format|
      format.html { redirect_to itinerary_path(@itinerary), status: :see_other }
      format.text { render partial: "itineraries/content", locals: { day: @day }, formats: [:html] }
    end
  end

  def download
    pdf = Prawn::Document.new
    pdf.text "hello world"
    send_data(pdf.render,
              filename: "#{@itinerary.title}- #{@itinerary.client.name} ",
              type: 'application/pdf')
  end

  def preview
  end

  private

  def set_day_and_contents_and_markers
    @day = @itinerary.days[params[:day].to_i - 1]
    if params[:query].present?
      # display search results
      @contents = UnusedContent.where('location ILIKE :query OR name ILIKE :query', query: "%#{params[:query]}%")
    else
      # display content on overview
      @contents = Content.all
      # @contents = @itinerary.days.map { |day| day.contents }.flatten
      @markers = @contents.geocoded.map do |content|
        {
          lat: content.latitude,
          lng: content.longitude
        }
      end
    end
  end

  def set_itinerary
    @itinerary = Itinerary.find(params[:id])
    authorize @itinerary
  end

  def set_new_itinerary
    @itinerary = Itinerary.new(itineraries_params)
    @days = params[:number_of_days].present? ? params[:number_of_days].to_i : @itinerary.total_days
    title = "#{@days} #{'day'.pluralize(@days)} in #{itineraries_params[:location].capitalize}"
    @itinerary.title = title
    # @itinerary.set_new_client(name: params[:name], email: params[:email])
    @itinerary.client = current_user if user_signed_in?
    authorize @itinerary
  end

  def set_employee
    if user_signed_in?
      @itinerary.employee = current_user
      redirect_to itinerary_path(@itinerary)
    else
      redirect_to root_path
      flash[:success] = "Request sent!"
    end
  end

  def update_contents_position
    items = params[:list]
    items.each do |item|
      content = Content.find(item[:content].to_i)
      content.position = item[:currentIndex]
      content.save
      authorize content
    end
  end

  def itineraries_params
    params.require(:itinerary).permit(:name, :title, :location, :status, :employee_id, :client_id, :max_budget, :min_budget,
                                      :special_request, :start_date, :end_date, :archived, :content, :curentIndex)
  end
end
