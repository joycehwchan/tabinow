class DaysController < ApplicationController
  # this new page is in the itinerary show page
  # def new
  #   @day = Day.new
  # end

  def create
    @day = Day.new(day_params)
    @day.itinerary = params[:id]
    if day.save
      flash[:success] = "Day in itinerary created!"
      redirect_to itinerary_path(@day.itinerary)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    itinerary = Itinerary.find(params[:id].to_i)
    day = itinerary.days[params[:day].to_i - 1]
    unused_content = UnusedContent.find(params[:content].to_i)

    unused_content.attached
    category = Category.create!(title: unused_content.category_title,
                                sub_category: unused_content.category_sub_category,
                                day:day)

    content = Content.create!(name: unused_content.name,
                              price: unused_content.price,
                              location: unused_content.location,
                              rating: unused_content.rating,
                              category: category,
                              description: unused_content.description,
                              api: unused_content.api,
                              latitude: unused_content.latitude,
                              longitude: unused_content.longitude,
                              status: 0)
    day.categories << category
    day.save!
    authorize day
    redirect_to itinerary_path(itinerary, day: params[:day].to_i)
  end

  private

  def day_params
    params.require(:day).permit(:number)
  end
end
