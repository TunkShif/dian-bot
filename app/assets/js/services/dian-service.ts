import type { Message, PaginatedData, User } from "@/services"
import ky from "ky"

export type Dian = {
  id: number
  message: Message
  operator: User
}

export type ListAllDianParams = {
  group?: string
  sender?: string
  date?: string
  keyword?: string
  page?: string
}

export const DianService = {
  listAll(params?: ListAllDianParams) {
    return ky.get("/api/diaans", { searchParams: params }).json<PaginatedData<Dian>>()
  },
  queries: {
    all: { queryKey: ["dians"] },
    list: (params?: ListAllDianParams) => ({
      queryKey: ["dians", "list", params],
      queryFn: () => DianService.listAll(params).then(({ data }) => data)
    })
  }
}
