import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "form"]
  static values = { candidateName: String }

  open(event) {
    const id = event.currentTarget.dataset.deleteCandidateId
    const name = event.currentTarget.dataset.deleteCandidateName
    this.formTarget.action = `/admin-candidats/${id}`
    this.candidateNameValue = name
    this.modalTarget.classList.remove("hidden")
    document.body.style.overflow = "hidden"
  }

  close() {
    this.modalTarget.classList.add("hidden")
    document.body.style.overflow = ""
  }
}
