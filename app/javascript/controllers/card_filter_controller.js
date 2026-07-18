import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["filter", "card"]

  filter(event) {
    const type = event.params.type
    this.filterTargets.forEach(el => {
      if (el === event.currentTarget) {
        el.classList.add("border-[#FB923C]/30", "text-[#FB923C]")
        el.classList.remove("border-white/20", "text-white/50")
      } else {
        el.classList.remove("border-[#FB923C]/30", "text-[#FB923C]")
        el.classList.add("border-white/20", "text-white/50")
      }
    })
    this.cardTargets.forEach(el => {
      if (type === "all" || el.dataset.cardFilterProfile === type) {
        el.style.display = ""
      } else {
        el.style.display = "none"
      }
    })
  }
}
