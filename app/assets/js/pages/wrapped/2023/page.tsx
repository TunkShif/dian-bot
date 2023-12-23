import { UserService } from "@/services"
import { queryClient } from "@/utils/client"
import { useCallback, useState } from "react"
import { LoaderFunctionArgs, redirect } from "react-router-dom"
import { toast } from "sonner"

import { Carousel } from "@ark-ui/react"
import * as AlertDialog from "@radix-ui/react-alert-dialog"
import { IntroCard } from "./intro-card"
import { KeywordCard } from "./keyword-card"
import { OverviewCard } from "./overview-card"
import { ProfileCard } from "./profile-card"
import { RelationshipCard } from "./relationship-card"
import { SliderControlContext } from "./slider-control"

export const wrappedLoader = async ({ request }: LoaderFunctionArgs) => {
  const url = new URL(request.url)
  const searchParams = url.searchParams

  const user = await queryClient.fetchQuery(UserService.queries.current)
  const number = user?.number || searchParams.get("q")

  if (!number) {
    toast.error("要先登录哦")
    throw redirect("/users/login")
  }

  return {}
}

const CARDS = [IntroCard, OverviewCard, KeywordCard, RelationshipCard, ProfileCard]

export const Wrapped2023 = () => {
  const [currentIndex, setCurrentIndex] = useState(0)
  const nextSlide = useCallback(() => setCurrentIndex((prev) => prev + 1), [setCurrentIndex])

  return (
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
                  {CARDS.map((Card, index) => (
                    <Carousel.Item key={index} index={index}>
                      <Card />
                    </Carousel.Item>
                  ))}
                </Carousel.ItemGroup>
              </SliderControlContext.Provider>
            </Carousel.Viewport>
          </Carousel.Root>
        </AlertDialog.Content>
      </AlertDialog.Portal>
    </AlertDialog.Root>
  )
}
