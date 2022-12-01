import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="share"
export default class extends Controller {
  static values = {
    url: String,
    title: String,
    // description: String,
    // image: String,
  };
  static targets = ["results"];
  connect() {
    // console.log(this.urlValue);
    // console.log(this.titleValue);
  }
  async share(e) {
    e.preventDefault();

    const shareData = {
      url: this.urlValue,
      title: this.titleValue,
    };
    console.log(shareData);
  }
}
