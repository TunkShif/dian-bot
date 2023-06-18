window.addEventListener("theme:toggle", () => {
  localStorage.theme = localStorage.theme === "dark" ? "light" : "dark"
  document.documentElement.dataset.theme = localStorage.theme
})
