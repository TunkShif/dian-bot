import { faker } from "@faker-js/faker"
import { getUnixTime } from "date-fns"

export const Res = {
  ok: <T>(data: T) => ({ status: "ok", data }),
  err: <T>(msg: T) => ({ status: "failed", data: null, msg })
}

export const id = () => faker.string.numeric({ length: 8 })

export const User = {
  one: () => ({
    nickname: faker.word.words(3)
  })
}

export const Group = {
  one: () => ({
    group_name: faker.word.words(2),
    group_memo: faker.word.words(4)
  })
}

export const Message = {
  one: () => ({
    sender: {
      user_id: id()
    },
    group_id: id(),
    raw_message: faker.word.words(8),
    time: getUnixTime(faker.date.recent())
  }),
  many: () => ({
    messages: Array(3)
      .fill(0)
      .map(() => ({
        sender: {
          user_id: id()
        },
        group_id: id(),
        content: faker.word.words(8),
        time: getUnixTime(faker.date.recent())
      }))
  })
}
