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
      onEnd: (event) => {
        // alert(`${event.oldIndex} moved to ${event.newIndex}`);
        const id = event.item.dataset.id;
        const url = `/contents/${id}`;
        const csrfToken = document.querySelector("[name='csrf-token']").content;
        const cardsContainer = document.querySelector("#list");

        const data = JSON.stringify({
          position: event.newIndex + 1,
          itinerary_id: this.itineraryValue,
          day: this.dayValue,
        });

        const options = {
          method: "PATCH",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": csrfToken,
          },
          body: data,
        };
        fetch(url, options)
          .then((response) => response.text())
          .then((data) => console.log(data));
      },
    });
  }
}
