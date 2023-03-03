// app/javascript/controllers/review_form_controller.js
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["form"]

  connect() {
    this.formTarget.style.display = "none";
  }

  toggleForm() {
    this.formTarget.style.display = "block";
  }
}
