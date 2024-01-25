import { useUpdateSearchParams } from "@/components/hooks/use-update-search-params"
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle
} from "@/components/ui/alert-dialog"
import { DianService } from "@/services"
import { queryClient } from "@/utils/client"
import { useMutation } from "@tanstack/react-query"
import { useSearchParams } from "react-router-dom"
import { toast } from "sonner"

export const DeleteDialog: React.FC<{ id: number }> = ({ id }) => {
  const [searchParams] = useSearchParams()
  const updateSearchParams = useUpdateSearchParams()

  const currentId = searchParams.get("delete")
  const open = id.toString() === currentId

  const close = () => updateSearchParams((params) => params.delete("delete"))

  const mutation = useMutation({
    mutationFn: () => DianService.deleteOne(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["dians", "list"] })
      toast.success("成功修改岁月史书！")
    }
  })

  return (
    <AlertDialog open={open} onOpenChange={(open) => !open && close()}>
      <AlertDialogContent>
        <AlertDialogHeader>
          <AlertDialogTitle>确定要删除吗?</AlertDialogTitle>
          <AlertDialogDescription>删除后不能恢复.</AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter>
          <AlertDialogCancel>取消</AlertDialogCancel>
          <AlertDialogAction disabled={mutation.isPending} onClick={() => mutation.mutate()}>
            删除
          </AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  )
}
