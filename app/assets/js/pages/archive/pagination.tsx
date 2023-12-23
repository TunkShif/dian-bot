import { useUpdateSearchParams } from "@/components/hooks/use-update-search-params"
import { Button } from "@/components/ui/button"
import { Pagination } from "@ark-ui/react"
import { ChevronLeftIcon, ChevronRightIcon } from "lucide-react"
import React from "react"

export const Paginations: React.FC<{ count: number; page: number }> = ({ count, page }) => {
  const updateSearchParams = useUpdateSearchParams()

  const handlePagination = (page: number | null) =>
    page && updateSearchParams((searchParams) => searchParams.set("page", page.toString()))

  if (count === 0) return null

  return (
    <Pagination.Root count={count} page={page} pageSize={10} siblingCount={1}>
      {({ previousPage, nextPage }) => (
        <div className="flex justify-center items-center gap-2">
          <Pagination.PrevTrigger asChild>
            <Button
              variant="outline"
              className="disabled:cursor-not-allowed"
              onClick={() => handlePagination(previousPage)}
            >
              <ChevronLeftIcon className="w-5 h-5" />
            </Button>
          </Pagination.PrevTrigger>

          <Pagination.NextTrigger>
            <Button
              variant="outline"
              className="disabled:cursor-not-allowed"
              onClick={() => handlePagination(nextPage)}
            >
              <ChevronRightIcon className="w-5 h-5" />
            </Button>
          </Pagination.NextTrigger>
        </div>
      )}
    </Pagination.Root>
  )
}
