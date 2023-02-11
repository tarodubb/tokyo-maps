import { Application } from "@hotwired/stimulus"
import ScrollReveal from 'stimulus-scroll-reveal'
const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
application.register('scroll-reveal', ScrollReveal)
