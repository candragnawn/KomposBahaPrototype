import { Badge } from "../../components/ui/Badge"
import { PageHeader } from "../../components/ui/PageHeader"

export function DriverHistory() {
  const historyItems = [
    "Ni Made Suriati|18 Okt 2026|12 kg",
    "I Ketut Merta|17 Okt 2026|16 kg",
    "Putu Eka Pramana|15 Okt 2026|11 kg",
    "Ni Nyoman Rai|12 Okt 2026|14 kg",
  ]

  return (
    <div className="screen">
      <PageHeader title="Riwayat tugas" />
      <div className="balance-inline">
        <span>Total minggu ini</span>
        <strong>74 kg</strong>
      </div>
      <div className="list">
        {historyItems.map((x) => {
          const [name, date, kg] = x.split("|")
          return (
            <div className="list-item" key={name}>
              <div>
                <strong>{name}</strong>
                <small>
                  {date} · {kg}
                </small>
              </div>
              <Badge>Poin diberikan</Badge>
            </div>
          )
        })}
      </div>
    </div>
  )
}
