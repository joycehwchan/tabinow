import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="sidebar"
export default class extends Controller {
  static targets = ["content", "button"];
  connect() {}

  toggle(e) {
    const openIcon = `<i class="fa-solid fa-chevron-right"></i>`;
    const closeIcon = `<i class="fa-solid fa-chevron-left"></i>`;
    this.element.classList.toggle("sidebar-hide");
    this.contentTarget.classList.toggle("d-none");
    this.buttonTarget.classList.toggle("shift-btn");
    this.buttonTarget.classList.toggle("btn-light");
    this.buttonTarget.classList.toggle("btn-primary");
    console.log(this.buttonTarget.innerHTML);
    console.log(closeIcon);
    if (this.buttonTarget.innerHTML == openIcon) {
      this.buttonTarget.innerHTML = closeIcon;
    } else if (this.buttonTarget.innerHTML == closeIcon) {
      this.buttonTarget.innerHTML = openIcon;
    }
  }

  collaspe(e) {
    if (window.innerWidth <= 992) {
      this.element.classList.add("sidebar-hide");
      this.contentTarget.classList.add("d-none");
      this.buttonTarget.classList.add("shift-btn");
      this.buttonTarget.classList.remove("btn-light");
      this.buttonTarget.classList.add("btn-primary");
    } else {
      this.element.classList.remove("sidebar-hide");
      this.contentTarget.classList.remove("d-none");
      this.buttonTarget.classList.remove("shift-btn");
      this.buttonTarget.classList.add("btn-light");
      this.buttonTarget.classList.remove("btn-primary");
    }
  }
}
