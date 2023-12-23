import { useUpdateSearchParams } from "@/components/hooks/use-update-search-params"
import { UserService } from "@/services"
import { csrfToken } from "@/session"
import { HTTPError } from "ky"
import { useEffect } from "react"
import {
  Form,
  redirect,
  useLoaderData,
  type ActionFunctionArgs,
  type LoaderFunctionArgs
} from "react-router-dom"
import { toast } from "sonner"
import * as z from "zod"

import { SubmitButton } from "@/components/shared/submit-button"
import { UserSelect } from "@/components/shared/user-select"
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle
} from "@/components/ui/card"
import { Checkbox } from "@/components/ui/checkbox"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Helmet } from "react-helmet-async"

export const loginLoader = async ({ request }: LoaderFunctionArgs) => {
  const searchParams = new URL(request.url).searchParams

  const loginNeeded = searchParams.has("login_needed")
  const loginFailed = searchParams.has("login_failed")

  return { tab: searchParams.get("tab") ?? undefined, loginNeeded, loginFailed }
}

export const loginAction = async ({ request }: ActionFunctionArgs) => {
  const formData = await request.formData()
  const params = formSchema.parse(Object.fromEntries(formData.entries()))
  switch (params.intent) {
    case "register": {
      try {
        await UserService.requestRegistration(params.user)
        toast.success("赶紧去你的 QQ 邮箱里查看注册链接")
        return redirect("/")
      } catch (error) {
        if (error instanceof HTTPError && error.response.status === 400) {
          toast.error("似乎已经注册过了")
          return redirect("/users/login")
        } else {
          toast.error("出错了")
          return { ok: true }
        }
      }
    }
    default:
      toast.error("出错了")
      break
  }
}

export const useLoginLoaderData = () => useLoaderData() as Awaited<ReturnType<typeof loginLoader>>

const formSchema = z.discriminatedUnion("intent", [
  z.object({
    intent: z.literal("login"),
    user: z.string(),
    password: z.string(),
    remember_me: z.boolean()
  }),
  z.object({ intent: z.literal("register"), user: z.string() })
])

export const Login = () => {
  const { tab, loginFailed, loginNeeded } = useLoginLoaderData()
  const updateSearchParams = useUpdateSearchParams()

  useEffect(() => {
    let toastId: string | number
    if (loginFailed) {
      toastId = toast.error("登录失败")
    }
    return () => {
      toast.dismiss(toastId)
    }
  }, [loginFailed])

  useEffect(() => {
    let toastId: string | number
    if (loginNeeded) {
      toastId = toast.error("需要登录哦")
    }
    return () => {
      toast.dismiss(toastId)
    }
  }, [loginNeeded])

  return (
    <>
      <Helmet>
        <title>Login | Dian</title>
      </Helmet>
      <Tabs
        className="max-w-md mx-auto"
        defaultValue="login"
        value={tab}
        onValueChange={(value) =>
          updateSearchParams((searchParams) => searchParams.set("tab", value))
        }
      >
        <TabsList className="grid w-full grid-cols-2">
          <TabsTrigger value="login">登录</TabsTrigger>
          <TabsTrigger value="register">注册</TabsTrigger>
        </TabsList>

        <TabsContent value="login">
          <LoginTab />
        </TabsContent>

        <TabsContent value="register">
          <RegisterTab />
        </TabsContent>
      </Tabs>
    </>
  )
}

const LoginTab = () => {
  return (
    <Card>
      <CardHeader>
        <CardTitle>登录</CardTitle>
        <CardDescription>欢迎回到提瓦特大陆</CardDescription>
      </CardHeader>

      <CardContent>
        <form id="login-form" method="post" action="/api/account/users/login">
          <div className="space-y-3">
            <fieldset>
              <Label>用户</Label>
              <UserSelect name="user" required />
            </fieldset>
            <fieldset>
              <Label>密码</Label>
              <Input
                name="password"
                type="password"
                placeholder="******"
                autoComplete="current-password"
                required
              />
            </fieldset>
            <fieldset className="flex items-center gap-2">
              <Checkbox id="remember_me" name="remember_me" value="true" defaultChecked />
              <Label htmlFor="remember_me">记住我</Label>
            </fieldset>
            <input name="intent" type="text" value="login" readOnly hidden aria-hidden />
            <input name="_csrf_token" type="text" value={csrfToken} readOnly hidden aria-hidden />
          </div>
        </form>
      </CardContent>

      <CardFooter>
        <SubmitButton form="login-form">登录</SubmitButton>
      </CardFooter>
    </Card>
  )
}

const RegisterTab = () => {
  return (
    <Card>
      <CardHeader>
        <CardTitle>注册</CardTitle>
        <CardDescription>欢迎新的旅行者</CardDescription>
      </CardHeader>

      <CardContent>
        <Form id="register-form" method="post">
          <fieldset>
            <Label htmlFor="user">用户</Label>
            <UserSelect name="user" required />
          </fieldset>
          <input name="intent" type="text" value="register" readOnly hidden aria-hidden />
        </Form>
      </CardContent>

      <CardFooter>
        <SubmitButton form="register-form">注册</SubmitButton>
      </CardFooter>
    </Card>
  )
}
