import { SubmitButton } from "@/components/shared/submit-button"
import { UserAvatar } from "@/components/shared/user-avatar"
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle
} from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { UserService } from "@/services"
import { Helmet } from "react-helmet-async"
import {
  Form,
  redirect,
  useLoaderData,
  type ActionFunctionArgs,
  type LoaderFunctionArgs
} from "react-router-dom"
import { toast } from "sonner"
import * as z from "zod"

export const confirmLoader = async ({ params }: LoaderFunctionArgs) => {
  const token = params.token!
  const { data: user } = await UserService.verifyToken(token)
  return {
    token,
    user
  }
}

export const confirmAction = async ({ request }: ActionFunctionArgs) => {
  const formData = await request.formData()
  const params = formSchema.parse(Object.fromEntries(formData.entries()))

  try {
    const { data: _user } = await UserService.confirmRegistration(params)
    toast.success("注册成功")
    return redirect("/users/login")
  } catch (error) {
    toast.error("出错了")
    return { ok: true }
  }
}

export const useConfirmLoaderData = () =>
  useLoaderData() as Awaited<ReturnType<typeof confirmLoader>>

const formSchema = z.object({
  token: z.string(),
  password: z.string().min(10).max(72)
})

// TODO: password length validation

export const Confirm = () => {
  const { token, user } = useConfirmLoaderData()

  return (
    <>
      <Helmet>
        <title>Register | Dian</title>
      </Helmet>
      <Card className="max-w-md mx-auto">
        <CardHeader>
          <CardTitle>确认注册</CardTitle>
          <CardDescription>欢迎加入蒙德</CardDescription>
        </CardHeader>

        <CardContent>
          <div className="mb-6 flex gap-3 items-center">
            <UserAvatar user={user} />
            <div className="font-medium">你好，{user.nickname}</div>
          </div>
          <Form id="confirm-form" method="post">
            <fieldset>
              <Label>密码</Label>
              <Input
                name="password"
                type="password"
                minLength={10}
                maxLength={72}
                placeholder="**********"
                autoComplete="current-password"
                required
              />
            </fieldset>
            <input name="token" type="text" value={token} readOnly hidden aria-hidden />
          </Form>
        </CardContent>

        <CardFooter>
          <SubmitButton form="confirm-form">确定</SubmitButton>
        </CardFooter>
      </Card>
    </>
  )
}
