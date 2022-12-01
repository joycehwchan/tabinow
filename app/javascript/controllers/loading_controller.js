import { Controller } from "@hotwired/stimulus";
import { loadingMessage } from "../typewriter";

// Connects to data-controller="loading"
export default class extends Controller {
  static targets = ["form", "spinner"];

  connect() {}

  generate(e) {
    e.preventDefault();
    this.spinnerTarget.classList.remove("d-none");
    loadingMessage
      .typeString("Looking for available hotels...")
      .pauseFor(4000)
      .deleteAll()
      .typeString("Looking for activities...")
      .pauseFor(4000)
      .deleteAll()
      .typeString("Looking for restaurants...")
      .pauseFor(4000)
      .deleteAll()
      .typeString("Generating itinerary...")
      .pauseFor(8000)
      .deleteAll()
      .typeString("Almost done...")
      .pauseFor(20000)
      .deleteAll()
      .start();

    const url = this.formTarget.action;

    fetch(url, {
      method: "POST",
      body: new FormData(this.formTarget),
    }).then((response) => {
      console.log(response);
      console.log(response.url);
      if (response.ok) {
        window.location.href = response.url;
      } else {
        this.spinnerTarget.classList.add("d-none");
      }
    });
  }
}
