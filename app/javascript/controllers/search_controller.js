import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="search"
export default class extends Controller {
  static targets = [
    "form",
    "query",
    "day",
    "results",
    "filterAccommodation",
    "filterActivity",
    "filterRestaurant",
    "accommodation",
    "activity",
    "restaurant",
  ];
  connect() {}

  search(e) {
    e.preventDefault();

    const url = `${this.formTarget.action}?query=${this.queryTarget.value}&day=${this.dayTarget.value}&button=`;
    fetch(url, { method: "GET", headers: { Accept: "text/plain" } })
      .then((response) => response.text())
      .then((data) => {
        this.resultsTarget.innerHTML = data;
        this.filter(this.filterAccommodationTarget, this.accommodationTargets);
        this.filter(this.filterActivityTarget, this.activityTargets);
        this.filter(this.filterRestaurantTarget, this.restaurantTargets);
      });
  }

  filter(filterTarget, targets) {
    targets.forEach((target) => {
      filterTarget.classList.contains("selected")
        ? target.classList.remove("d-none")
        : target.classList.add("d-none");
    });
  }

  filterAccommodations() {
    this.filterAccommodationTarget.classList.toggle("selected");
    this.filter(this.filterAccommodationTarget, this.accommodationTargets);
  }

  filterActivities() {
    this.filterActivityTarget.classList.toggle("selected");
    this.filter(this.filterActivityTarget, this.activityTargets);
  }

  filterRestaurants() {
    this.filterRestaurantTarget.classList.toggle("selected");
    this.filter(this.filterRestaurantTarget, this.restaurantTargets);
  }
}
