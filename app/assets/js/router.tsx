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
import { Preference } from "@/pages/preference/page"
import { Root } from "@/pages/root"

const router = createBrowserRouter(
  createRoutesFromElements(
    <Route path="/" element={<Root />}>
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

      <Route path="preferences" element={<Preference />} />
    </Route>
  )
)

export const Router = () => {
  return <RouterProvider router={router} />
}
