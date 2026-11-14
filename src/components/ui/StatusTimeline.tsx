import { OfferStage } from "../../types"
import { Icon } from "./Icon"

export interface StatusTimelineProps {
  stage: OfferStage
  customTimes?: string[]
}

export function StatusTimeline({ stage, customTimes }: StatusTimelineProps) {
  const steps = [
    "Menunggu konfirmasi",
    "Driver ditugaskan",
    "Dalam penjemputan",
    "Diterima TPS 3R",
    "Poin diberikan",
  ]
  const order: OfferStage[] = [
    "waiting",
    "assigned",
    "pickup",
    "delivered",
    "verified",
  ]
  const current = stage === "collected" ? 2 : order.indexOf(stage)
  const times = customTimes || [
    "14 Okt · 08.10",
    "14 Okt · 08.35",
    "14 Okt · 10.02",
    "14 Okt · 11.18",
    "14 Okt · 15.42",
  ]

  return (
    <div className="timeline">
      {steps.map((step, i) => (
        <div
          className={`timeline-row ${
            i < current ? "done" : i === current ? "current" : ""
          }`}
          key={step}
        >
          <span className="timeline-marker">
            {i <= current && <Icon name="check" size={12} />}
          </span>
          <div>
            <strong>{step}</strong>
            <small>{i <= current ? times[i] : "Menunggu"}</small>
          </div>
        </div>
      ))}
    </div>
  )
}
