document.documentElement.classList.add("js")

document.addEventListener("change", (event) => {
  const field = event.target
  const form = field.closest("form[data-auto-submit]")

  if (form && field.matches("select")) form.requestSubmit()
})
