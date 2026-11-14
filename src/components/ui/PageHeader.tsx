import React from "react"

export interface PageHeaderProps {
  title: string
  eyebrow?: string
  action?: React.ReactNode
}

export function PageHeader({ title, eyebrow, action }: PageHeaderProps) {
  return (
    <div className="page-header">
      <div>
        {eyebrow && <div className="eyebrow">{eyebrow}</div>}
        <h1>{title}</h1>
      </div>
      {action}
    </div>
  )
}
