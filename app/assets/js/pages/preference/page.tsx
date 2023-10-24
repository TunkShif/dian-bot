import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Separator } from "@/components/ui/separator"
import { Switch } from "@/components/ui/switch"
import { preferencesAtom } from "@/pages/atoms"
import { useAtom } from "jotai/react"
import { Helmet } from "react-helmet-async"

// TODO: refactor logic

export const Preferences = () => {
  const [preferences, setPreferences] = useAtom(preferencesAtom)

  return (
    <>
      <Helmet>
        <title>Preferences | Dian</title>
      </Helmet>
      <Card>
        <CardHeader>
          <CardTitle>设定</CardTitle>
          <CardDescription>调整个性化设置</CardDescription>
        </CardHeader>

        <CardContent>
          <Separator className="mb-6" />
          <section className="flex justify-between items-center gap-2">
            <div className="space-y-1.5">
              <CardTitle>渲染 Markdown</CardTitle>
              <CardDescription>是否将消息内容以 Markdown 格式渲染展示</CardDescription>
            </div>

            <div className="shrink-0 grow-0">
              <Switch
                id="renderMarkdown"
                name="renderMarkdown"
                checked={preferences.renderMarkdown}
                onCheckedChange={(value) =>
                  setPreferences((pref) => ({ ...pref, renderMarkdown: value }))
                }
              />
            </div>
          </section>

          <Separator className="my-6" />
          <section className="flex justify-between items-center gap-2">
            <div className="space-y-1.5">
              <CardTitle>重复欢迎动画</CardTitle>
              <CardDescription>是否重复播放首页文本输入动画</CardDescription>
            </div>

            <div className="shrink-0 grow-0">
              <Switch
                id="repeatTypingAnimation"
                name=""
                checked={preferences.repeatTypingAnimation}
                onCheckedChange={(value) =>
                  setPreferences((pref) => ({ ...pref, repeatTypingAnimation: value }))
                }
              />
            </div>
          </section>

          <Separator className="my-6" />
          <section className="flex justify-between items-center gap-2">
            <div className="space-y-1.5">
              <CardTitle>清除缓存</CardTitle>
              <CardDescription>清除页面缓存</CardDescription>
            </div>

            <div className="shrink-0 grow-0">
              <Button
                onClick={async () => {
                  const root = await navigator.storage.getDirectory()
                  root.removeEntry("sarasa-ui-sc-regular.ttf")
                  alert("清理成功！")
                }}
              >
                清除
              </Button>
            </div>
          </section>
        </CardContent>
      </Card>
    </>
  )
}
