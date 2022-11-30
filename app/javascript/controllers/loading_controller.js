import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="loading"
export default class extends Controller {
  static targets = ["form", "spinner"];

  connect() {}

  generate(e) {
    e.preventDefault();
    this.spinnerTarget.classList.remove("d-none");

    console.log("generating");

    const url = this.formTarget.action;

    fetch(url, {
      method: "POST",
      // headers: { Accept: "text/plain" },
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
