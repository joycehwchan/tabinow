import { Controller } from "@hotwired/stimulus";
import Sortable from "sortablejs";
// Connects to data-controller="sortable"
export default class extends Controller {
  static values = {
    itinerary: String,
    day: String,
  };

  connect() {
    // console.log("hi from sortable");
    Sortable.create(this.element, {
      // ghostClass: "ghost",
      animation: 150,
      onEnd: this.end.bind(this),
    });
  }

  end(event) {
    const list = document.querySelectorAll("[data-id]");

    const listItems = Array.from(list).map((item, index) => ({
      content: item.dataset.id,
      currentIndex: index + 1,
    }));
    const data = JSON.stringify({
      list: listItems,
      day: this.dayValue,
    });
    this.updateIndex(data);
  }

  updateIndex(data) {
    const cardsContainer = document.querySelector("#list");
    const url = `/itineraries/${this.itineraryValue}/move`;
    const csrfToken = document.querySelector("[name='csrf-token']").content;
    const options = {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken,
        Accept: "text/plain",
      },
      body: data,
    };
    fetch(url, options)
      .then((response) => response.text())
      .then((data) => {
        cardsContainer.innerHTML = data;
      });
  }
}
