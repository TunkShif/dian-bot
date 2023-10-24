import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import type { User } from "@/services"
import { cn } from "@/utils/styling"
import React from "react"

export const UserAvatar: React.FC<{ className?: string; user: User }> = ({ className, user }) => {
  return (
    <Avatar className={cn("w-9 h-9 border border-border", className)}>
      <AvatarImage src={user.avatar_url} alt="user avatar" loading="lazy" />
      <AvatarFallback delayMs={200}>{user.nickname.slice(0, 2)}</AvatarFallback>
    </Avatar>
  )
}
