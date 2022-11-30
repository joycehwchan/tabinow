import { Controller } from "@hotwired/stimulus";
import Sortable from "sortablejs";
// Connects to data-controller="sortable"
export default class extends Controller {
  static values = {
    itinerary: String,
    day: String,
  };

  connect() {
    const cardsContainer = document.querySelector("#list");
    // console.log("hi from sortable");
    Sortable.create(this.element, {
      // ghostClass: "ghost",
      animation: 150,
      onEnd: (event) => {
        // alert(`${event.oldIndex} moved to ${event.newIndex}`);
        const url = `/itineraries/${this.itineraryValue}/move`;
        const csrfToken = document.querySelector("[name='csrf-token']").content;
        const list = document.querySelectorAll("[data-id]");

        console.log(cardsContainer);
        const listItems = Array.from(list).map((item, index) => ({
          content: item.dataset.id,
          // url: `/contents/${item.dataset.id}`,
          currentIndex: index + 1,
        }));
        const data = JSON.stringify({
          // position: event.newIndex + 1,
          list: listItems,
          // itinerary_id: this.itineraryValue,
          day: this.dayValue,
        });

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
          .then((data) => (cardsContainer.innerHTML = data));
      },
    });
  }
}
