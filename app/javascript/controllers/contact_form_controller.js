import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "success", "profileButtons", "contextButtons", "levelButtons", "fileInput", "fileName", "fileNameText", "errors"]
  static values = { type: String }

  connect() {
    this.selections = { profile: "", context: "", level: "" }
  }

  selectProfile(event) {
    this._selectOne(event, "profileButtons", "profile")
  }

  selectContext(event) {
    this._selectOne(event, "contextButtons", "context")
  }

  selectLevel(event) {
    this._selectOne(event, "levelButtons", "level")
  }

  handleFile(event) {
    const file = event.target.files[0]
    if (!file) return
    this.fileNameTextTarget.textContent = file.name
    this.fileNameTarget.classList.remove("hidden")
  }

  async submit(event) {
    event.preventDefault()
    const form = event.target
    const data = new FormData(form)

    const payload = {}
    data.forEach((value, key) => { payload[key] = value })

    payload.profileType = this.selections.profile
    payload.context = this.selections.context
    payload.experienceLevel = this.selections.level
    payload.formType = this.typeValue

    if (this.hasFileInputTarget && this.fileInputTarget.files[0]) {
      const file = this.fileInputTarget.files[0]
      payload.cvData = await this._readFile(file)
      payload.cvName = file.name
    }

    if (this.typeValue === "join_community") {
      const missing = []
      if (!payload.firstName?.trim()) missing.push("Prénom")
      if (!payload.lastName?.trim()) missing.push("Nom")
      if (!payload.email?.trim()) missing.push("Email")
      if (!payload.profileType) missing.push("Profil")
      if (!payload.experienceLevel) missing.push("Niveau d'expérience")
      if (!payload.linkedinUrl?.trim()) missing.push("LinkedIn")
      if (missing.length > 0) {
        if (this.hasErrorsTarget) {
          this.errorsTarget.classList.remove("hidden")
          this.errorsTarget.innerHTML = missing.map(f => `<p>· ${f} est requis</p>`).join("")
        }
        return
      }
    }

    if (this.hasErrorsTarget) this.errorsTarget.classList.add("hidden")

    try {
      await fetch("/contact", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      })
    } catch (_) {}

    this.formTarget.classList.add("hidden")
    this.successTarget.classList.remove("hidden")
  }

  _selectOne(event, targetName, key) {
    const container = this[`${targetName}Target`]
    const value = event.target.dataset.value
    const isLevel = targetName === "levelButtons"
    const isContext = targetName === "contextButtons"

    container.querySelectorAll("button").forEach(btn => {
      if (btn.dataset.value === value) {
        btn.classList.add("border-[#FB923C]/30", "bg-[#FB923C]/10", "text-[#FB923C]")
        btn.classList.remove("border-white/10", "bg-white/5", "text-white/80", "hover:border-white/20")
      } else {
        btn.classList.remove("border-[#FB923C]/30", "bg-[#FB923C]/10", "text-[#FB923C]")
        btn.classList.add("border-white/10", "bg-white/5", "text-white/80", "hover:border-white/20")
      }
    })
    this.selections[key] = value
  }

  _readFile(file) {
    return new Promise((resolve) => {
      const reader = new FileReader()
      reader.onload = () => resolve(reader.result)
      reader.readAsDataURL(file)
    })
  }
}
