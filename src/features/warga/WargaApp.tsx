import { useState } from "react"
import { OfferStage } from "../../types"
import { BottomBar } from "../../components/ui/BottomBar"
import { WargaHome } from "./WargaHome"
import { WargaOffer } from "./WargaOffer"
import { WargaHistory } from "./WargaHistory"
import { WargaRewards } from "./WargaRewards"
import { WargaProfile } from "./WargaProfile"

export interface WargaAppProps {
  stage: OfferStage
  setStage: (s: OfferStage) => void
  points: number
  setPoints: (n: number | ((prev: number) => number)) => void
  onExit: () => void
}

export function WargaApp({
  stage,
  setStage,
  points,
  setPoints,
  onExit,
}: WargaAppProps) {
  const [active, setActive] = useState<string>("home")
  const [detail, setDetail] = useState(false)

  const go = (tab: string) => {
    setActive(tab)
    setDetail(false)
  }

  const selectBottomTab = (key: string) => {
    const target =
      key === "beranda"
        ? "home"
        : key === "hadiah"
          ? "rewards"
          : key === "setor"
            ? "offer"
            : key === "riwayat"
              ? "history"
              : key === "profil"
                ? "profile"
                : null
    if (target) go(target)
  }

  let content: React.ReactNode
  if (active === "home") {
    content = (
      <WargaHome
        points={points}
        onNavigate={go}
        onOpenDetail={() => {
          setActive("offer")
          setDetail(true)
        }}
      />
    )
  } else if (active === "offer") {
    content = (
      <WargaOffer
        stage={stage}
        setStage={setStage}
        detail={detail}
        setDetail={setDetail}
        onBackToHome={() => go("home")}
      />
    )
  } else if (active === "history") {
    content = (
      <WargaHistory
        stage={stage}
        onSelectOrder={() => {
          setActive("offer")
          setDetail(true)
        }}
      />
    )
  } else if (active === "rewards") {
    content = (
      <WargaRewards
        points={points}
        setPoints={setPoints}
        onFinish={() => go("home")}
      />
    )
  } else {
    content = <WargaProfile onExit={onExit} />
  }

  if (active === "home") {
    return (
      <div className="warga-home-root">
        {content}
        <BottomBar active="beranda" onSelect={selectBottomTab} />
      </div>
    )
  }

  const bottomActive =
    active === "rewards"
      ? "hadiah"
      : active === "offer"
        ? "setor"
        : active === "history"
          ? "riwayat"
          : active === "profile"
            ? "profil"
            : "beranda"

  return (
    <div className="warga-flow-root">
      <div className="warga-flow-status" />
      <div className="warga-flow-content">{content}</div>
      <BottomBar active={bottomActive} onSelect={selectBottomTab} />
    </div>
  )
}
