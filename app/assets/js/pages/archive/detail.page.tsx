import { DianCard } from "@/pages/archive/dian-card"
import { DianService } from "@/services"
import { queryClient } from "@/utils/client"
import { useLoaderData, type LoaderFunctionArgs } from "react-router-dom"

export const archiveDetailLoader = async ({ params }: LoaderFunctionArgs) => {
  const id = params.id!

  const query = DianService.queries.one(id)

  return {
    dian: await queryClient.fetchQuery(query)
  }
}

export const useArchiveDetailLoaderData = () =>
  useLoaderData() as Awaited<ReturnType<typeof archiveDetailLoader>>

export const ArchiveDetail = () => {
  const { dian } = useArchiveDetailLoaderData()

  return <DianCard dian={dian} />
}
