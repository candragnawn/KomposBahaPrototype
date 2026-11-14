import React, { useState } from "react"
import { OfferStage } from "../../types"
import { MobileShell } from "../../components/layout/MobileShell"
import { DriverTasks } from "./DriverTasks"
import { DriverDetail } from "./DriverDetail"
import { DriverHistory } from "./DriverHistory"
import { DriverProfile } from "./DriverProfile"

export interface DriverAppProps {
  stage: OfferStage
  setStage: (s: OfferStage) => void
  onExit: () => void
}

export function DriverApp({ stage, setStage, onExit }: DriverAppProps) {
  const [active, setActive] = useState<string>("tasks")
  const [detail, setDetail] = useState(false)

  let content: React.ReactNode
  if (active === "tasks" && detail) {
    content = (
      <DriverDetail
        stage={stage}
        setStage={setStage}
        onBack={() => setDetail(false)}
      />
    )
  } else if (active === "tasks") {
    content = <DriverTasks onSelectTask={() => setDetail(true)} />
  } else if (active === "history") {
    content = <DriverHistory />
  } else {
    content = <DriverProfile />
  }

  return (
    <MobileShell
      role="driver"
      active={active}
      setActive={(v) => {
        setActive(v)
        setDetail(false)
      }}
      onExit={onExit}
    >
      {content}
    </MobileShell>
  )
}
