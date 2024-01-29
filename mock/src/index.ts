import { Elysia } from "elysia"

const Res = {
  ok: <T>(data: T) => ({ status: "ok", data }),
  err: <T>(msg: T) => ({ status: "failed", data: null, msg })
}

const app = new Elysia().group("/bot", (app) =>
  app.get("/get_status", () => Res.ok({ online: Math.random() > 0.5 }))
)

app.listen(4321)

console.log(`🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`)
