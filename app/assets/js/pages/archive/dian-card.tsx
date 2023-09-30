import { WithUserHoverCard } from "@/components/shared/user-card"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Card, CardContent, CardHeader } from "@/components/ui/card"
import { MessageContent, type Dian } from "@/services"
import { formatDate } from "@/utils/date"
import React from "react"

export const DianCard: React.FC<{ dian: Dian }> = ({ dian }) => {
  const { message, operator } = dian
  const { sender, group } = message

  return (
    <Card className="rounded-lg shadow-sm">
      <CardHeader className="p-4">
        <div className="flex gap-2">
          <Avatar className="w-11 h-11">
            <AvatarImage src={sender.avatar_url} />
            <AvatarFallback>{sender.nickname.slice(0, 2)}</AvatarFallback>
          </Avatar>
          <div className="flex flex-col justify-between">
            <WithUserHoverCard user={sender}>
              <span className="hover:underline cursor-pointer">{sender.nickname}</span>
            </WithUserHoverCard>
            <span className="text-xs">{formatDate(message.sent_at)} 发送</span>
          </div>
        </div>
      </CardHeader>
      <CardContent className="px-4">
        <div>
          {message.content.map((content, i) => (
            <Content key={`${dian.id}-${i}`} id={dian.id} content={content} />
          ))}
        </div>
        <div className="pt-4 flex justify-between text-xs">
          <div>来自 {group.name}</div>
          <div>
            由{" "}
            <WithUserHoverCard user={operator}>
              <span className="hover:underline cursor-pointer">{operator.nickname}</span>
            </WithUserHoverCard>{" "}
            设置
          </div>
        </div>
      </CardContent>
    </Card>
  )
}

const Text: React.FC<{ text: string }> = ({ text }) => {
  return <p className="leading-7">{text}</p>
}

const At: React.FC<{ user: { nickname: string; number: string } }> = ({ user }) => {
  return (
    <WithUserHoverCard user={user}>
      <span className="text-blue-700 mr-2 cursor-pointer hover:underline [&+p]:inline-block">
        @{user.nickname}
      </span>
    </WithUserHoverCard>
  )
}

const Image: React.FC<{ url: string }> = ({ url }) => {
  return <img src={url} alt="maybe a meme" loading="lazy" />
}

const Content: React.FC<{ id: number; content: MessageContent }> = ({ id, content }) => {
  const { type, data } = content

  switch (type) {
    case "text":
      return data.map((text, i) => <Text key={`${id}-${i}`} text={text} />)
    case "at":
      return <At user={data} />
    case "image":
      return <Image url={data.url} />
  }
}
