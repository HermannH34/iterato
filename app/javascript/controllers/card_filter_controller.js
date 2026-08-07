import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["filter", "sourceFilter", "card"]

  connect() {
    this.activeProfile = "all"
    this.activeSource = "all"
  }

  filter(event) {
    this.activeProfile = event.params.type
    this.filterTargets.forEach(el => {
      if (el === event.currentTarget) {
        el.classList.add("border-[#FB923C]/30", "text-[#FB923C]")
        el.classList.remove("border-white/20", "text-white/50")
      } else {
        el.classList.remove("border-[#FB923C]/30", "text-[#FB923C]")
        el.classList.add("border-white/20", "text-white/50")
      }
    })
    this.applyFilters()
  }

  filterSource(event) {
    this.activeSource = event.params.source
    this.sourceFilterTargets.forEach(el => {
      if (el === event.currentTarget) {
        el.classList.add("border-[#FB923C]/30", "text-[#FB923C]")
        el.classList.remove("border-white/20", "text-white/50")
      } else {
        el.classList.remove("border-[#FB923C]/30", "text-[#FB923C]")
        el.classList.add("border-white/20", "text-white/50")
      }
    })
    this.applyFilters()
  }

  applyFilters() {
    this.cardTargets.forEach(el => {
      const profileMatch = this.activeProfile === "all" || el.dataset.cardFilterProfile === this.activeProfile
      const sourceMatch = this.activeSource === "all" || el.dataset.cardFilterSource === this.activeSource
      el.style.display = (profileMatch && sourceMatch) ? "" : "none"
    })
  }
}
