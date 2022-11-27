import { Controller } from "@hotwired/stimulus";
import Sortable from "sortablejs";
// Connects to data-controller="sortable"
export default class extends Controller {
  connect() {
    // console.log("hi from sortable");
    Sortable.create(this.element, {
      // ghostClass: "ghost",
      animation: 150,
      // onEnd: (event) => {
      //   alert(`${event.oldIndex} moved to ${event.newIndex}`)
      // }
    });
  }
}
