import "css-doodle"
import React from "react"

declare global {
  namespace JSX {
    interface IntrinsicElements {
      "css-doodle": {
        class?: string
        children?: string
      }
    }
  }
}

export const CSSDoodle: React.FC<{ className?: string; rule?: string }> = ({ className, rule }) => {
  return <css-doodle class={className}>{rule}</css-doodle>
}
