const form = document.querySelector("[data-warn-unsaved-changes]")

if(form){
    let unsavedChanges = false

    form.querySelectorAll("input, textarea, select").forEach(input => {
        input.addEventListener("keyup", () => unsavedChanges = true)
        input.addEventListener("change", () => unsavedChanges = true)
    })

    form.querySelectorAll("[data-add]").forEach(input => {
        input.addEventListener("click", () => unsavedChanges = true)
    })

    const message = "You might have unsaved changes. Do you want to continue?"

    form.addEventListener("submit", e => unsavedChanges = false)

    window.addEventListener("beforeunload", e => {
        if(unsavedChanges) {
            e.preventDefault()
            // Chrome requires returnValue to be set, otherwise it won't show a
            // confirm dialog.
            e.returnValue = message
        }
    })

    window.addEventListener("turbolinks:before-visit", e => {
        if(unsavedChanges && !confirm(message)) e.preventDefault()
    })

    window.addEventListener("turbolinks:load", e => {
        unsavedChanges = false
    })
}
