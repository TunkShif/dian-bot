import { useCallback } from "react"
import { useSearchParams } from "react-router-dom"

export const useUpdateSearchParams = () => {
  const [, setSearchParams] = useSearchParams()

  return useCallback(
    (update: (searchParams: URLSearchParams) => void) => {
      setSearchParams(
        (searchParams) => {
          const cloned = new URLSearchParams(searchParams.toString())
          update(cloned)
          return cloned
        },
        { preventScrollReset: true }
      )
    },
    [setSearchParams]
  )
}
