import { mountApp, registerServiceWorker } from "@/entry"
import { csrfToken } from "@/session"
import { Socket } from "phoenix"
import "phoenix_html"
import { LiveSocket } from "phoenix_live_view"

let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken }
})
liveSocket.connect()
window.liveSocket = liveSocket

mountApp()
registerServiceWorker()
