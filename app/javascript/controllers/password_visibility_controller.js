import { Controller } from "@hotwired/stimulus"

// Shows or hides the password inputs inside this element.
// <div data-controller="password-visibility">
//   <input type="password" data-password-visibility-target="input">
//   <button type="button" data-action="password-visibility#toggle" data-password-visibility-target="button">
export default class extends Controller {
  static targets = ["input", "button"]

  toggle() {
    const show = this.inputTargets[0].type === "password"
    this.inputTargets.forEach((input) => { input.type = show ? "text" : "password" })
    this.buttonTargets.forEach((button) => {
      button.setAttribute("aria-pressed", show)
      button.setAttribute("aria-label", show ? "Hide password" : "Show password")
    })
  }
}
