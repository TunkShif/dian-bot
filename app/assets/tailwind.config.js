// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

module.exports = {
  darkMode: "class",
  content: ["./js/**/*.js", "../lib/*_web.ex", "../lib/*_web/**/*.*ex"],
  theme: {
    extend: {
      typography: (theme) => ({
        DEFAULT: {
          css: {
            blockquote: {
              fontWeight: 400,
              fontStyle: "normal"
            },
            "blockquote p:first-of-type::before": {
              content: ""
            },
            "blockquote p:last-of-type::after": {
              content: ""
            },
            code: {
              paddingLeft: theme("spacing.1"),
              paddingRight: theme("spacing.1"),
              fontWeight: 400,
              borderRadius: theme("borderRadius.sm")
            },
            "code::before": {
              content: ""
            },
            "code::after": {
              content: ""
            },
            pre: {
              borderRadius: theme("borderRadius.md"),
              boxShadow: theme("boxShadow.lg")
            },
            "hr + *": {
              marginTop: "inherit"
            },
            "h2 + *": {
              marginTop: "inherit"
            },
            "h3 + *": {
              marginTop: "inherit"
            },
            "h4 + *": {
              marginTop: "inherit"
            },
            h1: {
              marginTop: 0,
              marginBottom: theme("spacing.2"),
              fontSize: theme("textSize.xl")
            },
            h2: {
              marginTop: 0,
              marginBottom: theme("spacing.1")
            },
            h3: {
              marginTop: 0,
              marginBottom: theme("spacing.1")
            },
            p: {
              marginTop: theme("spacing[0.5]"),
              marginBottom: theme("spacing[0.5]")
            }
          }
        }
      })
    }
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({ addVariant }) =>
      addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])
    ),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function({ matchComponents, theme }) {
      let iconsDir = path.join(__dirname, "./vendor/heroicons/optimized")
      let values = {}
      let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"]
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).map((file) => {
          let name = path.basename(file, ".svg") + suffix
          values[name] = { name, fullPath: path.join(iconsDir, dir, file) }
        })
      })
      matchComponents(
        {
          hero: ({ name, fullPath }) => {
            let content = fs
              .readFileSync(fullPath)
              .toString()
              .replace(/\r?\n|\r/g, "")
            return {
              [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
              "-webkit-mask": `var(--hero-${name})`,
              mask: `var(--hero-${name})`,
              "mask-repeat": "no-repeat",
              "background-color": "currentColor",
              "vertical-align": "middle",
              display: "inline-block",
              width: theme("spacing.5"),
              height: theme("spacing.5")
            }
          }
        },
        { values }
      )
    })
  ]
}
