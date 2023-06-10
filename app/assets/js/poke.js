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

const handleAnimation = (e) => {
  const element = e.target
  animate(element, "headShake")
}

const handleVibration = () => window.navigator.vibrate(100)

window.addEventListener("poke:mounted", (e) => {
  const element = e.target
  element.addEventListener("dblclick", handleAnimation)
  element.addEventListener("mousedown", handleVibration)
  element.addEventListener("touchend", handleVibration)
})

window.addEventListener("poke:removed", (e) => {
  const element = e.target
  element.removeEventListener("dblclick", handleAnimation)
  element.removeEventListener("mousedown", handleVibration)
  element.removeEventListener("touchend", handleVibration)
})
