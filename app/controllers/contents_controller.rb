class ContentsController < ApplicationController
  def update
    content = Content.find(params[:id])
    itinerary = Itinerary.find(params[:itinerary_id].to_i)
    content.update(contents_params)
    day = itinerary.days[params[:day].to_i - 1]

    # head :ok

    # binding.break
    authorize content
    respond_to do |format|
      format.html { redirect_to itinerary_path(itinerary), status: :see_other }
      format.text { render partial: "itineraries/content", locals: { contents: day.contents }, formats: [:html] }
    end
  end

  def move
    raise
  end

  private

  def contents_params
    params.require(:content).permit(:position)
  end
end
