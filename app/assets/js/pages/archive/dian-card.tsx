import { WithUserHoverCard } from "@/components/shared/user-card"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Card, CardContent, CardFooter, CardHeader } from "@/components/ui/card"
import { MessageContent, MessengerService, type Dian } from "@/services"
import { formatDate } from "@/utils/date"
import { useQuery } from "@tanstack/react-query"
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
            <Content
              key={`${dian.id}-${message.id}-${i}`}
              id={`${dian.id}-${message.id}`}
              content={content}
            />
          ))}
        </div>
      </CardContent>

      <CardFooter className="px-4">
        <div className="w-full flex justify-between text-xs">
          <div>来自 {group.name}</div>
          <div>
            由{" "}
            <WithUserHoverCard user={operator}>
              <span className="hover:underline cursor-pointer">{operator.nickname}</span>
            </WithUserHoverCard>{" "}
            设置
          </div>
        </div>
      </CardFooter>
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

const Reply: React.FC<{ number: string | null }> = ({ number }) => {
  const { data, isFetching } = useQuery(MessengerService.queries.message(number))
  console.log(isFetching)
  if (!number) return null
  return (
    <Card className="shadow-sm mb-2">
      {isFetching ? (
        "loading..."
      ) : (
        <>
          <CardHeader className="p-4">
            <div className="flex gap-2 items-center">
              <Avatar className="w-9 h-9">
                <AvatarImage src={data!.sender.avatar_url} />
                <AvatarFallback>{data!.sender.nickname.slice(0, 2)}</AvatarFallback>
              </Avatar>
              <WithUserHoverCard user={data!.sender}>
                <span className="text-sm hover:underline cursor-pointer">
                  {data!.sender.nickname}
                </span>
              </WithUserHoverCard>
            </div>
          </CardHeader>

          <CardContent className="px-4 pb-4">
            <div>
              {data!.content.map((content, i) => (
                <Content
                  key={`${data!.id}-reply-${i}`}
                  id={`${data!.id}-reply`}
                  content={content}
                />
              ))}
            </div>
          </CardContent>
        </>
      )}
    </Card>
  )
}

const Content: React.FC<{ id: string; content: MessageContent }> = ({ id, content }) => {
  const { type, data } = content

  switch (type) {
    case "text":
      return data.map((text, i) => <Text key={`${id}-${i}`} text={text} />)
    case "at":
      return <At user={data} />
    case "image":
      return <Image url={data.url} />
    case "reply":
      return <Reply number={data.exists ? data.number : null} />
    default:
      return null
  }
}
