import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["form", "query", "day", "results"];
  connect() {
    console.log(this.resultsTarget);
  }

  search(e) {
    e.preventDefault();

    const url = `${this.formTarget.action}?query=${this.queryTarget.value}&day=${this.dayTarget.value}&button=`;
    // async function displayResults() {
    //   let response = await fetch(url, {
    //     method: "GET",
    //     headers: { Accept: "text/plain" },
    //   });
    //   let data = await response.text();
    //   // console.log(data);
    //   this.resultsTarget.innerHTML = data;
    // }
    fetch(url, { method: "GET", headers: { Accept: "text/plain" } })
      .then((response) => response.text())
      .then((data) => {
        this.resultsTarget.innerHTML = data;
      });
    // displayResults();
  }
}
