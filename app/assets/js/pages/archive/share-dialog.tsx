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
import { Skeleton } from "@/components/ui/skeleton"
import { useQuery } from "@tanstack/react-query"
import { toPng } from "html-to-image"
import React, { useCallback } from "react"
import { useSearchParams } from "react-router-dom"

export const ShareDialog: React.FC<{ id: number }> = ({ id }) => {
  const [searchParams] = useSearchParams()
  const updateSearchParams = useUpdateSearchParams()

  const currentId = searchParams.get("share")
  const open = id.toString() === currentId

  const { data: url } = usePreviewQuery(currentId)

  const close = () => updateSearchParams((params) => params.delete("share"))

  const handleShare = useCallback(async () => {
    if (!url) return close()
    if ("share" in navigator) {
      const blob = await fetch(url).then((res) => res.blob())
      const file = new File([blob], `dian-${id}.png`, { type: "image/png" })
      const data = { title: "分享典图", files: [file] }
      await navigator.share(data)
      close()
    }
  }, [url])

  return (
    <Dialog open={open} onOpenChange={(open) => !open && close()}>
      <DialogContent className="w-[95vw] rounded-lg">
        <DialogHeader>
          <DialogTitle>分享该消息</DialogTitle>
          <DialogDescription>将该消息导出为图片并分享</DialogDescription>
        </DialogHeader>
        {!!currentId && <SharePreview id={currentId} />}
        <DialogFooter className="gap-2">
          <Button asChild>
            <a href={url} download={`dian-${id}.png`}>
              保存
            </a>
          </Button>
          <Button onClick={handleShare}>分享</Button>
        </DialogFooter>
        <DialogClose />
      </DialogContent>
    </Dialog>
  )
}

const usePreviewQuery = (id: string | null) =>
  useQuery({
    queryKey: ["dian", "one", "preview", id],
    queryFn: () => toPng(document.querySelector<HTMLElement>(`[data-dian-id="${id}"]`)!),
    enabled: !!id
  })

const SharePreview: React.FC<{ id: string }> = ({ id }) => {
  const { data: image, isLoading } = usePreviewQuery(id)

  return (
    <div className="overflow-auto">
      {isLoading ? (
        <div className="flex flex-col gap-3">
          <div className="flex items-center space-x-4">
            <Skeleton className="h-12 w-12 rounded-full" />
            <div className="space-y-2">
              <Skeleton className="h-4 w-32" />
              <Skeleton className="h-4 w-52" />
            </div>
          </div>
          <Skeleton className="h-4 w-64" />
          <Skeleton className="h-4 w-64" />
          <Skeleton className="h-4 w-80" />
        </div>
      ) : (
        <div className="overflow-hidden">
          <img src={image} loading="lazy" alt="share preview" />
        </div>
      )}
    </div>
  )
}
