import { useUpdateSearchParams } from "@/components/hooks/use-update-search-params"
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectLabel,
  SelectTrigger,
  SelectValue,
  SelectViewport
} from "@/components/ui/select"
import { LoadingSpinner } from "@/components/ui/spinner"
import { useArchiveLoaderData } from "@/pages/archive/page"
import { MessengerService } from "@/services"
import { useQuery } from "@tanstack/react-query"
import { Users2Icon } from "lucide-react"

export const GroupSelect = () => {
  const { params } = useArchiveLoaderData()
  const updateSearchParams = useUpdateSearchParams()

  const { data: groups, isLoading } = useQuery(MessengerService.queries.groups)

  return (
    <Select
      value={params.group}
      onValueChange={(value) =>
        updateSearchParams((searchParams) => {
          searchParams.set("group", value)
          searchParams.delete("page")
        })
      }
    >
      <SelectTrigger className="w-full last:shrink-0 [&>svg]:shrink-0">
        <div className="inline-flex items-center truncate">
          <Users2Icon className="w-4 h-4 mr-2 shrink-0" />
          <SelectValue placeholder="按群组过滤" />
        </div>
      </SelectTrigger>

      <SelectContent>
        <SelectViewport>
          <SelectGroup>
            <SelectLabel>群组</SelectLabel>

            {isLoading ? (
              <LoadingSpinner />
            ) : (
              groups!.map((group) => (
                <SelectItem key={group.number} value={group.id.toString()}>
                  {group.name}
                </SelectItem>
              ))
            )}
          </SelectGroup>
        </SelectViewport>
      </SelectContent>
    </Select>
  )
}
