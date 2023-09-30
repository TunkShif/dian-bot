import { useUpdateSearchParams } from "@/components/hooks/use-update-search-params"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
  SelectValue,
  SelectViewport
} from "@/components/ui/select"
import { LoadingSpinner } from "@/components/ui/spinner"
import { useArchiveLoaderData } from "@/pages/archive/page"
import { MessengerService } from "@/services"
import { useQuery } from "@tanstack/react-query"
import { useDebouncedValue } from "foxact/use-debounced-value"
import { SearchIcon, User2Icon } from "lucide-react"
import { useMemo, useState } from "react"

export const UserSelect = () => {
  const { params } = useArchiveLoaderData()
  const updateSearchParams = useUpdateSearchParams()

  const { data: users, isLoading } = useQuery(MessengerService.queries.users)

  const [keyword, setKeyword] = useState("")
  const debouncedKeyword = useDebouncedValue(keyword, 400)
  const filtered = useMemo(
    () => users?.filter((user) => user.nickname.includes(debouncedKeyword)) ?? [],
    [users, debouncedKeyword]
  )

  return (
    <Select
      value={params.sender}
      onValueChange={(value) => {
        setKeyword("")
        updateSearchParams((searchParams) => {
          searchParams.set("sender", value)
          searchParams.delete("page")
        })
      }}
    >
      <SelectTrigger className="w-full [&>svg]:shrink-0">
        <div className="inline-flex items-center truncate">
          <User2Icon className="w-4 h-4 mr-2 shrink-0" />
          <SelectValue placeholder="按用户过滤" />
        </div>
      </SelectTrigger>

      <SelectContent className="w-72 md:w-auto">
        <div className="flex px-2 pb-3 pt-2 mb-1 h-10 border-b items-center bg-background">
          <SearchIcon className="w-4 h-4 mr-2" />
          <input
            value={keyword}
            placeholder="按昵称搜索"
            onChange={(e) => setKeyword(e.target.value)}
            className="flex w-full rounded-md bg-transparent text-sm outline-none placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50"
          />
        </div>

        <SelectViewport>
          <SelectGroup className="max-h-72">
            {isLoading ? (
              <LoadingSpinner />
            ) : (
              filtered!.map((user) => (
                <SelectItem key={user.number} value={user.id.toString()} textValue="\0">
                  <div className="flex items-center gap-2">
                    <Avatar className="w-5 h-5">
                      <AvatarImage src={user.avatar_url} />
                      <AvatarFallback delayMs={600}>{user.nickname.slice(0, 2)}</AvatarFallback>
                    </Avatar>
                    <span>
                      {user.nickname} ({user.number})
                    </span>
                  </div>
                </SelectItem>
              ))
            )}
          </SelectGroup>
        </SelectViewport>
      </SelectContent>
    </Select>
  )
}
