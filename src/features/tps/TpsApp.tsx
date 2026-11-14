import React, { useState } from "react"
import { OfferStage } from "../../types"
import { DesktopShell } from "../../components/layout/DesktopShell"
import { TpsIncoming } from "./TpsIncoming"
import { TpsAssign } from "./TpsAssign"
import { TpsSuppliers } from "./TpsSuppliers"
import { TpsQuota } from "./TpsQuota"

export interface TpsAppProps {
  stage: OfferStage
  setStage: (s: OfferStage) => void
  setPoints: (n: number | ((prev: number) => number)) => void
  onExit: () => void
}

export function TpsApp({ stage, setStage, setPoints, onExit }: TpsAppProps) {
  const [active, setActive] = useState<string>("incoming")

  let content: React.ReactNode
  if (active === "incoming") {
    content = (
      <TpsIncoming stage={stage} setStage={setStage} setPoints={setPoints} />
    )
  } else if (active === "assign") {
    content = <TpsAssign setStage={setStage} />
  } else if (active === "suppliers") {
    content = <TpsSuppliers />
  } else {
    content = <TpsQuota />
  }

  return (
    <DesktopShell
      role="tps"
      active={active}
      setActive={setActive}
      onExit={onExit}
    >
      {content}
    </DesktopShell>
  )
}
