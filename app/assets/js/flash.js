window.addEventListener("flash:auto-clear", (e) =>
  setTimeout(() => {
    const element = e.target
    liveSocket.execJS(element, element.getAttribute("phx-click"))
  }, 3000)
)
