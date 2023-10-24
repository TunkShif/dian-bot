import type { Data, User } from "@/services"
import { httpClient } from "@/utils/client"

export type AuthedUser = User & { role: "user" | "admin" }

export const UserService = {
  requestRegistration(id: number | string) {
    return httpClient.post(`/api/account/users/request/${id}`).json<Data<null>>()
  },
  confirmRegistration(params: { token: string; password: string }) {
    return httpClient
      .post(`/api/account/users/confirm/${params.token}`, {
        body: JSON.stringify({ password: params.password })
      })
      .json<Data<User>>()
  },
  verifyToken(token: string) {
    return httpClient.get(`/api/account/users/verify/${token}`).json<Data<User>>()
  },
  currentUser() {
    return httpClient.get(`/api/account/users/me`).json<Data<AuthedUser | null>>()
  },
  queries: {
    current: {
      queryKey: ["session", "me"],
      queryFn: () => UserService.currentUser().then(({ data }) => data)
    }
  }
}
