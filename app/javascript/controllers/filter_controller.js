import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="filter"
export default class extends Controller {
  static targets = ["accommodation", "activity", "restaurant"];

  connect() {
    //
  }

  filterHotels(e) {
    console.log("filter accommodation");
    e.currentTarget.classList.toggle("selected");
    this.accommodationTargets.forEach((accommodation) => {
      console.log(accommodation);
      accommodation.classList.toggle("d-none");
    });
  }

  filterActivities(e) {
    console.log("filter activities");
    e.currentTarget.classList.toggle("selected");
    this.activityTargets.forEach((activity) => {
      activity.classList.toggle("d-none");
    });
  }

  filterRestaurants(e) {
    console.log("filter restaurants");
    e.currentTarget.classList.toggle("selected");
    this.restaurantTargets.forEach((restaurant) => {
      restaurant.classList.toggle("d-none");
    });
  }
}
