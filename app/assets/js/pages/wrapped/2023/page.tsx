import { StatisticsService, User, UserService, WrappedStatistics } from "@/services"
import { queryClient } from "@/utils/client"
import { useCallback, useState } from "react"
import { LoaderFunctionArgs, redirect, useLoaderData } from "react-router-dom"

import { Carousel } from "@ark-ui/react"
import * as AlertDialog from "@radix-ui/react-alert-dialog"
import { Helmet } from "react-helmet-async"
import { IntroCard } from "./intro-card"
import { KeywordCard } from "./keyword-card"
import { OverviewCard } from "./overview-card"
import { ProfileCard } from "./profile-card"
import { RelationshipCard } from "./relationship-card"
import { SliderControlContext } from "./slider-control"

export const wrappedLoader = async ({ request }: LoaderFunctionArgs) => {
  const url = new URL(request.url)
  const searchParams = url.searchParams

  let maybeUser = (queryClient.getQueryData(UserService.queries.current.queryKey) ||
    (await queryClient.fetchQuery(UserService.queries.current))) as User | null

  const number = maybeUser?.number || searchParams.get("q")

  if (!number) {
    throw redirect("/users/login?login_needed=true")
  }

  const user = maybeUser || {
    id: 0,
    number,
    avatar_url: `/api/messenger/users/avatar/${number}`,
    nickname: "Yes, Bro??"
  }

  const query = StatisticsService.queries.wrapped(number)

  const statistics = (queryClient.getQueryData(query.queryKey) ||
    (await queryClient.fetchQuery(query))) as WrappedStatistics

  return { statistics, user }
}

export const useWrappedLoaderData = () =>
  useLoaderData() as Awaited<ReturnType<typeof wrappedLoader>>

const CARDS = [IntroCard, OverviewCard, KeywordCard, RelationshipCard, ProfileCard]

export const Wrapped2023 = () => {
  const [currentIndex, setCurrentIndex] = useState(0)
  const nextSlide = useCallback(() => setCurrentIndex((prev) => prev + 1), [setCurrentIndex])

  return (
    <>
      <Helmet>
        <title>2023 Wrapped | Dian</title>
      </Helmet>
      <AlertDialog.Root open>
        <AlertDialog.Portal>
          <AlertDialog.Overlay className="fixed inset-0 bg-gray-950" />

          <AlertDialog.Content className="fixed max-w-md w-[85vw] h-[85vh] top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2">
            <Carousel.Root
              index={currentIndex}
              onIndexChange={({ index }) => setCurrentIndex(index)}
              loop={false}
            >
              <Carousel.IndicatorGroup className="flex justify-between gap-4 mb-4">
                {CARDS.map((_, index) => (
                  <Carousel.Indicator
                    key={index}
                    index={index}
                    className="w-full h-1 bg-gray-600 rounded data-[current]:bg-gray-50"
                  />
                ))}
              </Carousel.IndicatorGroup>

              <Carousel.Viewport className="overflow-x-hidden">
                <SliderControlContext.Provider value={nextSlide}>
                  <Carousel.ItemGroup>
                    {CARDS.map((Current, index) => (
                      <Carousel.Item key={index} index={index}>
                        <Current index={currentIndex} />
                      </Carousel.Item>
                    ))}
                  </Carousel.ItemGroup>
                </SliderControlContext.Provider>
              </Carousel.Viewport>
            </Carousel.Root>
          </AlertDialog.Content>
        </AlertDialog.Portal>
      </AlertDialog.Root>
    </>
  )
}
