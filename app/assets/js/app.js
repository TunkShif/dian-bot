import { Socket } from "phoenix"
import "phoenix_html"
import { LiveSocket } from "phoenix_live_view"

import "./poke"
import "./theme"
import "./flash"
import "./modal"
import "./topbar"
import "./at-popup"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  dom: {
    onBeforeElUpdated(from, to) {
      if (from.localName === "dialog") to.open = from.open
    }
  }
})

liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
