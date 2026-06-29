import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["track", "dots"]
  static values = { total: Number }

  connect() {
    this.current = 0
  }

  next() {
    this.goTo((this.current + 1) % this.totalValue)
  }

  prev() {
    this.goTo((this.current - 1 + this.totalValue) % this.totalValue)
  }

  go(event) {
    this.goTo(parseInt(event.params.index))
  }

  goTo(index) {
    this.current = index
    this.trackTarget.style.transform = `translateX(-${index * 100}%)`

    this.dotsTarget.querySelectorAll("button").forEach((dot, i) => {
      dot.className = i === index
        ? "w-2 h-2 rounded-full transition-all bg-[#FB923C] w-6"
        : "w-2 h-2 rounded-full transition-all bg-white/20"
    })
  }
}
