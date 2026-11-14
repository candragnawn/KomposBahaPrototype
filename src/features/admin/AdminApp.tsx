import React, { useState } from "react"
import { DesktopShell } from "../../components/layout/DesktopShell"
import { AdminSummary } from "./AdminSummary"
import { AdminTransactions } from "./AdminTransactions"
import { AdminUsers } from "./AdminUsers"
import { AdminPoints } from "./AdminPoints"
import { AdminComplaints } from "./AdminComplaints"
import { AdminReports } from "./AdminReports"

export interface AdminAppProps {
  onExit: () => void
}

export function AdminApp({ onExit }: AdminAppProps) {
  const [active, setActive] = useState<string>("summary")

  let content: React.ReactNode
  if (active === "summary") {
    content = (
      <AdminSummary
        onNavigateToTransactions={() => setActive("transactions")}
      />
    )
  } else if (active === "transactions") {
    content = <AdminTransactions />
  } else if (active === "users") {
    content = <AdminUsers />
  } else if (active === "points") {
    content = <AdminPoints />
  } else if (active === "complaints") {
    content = <AdminComplaints />
  } else {
    content = <AdminReports />
  }

  return (
    <DesktopShell
      role="admin"
      active={active}
      setActive={setActive}
      onExit={onExit}
    >
      {content}
    </DesktopShell>
  )
}
