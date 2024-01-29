import { Elysia } from "elysia"
import { Group, Message, Res, User } from "./schemas"

const app = new Elysia().group("/bot", (app) =>
  app
    .get("/get_status", () => Res.ok({ online: Math.random() > 0.5 }))
    .get("/get_stranger_info", () => Res.ok(User.one()))
    .get("/get_group_info", () => Res.ok(Group.one()))
    .get("/get_msg", () => Res.ok(Message.one()))
    .get("/get_forward_msg", () => Res.ok(Message.many()))
    .post("/send_group_msg", () => Res.ok(null))
    .post("/set_essence_msg", () => Res.ok(null))
)

app.listen(4321)

console.log(`🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`)
