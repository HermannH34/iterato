import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  open(event) {
    const name = event.params.name
    const modal = this.modalTargets.find(m => m.id === `${name}-modal`)
    if (modal) modal.classList.remove("hidden")
    document.body.style.overflow = "hidden"
  }

  close() {
    this.modalTargets.forEach(m => m.classList.add("hidden"))
    document.body.style.overflow = ""
  }
}
