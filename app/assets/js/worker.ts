const setupFonts = async () => {
  const root = await navigator.storage.getDirectory()
  try {
    await root.getFileHandle("sarasa-ui-sc-regular.ttf")
  } catch (e) {
    const file = await root.getFileHandle("sarasa-ui-sc-regular.ttf", { create: true })
    const writer = await file.createWritable()

    const font = await fetch("/fonts/sarasa-ui-sc-regular.ttf").then((res) => res.blob())
    await writer.write(font)
    await writer.close()
  }
}

setupFonts()
