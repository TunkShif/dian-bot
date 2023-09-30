import type { ListData } from "@/services"
import ky from "ky"

export type User = {
  id: number
  number: string
  nickname: string
  avatar_url: string
}

export type Group = {
  id: number
  number: string
  name: string
}

export type Message = {
  content: MessageContent[]
  group: Group
  sender: User
  sent_at: string
}

export type MessageContent =
  | {
    type: "text"
    data: string[]
  }
  | {
    type: "image"
    data: { url: string }
  }
  | {
    type: "at"
    data: {
      number: string
      nickname: string
    }
  }

export const MessengerService = {
  listGroups() {
    return ky.get("/api/messenger/groups").json<ListData<Group>>()
  },
  listUsers() {
    return ky.get("/api/messenger/users").json<ListData<User>>()
  },
  generateUserAvatarUrl(number: string, size: number = 100) {
    return `https://q.qlogo.cn/g?b=qq&nk=${number}&s=${size}`
  },
  queries: {
    groups: {
      queryKey: ["groups"],
      queryFn: () => MessengerService.listGroups().then(({ data }) => data),
      refetchOnWindowFocus: false
    },
    users: {
      queryKey: ["users"],
      queryFn: () => MessengerService.listUsers().then(({ data }) => data),
      refetchOnWindowFocus: false
    }
  }
}
