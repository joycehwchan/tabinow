import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="loading"
export default class extends Controller {
  static targets = ["form", "spinner"];

  connect() {
    console.log(this.element);
  }

  generate(e) {
    e.preventDefault();
    // remove d-none from loading div
    this.spinnerTarget.classList.remove("d-none");

    console.log("generating");

    const url = this.formTarget.action;
    // console.log(url);

    fetch(url, {
      method: "POST",
      // headers: { Accept: "text/plain" },
      body: new FormData(this.formTarget),
    }).then((response) => {
      console.log(response);
      console.log(response.url);
      // window.location.href = response.url;
    });
  }
}
