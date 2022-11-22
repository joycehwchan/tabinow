class DaysController < ApplicationController
  #this new page is in the itinerary show page
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

  private

  def day_params
    params.require(:day).permit(:number)
  end
end
