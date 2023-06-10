const animate = (element, animation, prefix = "animate__") =>
  new Promise((resolve) => {
    const animationName = `${prefix}${animation}`
    element.classList.add(`${prefix}animated`, animationName)

    function handleAnimationEnd(event) {
      event.stopPropagation()
      element.classList.remove(`${prefix}animated`, animationName)
      resolve("Animation ended")
    }

    element.addEventListener("animationend", handleAnimationEnd, { once: true })
  })

const vibarate = () => {
  if (!("vibrate" in window.navigator)) return
  window.navigator.vibrate(200)
}

const handler = (e) => {
  const element = e.target
  animate(element, "headShake")
}

window.addEventListener("poke:mounted", (e) => {
  const element = e.target
  element.addEventListener("dblclick", handler)
})

window.addEventListener("poke:removed", (e) => {
  const element = e.target
  element.removeEventListener("dblclick", handler)
})
