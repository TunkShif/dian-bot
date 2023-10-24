import { QueryClient } from "@tanstack/react-query"
import ky from "ky"

export const queryClient = new QueryClient()

export const httpClient = ky.create({
  headers: {
    accept: "application/json",
    "content-type": "application/json",
    "x-csrf-token": sessionStorage.getItem("csrfToken") ?? ""
  }
})
