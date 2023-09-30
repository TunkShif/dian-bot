import {
  DianService,
  MessengerService,
  StatisticsService,
  type Dian,
  type ListAllDianParams
} from "@/services"
import { queryClient } from "@/utils/client"
import { useQuery } from "@tanstack/react-query"
import React from "react"
import { Link, useLoaderData, type LoaderFunctionArgs } from "react-router-dom"

import { Empty } from "@/components/shared/empty"
import { Button } from "@/components/ui/button"
import { DatePicker } from "@/pages/archive/date-picker"
import { DianCard } from "@/pages/archive/dian-card"
import { GroupSelect } from "@/pages/archive/group-select"
import { Paginations } from "@/pages/archive/pagination"
import { SearchBar } from "@/pages/archive/search-bar"
import { UserSelect } from "@/pages/archive/user-select"
import { RotateCcwIcon } from "lucide-react"

export const archiveLoader = async ({ request }: LoaderFunctionArgs) => {
  const searchParams = new URL(request.url).searchParams

  const params: ListAllDianParams = Object.fromEntries(
    ["group", "sender", "keyword", "date", "page"]
      .map((key) => [key, searchParams.get(key)])
      .filter(([, value]) => !!value)
  )

  const query = DianService.queries.list(params)

  if (!queryClient.getQueryData(query.queryKey)) {
    await queryClient.fetchQuery(query)
  }

  queryClient.prefetchQuery(MessengerService.queries.users)
  queryClient.prefetchQuery(MessengerService.queries.groups)
  queryClient.prefetchQuery(StatisticsService.queries.hotwords)

  return {
    params
  }
}

export const useArchiveLoaderData = () =>
  useLoaderData() as Awaited<ReturnType<typeof archiveLoader>>

export const Archive = () => {
  const { params } = useArchiveLoaderData()
  const { data } = useQuery(DianService.queries.list(params))
  const {
    entries: dians,
    metadata: { page_number, total_entries }
  } = data!

  return (
    <div>
      <section className="grid grid-rows-2 md:grid-rows-1 grid-cols-2 gap-4 w-full">
        <div className="flex col-span-2 w-full gap-4">
          <SearchBar />
          <DatePicker />
          <Button variant="outline" size="icon" title="重置" asChild>
            <Link to="?">
              <RotateCcwIcon className="w-4 h-4" />
            </Link>
          </Button>
        </div>

        <GroupSelect />
        <UserSelect />
      </section>

      <section className="mt-4">
        <DianList dians={dians} />
      </section>

      <section className="flex mt-4 justify-end">
        <Paginations page={page_number} count={total_entries} />
      </section>
    </div>
  )
}

const DianList: React.FC<{ dians: Dian[] }> = ({ dians }) => {
  if (dians.length === 0) return <Empty />

  return (
    <ul className="flex flex-col gap-4">
      {dians!.map((dian) => (
        <li key={dian.id}>
          <DianCard dian={dian} />
        </li>
      ))}
    </ul>
  )
}
