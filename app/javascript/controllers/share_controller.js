import { Controller } from "@hotwired/stimulus";
export default class extends Controller {
  static values = {
    url: String,
    title: String,
  };
  static targets = ["result", "button", "icon"];
  connect() {
    if (navigator.share) {
      this.
      this.buttonTarget.innerText = "Share";
    } else {
      this.buttonTarget.innerText = "Copy link";
    }
  }
  async share(e) {
    e.preventDefault();
    const shareData = {
      url: this.urlValue,
      text: "my trip",
      title: this.titleValue,
    };
    if (navigator.share) {
      try {
        await navigator.share(shareData);
        this.resultTarget.textContent = "MDN Shared successfully";
      } catch (err) {
        this.resultTarget.textContent = `${err}`;
      }
    } else {
      navigator.clipboard.writeText(this.urlValue);
    }
  }
}
