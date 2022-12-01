class CategoriesController < ApplicationController
   def destroy
    category = Category.find(params[:id])
    authorize category
    category.destroy
    redirect_to itinerary_path(category.day.itinerary, day: category.day.number)
   end
end
