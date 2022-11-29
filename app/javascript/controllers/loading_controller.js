import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="loading"
export default class extends Controller {
  static targets = ["form"];

  connect() {
    console.log(this.element);
  }

  generate(e) {
    e.preventDefault();
    console.log("generating");

    const url = this.formTarget.action;
    // console.log(url);

    fetch(url, {
      method: "POST",
      headers: { Accept: "text/plain" },
      body: new FormData(this.formTarget),
    })
      .then((response) => response.text())
      .then((data) => {
        console.log(data);
      });
  }
}
