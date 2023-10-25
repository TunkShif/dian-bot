self.addEventListener("push", (e) => {
  const { message } = e.data.json()
  showNotification(message)
})

const showNotification = (message) => {
  self.registration.showNotification(`${message.sender.nickname} 爆典了`, {
    body: `来自群 ${message.group.name}`,
    icon: message.sender.avatar_url
  })
}
