export const csrfToken =
  document.querySelector<HTMLMetaElement>("meta[name='csrf-token']")?.getAttribute("content") ?? ""

export const vapidPublicKey =
  document
    .querySelector<HTMLMetaElement>("meta[name='vapid-public-key']")
    ?.getAttribute("content") ?? ""
