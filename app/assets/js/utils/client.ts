import { csrfToken } from "@/session"
import { QueryClient } from "@tanstack/react-query"
import ky from "ky"

// TODO: cache (persistent cache/service worker cache)
export const queryClient = new QueryClient()

export const httpClient = ky.create({
  headers: {
    accept: "application/json",
    "content-type": "application/json",
    "x-csrf-token": csrfToken
  }
})
