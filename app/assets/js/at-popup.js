const map = new WeakMap()

const container = document.getElementById("tippy-container")

window.addEventListener("at-popup:mounted", (e) => {
  const element = e.target
  const template = document.getElementById("at-popup-template").content.cloneNode(true)

  const { avatarUrl, userNickname, userNumber } = element.dataset
  template.querySelector("[data-avatar]").src = avatarUrl
  template.querySelector("[data-nickname]").innerText = userNickname
  template.querySelector("[data-number]").innerText = `(${userNumber})`

  const instance = tippy(element, {
    content: template,
    arrow: false,
    placement: "bottom",
    appendTo: container,
    offset: [0, 0],
    theme: "none",
    zIndex: 49
  })

  map.set(element, instance)
})

window.addEventListener("at-popup:removed", (e) => {
  const element = e.target
  const instance = map.get(element)
  instance?.destroy?.()
})
