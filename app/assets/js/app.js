import { Socket } from "phoenix"
import "phoenix_html"
import { LiveSocket } from "phoenix_live_view"
import { mountApp } from "./entry"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken }
})
liveSocket.connect()
window.liveSocket = liveSocket

sessionStorage.setItem("csrfToken", csrfToken)

mountApp()
