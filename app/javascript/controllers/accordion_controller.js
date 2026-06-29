import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "chevron"]

  toggle() {
    const isOpen = !this.contentTarget.classList.contains("hidden")
    this.contentTarget.classList.toggle("hidden")
    if (this.hasChevronTarget) {
      this.chevronTarget.style.transform = isOpen ? "" : "rotate(180deg)"
    }
  }
}
