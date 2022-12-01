import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="share"
export default class extends Controller {
  static values = {
    url: String,
  };
  static targets = ["results"];
  connect() {
    console.log("hi");
  }
}
