import { Data } from "@/services"
import { vapidPublicKey } from "@/session"
import { httpClient, queryClient } from "@/utils/client"

export const NotificationService = {
  async getSubscription() {
    const serviceWorker = await navigator.serviceWorker.ready
    let subscription = await serviceWorker.pushManager.getSubscription()
    if (!subscription) {
      subscription = await serviceWorker.pushManager.subscribe({
        applicationServerKey: vapidPublicKey,
        userVisibleOnly: true
      })
    }
    return subscription
  },
  async isSubscribed() {
    const subscription = await NotificationService.getSubscription()
    return httpClient
      .post("/api/notification/subscriptions/current", {
        body: JSON.stringify({ endpoint: subscription.endpoint })
      })
      .json<Data<PushSubscription | null>>()
      .then(({ data }) => data !== null)
  },
  async subscribe() {
    const subscription = await NotificationService.getSubscription()
    return httpClient
      .post("/api/notification/subscriptions/create", {
        body: JSON.stringify({ subscription: subscription })
      })
      .json<Data<PushSubscription>>()
  },
  async cancel() {
    const subscription = await NotificationService.getSubscription()
    return httpClient
      .post("/api/notification/subscriptions/cancel", {
        body: JSON.stringify({ endpoint: subscription.endpoint })
      })
      .json<Data<PushSubscription | null>>()
  },
  queries: {
    isSubscribed: {
      queryKey: ["notification", "subscription"],
      queryFn: () => NotificationService.isSubscribed(),
      refetchOnWindowFocus: false
    }
  },
  mutations: {
    subscribe: {
      mutationFn: () => NotificationService.subscribe(),
      onSettled: () =>
        queryClient.invalidateQueries(NotificationService.queries.isSubscribed.queryKey)
    },
    cancel: {
      mutationFn: () => NotificationService.cancel(),
      onSettled: () =>
        queryClient.invalidateQueries(NotificationService.queries.isSubscribed.queryKey)
    }
  }
}
