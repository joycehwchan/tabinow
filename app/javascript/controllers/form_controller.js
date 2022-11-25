import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="form"
export default class extends Controller {
  static targets = ["startDate", "endDate"];

  connect() {
  }

  setEndDate() {
    const startDate = this.startDateTarget.value;
    this.endDateTarget.setAttribute("min", startDate);
  }
}
