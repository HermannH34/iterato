import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["detail"]
  static values = { candidates: Object }

  connect() {
    if (this.candidatesValue.length > 0) {
      this.select({ params: { id: this.candidatesValue[0].id } })
    }
  }

  select({ params: { id } }) {
    const candidate = this.candidatesValue.find(c => c.id === id)
    if (!candidate) return
    this.detailTarget.innerHTML = this.renderDetail(candidate)
  }

  renderDetail(c) {
    const initials = c.first_name[0] + c.last_name[0]
    return `
      <div class="text-left w-full max-w-lg mx-auto">
        <div class="flex items-center gap-4 mb-6">
          <div class="w-14 h-14 rounded-full bg-[#FB923C]/20 text-[#FB923C] flex items-center justify-center font-bold text-xl">
            ${initials}
          </div>
          <div>
            <h2 class="text-xl font-bold">${c.first_name} ${c.last_name}</h2>
            <p class="text-white/40 text-sm">${c.email}</p>
          </div>
        </div>

        <div class="flex gap-2 mb-6">
          <span class="text-xs bg-[#FB923C]/10 text-[#FB923C] px-2.5 py-0.5 rounded-full">${c.profile_type}</span>
          <span class="text-xs bg-white/10 text-white px-2.5 py-0.5 rounded-full">${c.experience_level}</span>
        </div>

        <div class="space-y-3 text-sm">
          <a href="${c.linkedin_url}" target="_blank" class="flex items-center gap-2 text-white/50 hover:text-[#FB923C] transition-colors">
            <span class="w-5 text-center">🔗</span> Voir le profil LinkedIn
          </a>
          <div class="flex items-center gap-2 text-white/50">
            <span class="w-5 text-center">📄</span>
            <button class="hover:text-[#FB923C] transition-colors">${c.cv_name || "Télécharger le CV"}</button>
          </div>
          <div class="flex items-center gap-2 text-white/30">
            <span class="w-5 text-center">📅</span> Candidature reçue le ${c.created_at}
          </div>
        </div>
      </div>
    `
  }
}
