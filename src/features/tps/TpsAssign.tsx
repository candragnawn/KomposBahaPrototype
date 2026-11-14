import { useState } from "react"
import { OfferStage } from "../../types"
import { Button } from "../../components/ui/Button"
import { PageHeader } from "../../components/ui/PageHeader"

export interface TpsAssignProps {
  setStage: (stage: OfferStage) => void
}

export function TpsAssign({ setStage }: TpsAssignProps) {
  const [assigned, setAssigned] = useState(false)

  const unassignedOffers = [
    ["KB-0415", "Ni Kadek Sari", "Baha Kaja · 15 kg"],
    ["KB-0414", "Ni Made Suriati", "Baha Kelod · 11 kg"],
    ["KB-0413", "I Ketut Sudarma", "Baha Kaja · 9 kg"],
  ]

  const activeDrivers = [
    ["Kadek Dwi Arta", "3 tugas", "Siap"],
    ["I Ketut Budi", "1 tugas", "Siap"],
    ["I Gede Arta", "0 tugas", "Siap"],
  ]

  return (
    <>
      <PageHeader eyebrow="Operasional" title="Penugasan driver" />
      <div className="assignment-grid">
        <section>
          <div className="section-heading">
            <h2>Belum ditugaskan</h2>
            <span>3 penawaran</span>
          </div>
          {unassignedOffers.map((o, i) => (
            <div className="assignment-card" key={o[0]}>
              <div>
                <strong>
                  {o[0]} · {o[1]}
                </strong>
                <span>{o[2]}</span>
              </div>
              <Button
                variant={i === 0 && assigned ? "secondary" : "primary"}
                disabled={i === 0 && assigned}
                onClick={() => {
                  if (i === 0) {
                    setAssigned(true)
                    setStage("assigned")
                  }
                }}
              >
                {i === 0 && assigned ? "Ditugaskan" : "Tugaskan"}
              </Button>
            </div>
          ))}
        </section>

        <section>
          <div className="section-heading">
            <h2>Driver aktif</h2>
            <span>3 tersedia</span>
          </div>
          {activeDrivers.map((d) => (
            <div className="driver-row" key={d[0]}>
              <div className="avatar small">
                {d[0]
                  .split(" ")
                  .slice(-2)
                  .map((x) => x[0])
                  .join("")}
              </div>
              <div>
                <strong>{d[0]}</strong>
                <span>{d[1]} hari ini</span>
              </div>
              <span className="availability-label">{d[2]}</span>
            </div>
          ))}
        </section>
      </div>
    </>
  )
}
