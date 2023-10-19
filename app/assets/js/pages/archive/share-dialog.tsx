import { useUpdateSearchParams } from "@/components/hooks/use-update-search-params"
import { Button } from "@/components/ui/button"
import {
  Dialog,
  DialogClose,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle
} from "@/components/ui/dialog"
import { Dian, DianService } from "@/services"
import { queryClient } from "@/utils/client"
import { formatDate } from "@/utils/date"
import { useQuery } from "@tanstack/react-query"
import React from "react"
import { useSearchParams } from "react-router-dom"
import satori from "satori"

export const ShareDialog: React.FC<{ id: number }> = ({ id }) => {
  const [searchParams] = useSearchParams()
  const updateSearchParams = useUpdateSearchParams()

  const currentId = searchParams.get("share")
  const open = id.toString() === currentId

  const close = () => updateSearchParams((params) => params.delete("share"))

  const handleShare = () => {
    const image: string | undefined = queryClient.getQueryData([
      "dian",
      "one",
      "render",
      parseInt(currentId ?? "0")
    ])
    if (!image) return close()
    if ("share" in navigator) {
      const blob = new Blob([image], { type: "image/svg+xml" })
      const file = new File([blob], "dian.svg", { type: "image/svg+xml" })
      navigator.share({ title: "分享典图", files: [file] }).then(() => close())
    }
  }

  return (
    <Dialog open={open} onOpenChange={(open) => !open && close()}>
      <DialogContent className="w-[95vw] rounded-lg">
        <DialogHeader>
          <DialogTitle>分享该消息</DialogTitle>
          <DialogDescription>将该消息导出为图片并分享</DialogDescription>
        </DialogHeader>
        {!!currentId && <SharePreview id={currentId} />}
        <DialogFooter>
          <Button onClick={handleShare}>分享</Button>
        </DialogFooter>
        <DialogClose />
      </DialogContent>
    </Dialog>
  )
}

const SharePreview: React.FC<{ id: string }> = ({ id }) => {
  const { data: dian } = useQuery({
    ...DianService.queries.one(id!)
  })
  const { data: image, isLoading } = useQuery({
    queryKey: ["dian", "one", "render", dian?.id],
    queryFn: () => renderSvg(dian!),
    enabled: !!dian?.id
  })

  return (
    <div className="overflow-auto">
      {isLoading ? (
        "Loading..."
      ) : (
        <div className="overflow-hidden" dangerouslySetInnerHTML={{ __html: image! }} />
      )}
    </div>
  )
}

const initFont = async () => [
  {
    name: "Sarasa UI SC",
    data: await fetch("/assets/fonts/sarasa-ui-sc-regular.ttf").then((res) => res.arrayBuffer())
  }
]

const renderSvg = async (dian: Dian) => {
  return await satori(<Dian dian={dian} />, {
    width: 360,
    height: 400,
    fonts: await initFont()
  })
}

const Dian: React.FC<{ dian: Dian }> = ({ dian }) => {
  const { message, operator } = dian
  const { sender, group } = message

  return (
    <div style={{ display: "flex", flexDirection: "column", color: "rgb(9, 9, 11)" }}>
      <div style={{ display: "flex", gap: "8px", height: "44px", paddingBottom: "8px" }}>
        <div
          style={{
            display: "flex",
            justifyContent: "center",
            alignItems: "center",
            width: "44px",
            height: "44px",
            border: "1px hsl(240 5.9% 90%)",
            borderRadius: 9999
          }}
        >
          ???
        </div>
        <div style={{ display: "flex", flexDirection: "column", justifyContent: "space-between" }}>
          <p style={{ fontSize: "16px", lineHeight: "24px" }}>{sender.nickname}</p>
          <p style={{ fontSize: "12px", lineHeight: "16px" }}>{formatDate(message.sent_at)}</p>
        </div>
      </div>

      <div style={{ display: "flex", flexDirection: "column" }}>
        {message.content.map((content) => {
          const { type, data } = content
          switch (type) {
            case "at":
              return <p>@{data.nickname}</p>
            case "text":
              return data.map((text) => (
                <p style={{ fontSize: "16px", lineHeight: "24px" }}>{text}</p>
              ))
            default:
              return null
          }
        })}
      </div>

      <div
        style={{
          display: "flex",
          justifyContent: "space-between",
          width: "360px",
          fontSize: "12px",
          lineHeight: "16px",
          paddingTop: "8px"
        }}
      >
        <p>来自 {group.name}</p>
        <p>
          由 <span className="hover:underline cursor-pointer">{operator.nickname}</span> 设置
        </p>
      </div>
    </div>
  )
}
