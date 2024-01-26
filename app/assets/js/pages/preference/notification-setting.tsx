import { Switch } from "@/components/ui/switch"
import { NotificationService } from "@/services"
import { useMutation, useQuery } from "@tanstack/react-query"
import { toast } from "sonner"

export const NotificationSetting = () => {
  const query = useQuery(NotificationService.queries.isSubscribed)
  const subscribeMutation = useMutation(NotificationService.mutations.subscribe)
  const cancelMutation = useMutation(NotificationService.mutations.cancel)

  const handleEnable = async () => {
    if (Notification.permission !== "granted") {
      toast.message("请确定授予推送通知权限")
      const permission = await Notification.requestPermission()
      if (permission !== "granted") return
    }
    subscribeMutation.mutate()
  }

  return (
    <Switch
      id="enableNotification"
      disabled={query.isLoading || subscribeMutation.isPending || cancelMutation.isPending}
      checked={query.data ?? false}
      onCheckedChange={(value) => {
        if (value) {
          handleEnable()
        } else {
          cancelMutation.mutate()
        }
      }}
    />
  )
}
