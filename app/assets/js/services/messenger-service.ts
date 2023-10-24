import type { Data, ListData } from "@/services"
import { httpClient } from "@/utils/client"

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
  id: number
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
  | {
    type: "reply"
    data: {
      exists?: boolean
      number: string
    }
  }

export const MessengerService = {
  listGroups() {
    return httpClient.get("/api/messenger/groups").json<ListData<Group>>()
  },
  listUsers() {
    return httpClient.get("/api/messenger/users").json<ListData<User>>()
  },
  getMessage(number: string) {
    return httpClient.get(`/api/messenger/messages/${number}`).json<Data<Message | null>>()
  },
  generateUserAvatarUrl(number: string, size: number = 100) {
    return `https://q.qlogo.cn/g?b=qq&nk=${number}&s=${size}`
  },
  queries: {
    groups: {
      queryKey: ["messenger", "groups"],
      queryFn: () => MessengerService.listGroups().then(({ data }) => data),
      refetchOnWindowFocus: false
    },
    users: {
      queryKey: ["messenger", "users"],
      queryFn: () => MessengerService.listUsers().then(({ data }) => data),
      refetchOnWindowFocus: false
    },
    message: (number: string | null) => ({
      queryKey: ["messenger", "messages", number],
      queryFn: () => MessengerService.getMessage(number!).then(({ data }) => data),
      refetchOnWindowFocus: false,
      enabled: number !== null
    })
  }
}
