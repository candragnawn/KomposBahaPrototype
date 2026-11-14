import { useState } from "react"
import { STAGE_STATUS } from "../../constants/status"
import { OfferStage, LedgerItem } from "../../types"
import { Badge } from "../../components/ui/Badge"

export interface WargaHistoryProps {
  stage: OfferStage
  ledger?: LedgerItem[]
  onSelectOrder: (code: string) => void
}

export function WargaHistory({
  stage,
  ledger,
  onSelectOrder,
}: WargaHistoryProps) {
  const [historyTab, setHistoryTab] = useState<"setoran" | "poin">("setoran")

  const latest = [
    {
      code: "KB-0412",
      date: "18 Okt 2026",
      kg: "12 kg",
      status: stage === "none" ? "Driver ditugaskan" : STAGE_STATUS[stage],
    },
    {
      code: "KB-0409",
      date: "14 Okt 2026",
      kg: "8 kg",
      status: "Poin diberikan",
    },
    { code: "KB-0405", date: "9 Okt 2026", kg: "10 kg", status: "Ditolak TPS" },
    { code: "KB-0401", date: "2 Okt 2026", kg: "9 kg", status: "Gagal jemput" },
    { code: "KB-0398", date: "25 Sep 2026", kg: "11 kg", status: "Dibatalkan" },
  ]

  const defaultLedger: LedgerItem[] = ledger || [
    {
      date: "14 Okt",
      description: "Setoran KB-0409",
      points: "+82",
      balanceAfter: "1.240",
    },
    {
      date: "10 Okt",
      description: "Tukar Bibit cabai",
      points: "−200",
      balanceAfter: "1.158",
    },
    {
      date: "3 Okt",
      description: "Setoran KB-0400",
      points: "+95",
      balanceAfter: "1.358",
    },
  ]

  return (
    <div className="screen history-screen">
      <header className="page-title">
        <div>
          <span>Aktivitas Anda</span>
          <h1>Riwayat</h1>
        </div>
      </header>

      <div className="tabs">
        <button
          type="button"
          className={historyTab === "setoran" ? "active" : ""}
          onClick={() => setHistoryTab("setoran")}
        >
          Setoran
        </button>
        <button
          type="button"
          className={historyTab === "poin" ? "active" : ""}
          onClick={() => setHistoryTab("poin")}
        >
          Mutasi poin
        </button>
      </div>

      {historyTab === "setoran" ? (
        <div className="list history-list">
          {latest.map((item) => (
            <button
              type="button"
              className="list-item"
              key={item.code}
              onClick={() => onSelectOrder(item.code)}
            >
              <div>
                <strong>{item.code}</strong>
                <small>
                  {item.date} · {item.kg}
                </small>
              </div>
              <Badge>{item.status}</Badge>
            </button>
          ))}
        </div>
      ) : (
        <div className="ledger">
          {defaultLedger.map((r, i) => (
            <div className="ledger-row" key={`${r.date}-${r.description}-${i}`}>
              <span>{r.date}</span>
              <div>
                <strong>{r.description}</strong>
                <small>Saldo setelah {r.balanceAfter}</small>
              </div>
              <b className={r.points.startsWith("+") ? "positive" : "negative"}>
                {r.points}
              </b>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
