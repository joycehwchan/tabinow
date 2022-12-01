import { Controller } from "@hotwired/stimulus";
export default class extends Controller {
  static values = {
    url: String,
  };
  static targets = ["button"];
  connect() {}
  share(e) {
    e.preventDefault();
    navigator.clipboard.writeText(this.urlValue);
    this.buttonTarget.innerText = "Copied";

    setTimeout(() => this.changeText(), 2000);
  }
  changeText() {
    this.buttonTarget.innerText = "Copy link";
  }
}
