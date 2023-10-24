import { DianService, type MessageContent } from "@/services"
import { queryClient } from "@/utils/client"
import { useQuery } from "@tanstack/react-query"
import { useMemo } from "react"
import { Link, useLoaderData, type LoaderFunctionArgs } from "react-router-dom"

import { EyeIcon } from "lucide-react"
import { Helmet } from "react-helmet-async"
import { PhotoProvider, PhotoView } from "react-photo-view"

export const galleryLoader = async ({ request }: LoaderFunctionArgs) => {
  const searchParams = new URL(request.url).searchParams

  const page = searchParams.get("page") ?? 1
  const query = DianService.queries.images(page)

  if (!queryClient.getQueryData(query.queryKey)) {
    await queryClient.fetchQuery(query)
  }

  return { page }
}

export const useGalleryLoaderData = () =>
  useLoaderData() as Awaited<ReturnType<typeof galleryLoader>>

export const Gallery = () => {
  const { page } = useGalleryLoaderData()
  const { data } = useQuery(DianService.queries.images(page))
  const { entries: dians } = data!

  const images = useMemo(
    () =>
      dians
        .map(({ id, operator, message }) => ({
          id,
          operator,
          images: message.content.filter(isImage)
        }))
        .filter(({ images }) => images.length !== 0),
    dians
  )

  return (
    <>
      <Helmet>
        <title>Gallery | Dian</title>
      </Helmet>
      <div>
        <PhotoProvider
          toolbarRender={({ index, images }) => {
            const id = images[index].originRef?.current?.dataset.dianId

            return (
              <>
                <Link to={`/archive/${id}`}>
                  <EyeIcon className="w-6 h-6 opacity-75 hover:opacity-100" />
                  <span className="sr-only">Goto message</span>
                </Link>
              </>
            )
          }}
        >
          <div className="grid grid-cols-2 md:grid-cols-3 gap-2">
            {images.map(({ id, images }) => {
              const {
                data: { url }
              } = images[0]

              return (
                <PhotoView key={id} src={url}>
                  <img
                    className="w-40 h-40 md:w-64 md:h-64 object-contain border border-border rounded-sm"
                    src={url}
                    alt="maybe a meme"
                    loading="lazy"
                    data-dian-id={id}
                  />
                </PhotoView>
              )
            })}
          </div>
        </PhotoProvider>
      </div>
    </>
  )
}

const isImage = (message: MessageContent): message is { type: "image"; data: { url: string } } =>
  message.type === "image"
