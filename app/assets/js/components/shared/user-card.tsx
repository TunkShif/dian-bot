import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import {
  HoverCard,
  HoverCardContent,
  HoverCardPortal,
  HoverCardTrigger
} from "@/components/ui/hover-card"
import { LoadingSpinner } from "@/components/ui/spinner"
import { MessengerService, StatisticsService, type User } from "@/services"
import { useQuery } from "@tanstack/react-query"
import { AwardIcon, BananaIcon } from "lucide-react"
import React from "react"

type MaybeUser = Omit<User, "avatar_url" | "id"> & { id?: string | number; avatar_url?: string }

export const WithUserHoverCard: React.FC<React.PropsWithChildren<{ user: MaybeUser }>> = ({
  user,
  children
}) => {
  return (
    <HoverCard openDelay={500}>
      <HoverCardTrigger asChild>{children}</HoverCardTrigger>
      <HoverCardPortal>
        <HoverCardContent collisionPadding={8} className="w-full">
          <UserCardContent user={user} />
        </HoverCardContent>
      </HoverCardPortal>
    </HoverCard>
  )
}

export const UserCardContent: React.FC<{
  user: MaybeUser
}> = ({ user }) => {
  const { number, nickname } = user
  const avatarUrl = user.avatar_url ?? MessengerService.generateUserAvatarUrl(number)

  const { data, isLoading } = useQuery(StatisticsService.queries.user(user.id ?? null))

  return (
    <div className="w-72 flex flex-col gap-4">
      <div className="flex gap-2 items-center">
        <Avatar className="w-9 h-9">
          <AvatarImage src={avatarUrl} />
          <AvatarFallback delayMs={600}>{nickname.slice(0, 2)}</AvatarFallback>
        </Avatar>
        <div className="flex flex-col justify-start items-start">
          <span className="text-sm md:text-base">{nickname}</span>
          <span className="text-xs md:text-sm">({number})</span>
        </div>
      </div>
      <div className="flex gap-4 items-center">
        {(() => {
          if (!user.id) return null
          if (isLoading) return <LoadingSpinner className="py-2" />
          return (
            !!data && (
              <>
                <div className="flex items-center gap-2">
                  <BananaIcon className="w-5 h-5" />
                  <div className="text-sm">
                    共设精 <span className="font-medium">{data.as_operator || 0}</span> 次
                  </div>
                </div>
                <div className="flex items-center gap-2">
                  <AwardIcon className="w-5 h-5" />
                  <div className="text-sm">
                    已入典 <span className="font-medium">{data.as_sender || 0}</span> 次
                  </div>
                </div>
              </>
            )
          )
        })()}
      </div>
    </div>
  )
}
