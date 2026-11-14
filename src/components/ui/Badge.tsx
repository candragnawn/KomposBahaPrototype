import { STATUS_COLORS } from "../../constants/status"

export interface BadgeProps {
  children: string
  className?: string
}

export function Badge({ children, className = "" }: BadgeProps) {
  const colorClass = STATUS_COLORS[children] || "draft"
  return (
    <span className={`badge badge-${colorClass} ${className}`.trim()}>
      {children}
    </span>
  )
}
