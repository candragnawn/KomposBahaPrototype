import React from "react"
import { IconName } from "../../types"
import { Icon } from "./Icon"

export interface ButtonProps {
  children: React.ReactNode
  variant?: "primary" | "secondary" | "danger" | "text"
  icon?: IconName
  onClick?: () => void
  disabled?: boolean
  type?: "button" | "submit"
  wide?: boolean
  className?: string
}

export function Button({
  children,
  variant = "secondary",
  icon,
  onClick,
  disabled,
  type = "button",
  wide = false,
  className = "",
}: ButtonProps) {
  const classes = ["btn", `btn-${variant}`, wide ? "btn-wide" : "", className]
    .filter(Boolean)
    .join(" ")

  return (
    <button
      type={type}
      className={classes}
      onClick={onClick}
      disabled={disabled}
    >
      {icon && <Icon name={icon} size={18} />}
      <span>{children}</span>
    </button>
  )
}
