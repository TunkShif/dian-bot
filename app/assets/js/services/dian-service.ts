import type { Data, Message, PaginatedData, User } from "@/services"
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

export type ListImagesParams = {
  page?: string
}

export const DianService = {
  listAll(params?: ListAllDianParams) {
    return ky.get("/api/diaans", { searchParams: params }).json<PaginatedData<Dian>>()
  },
  listImages(page?: string | number) {
    return ky
      .get("/api/diaans/images", { searchParams: { page: page ?? 1, page_size: 30 } })
      .json<PaginatedData<Dian>>()
  },
  getOne(id: string | number) {
    return ky.get(`/api/diaans/${id}`).json<Data<Dian>>()
  },
  queries: {
    all: { queryKey: ["dians"] },
    list: (params?: ListAllDianParams) => ({
      queryKey: ["dians", "list", params],
      queryFn: () => DianService.listAll(params).then(({ data }) => data)
    }),
    images: (page?: string | number) => ({
      queryKey: ["dians", "images", page],
      queryFn: () => DianService.listImages(page).then(({ data }) => data)
    }),
    one: (id: string | number) => ({
      queryKey: ["dians", "one", id],
      queryFn: () => DianService.getOne(id).then(({ data }) => data),
      refetchOnWindowFocus: false
    })
  }
}
