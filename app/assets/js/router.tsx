import {
  Route,
  RouterProvider,
  createBrowserRouter,
  createRoutesFromElements,
  redirect
} from "react-router-dom"

import { Empty } from "@/components/shared/empty"

import { ArchiveDetail, archiveDetailLoader } from "@/pages/archive/detail.page"
import { Archive, archiveLoader } from "@/pages/archive/page"
import { Dashboard, dashboardLoder } from "@/pages/dashboard/page"
import { Gallery, galleryLoader } from "@/pages/gallery/page"
import { Preferences, preferencesLoader } from "@/pages/preference/page"
import { Root, rootLoader } from "@/pages/root"
import { Confirm, confirmAction, confirmLoader } from "@/pages/users/confirm.page"
import { Login, loginAction, loginLoader } from "@/pages/users/login.page"
import { Wrapped2023, wrappedLoader } from "@/pages/wrapped/2023/page"

const router = createBrowserRouter(
  createRoutesFromElements(
    <Route path="/" element={<Root />} loader={rootLoader}>
      <Route index loader={() => redirect("/dashboard")} />

      <Route path="dashboard" element={<Dashboard />} loader={dashboardLoder} />

      <Route path="archive" element={<Archive />} loader={archiveLoader} />
      <Route
        path="archive/:id"
        element={<ArchiveDetail />}
        loader={archiveDetailLoader}
        errorElement={<Empty />}
      />

      <Route path="gallery" element={<Gallery />} loader={galleryLoader} errorElement={<Empty />} />

      <Route path="preferences" element={<Preferences />} loader={preferencesLoader} />

      <Route path="wrapped/2023" element={<Wrapped2023 />} loader={wrappedLoader} />

      <Route path="users/login" element={<Login />} loader={loginLoader} action={loginAction} />
      <Route
        path="users/confirm/:token"
        element={<Confirm />}
        loader={confirmLoader}
        action={confirmAction}
        errorElement={<Empty />}
      />
    </Route>
  )
)

export const Router = () => {
  return <RouterProvider router={router} />
}
