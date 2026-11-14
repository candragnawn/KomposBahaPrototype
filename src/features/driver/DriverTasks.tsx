import { useState } from "react"
import { PickupTruck } from "../../components/Illustrations3D"
import { Badge } from "../../components/ui/Badge"

export interface DriverTasksProps {
  onSelectTask: (taskName: string) => void
}

export function DriverTasks({ onSelectTask }: DriverTasksProps) {
  const [ready, setReady] = useState(true)

  return (
    <div className="screen driver-tasks">
      <div className="driver-greeting">
        <div>
          <span>Halo,</span>
          <h1>Kadek Dwi Arta</h1>
        </div>
        <button
          type="button"
          className="availability"
          onClick={() => setReady(!ready)}
        >
          <span>
            <strong>Siap menerima tugas</strong>
          </span>
          <span className={`switch ${ready ? "on" : ""}`}>
            <i />
          </span>
        </button>
      </div>

      <section className="driver-summary">
        <div>
          <span>Hari ini</span>
          <strong>3 tugas · 35 kg</strong>
          <small>18 Oktober 2026</small>
        </div>
        <span className="row-art">
          <PickupTruck />
        </span>
      </section>

      <div className="group-label">Banjar Baha Kelod · 08.00–10.00</div>
      <div className="task-list">
        {[
          ["Ni Luh Ayu Wulandari", "Jl. Baha No. 7", "12 kg"],
          ["I Made Sukarta", "Gg. Melati No. 3", "8 kg"],
        ].map((task) => (
          <button
            type="button"
            className="task-card"
            key={task[0]}
            onClick={() => onSelectTask(task[0])}
          >
            <div>
              <strong>{task[0]}</strong>
              <span>{task[1]}</span>
              <small>{task[2]} · 08.00–10.00</small>
            </div>
            <Badge>Driver ditugaskan</Badge>
          </button>
        ))}
      </div>

      <div className="group-label">Banjar Baha Kaja · 10.00–12.00</div>
      <div className="task-list">
        <button
          type="button"
          className="task-card"
          onClick={() => onSelectTask("Ni Kadek Sari")}
        >
          <div>
            <strong>Ni Kadek Sari</strong>
            <span>Jl. Baha Kaja No. 22</span>
            <small>15 kg · 10.00–12.00</small>
          </div>
          <Badge>Driver ditugaskan</Badge>
        </button>
      </div>
    </div>
  )
}
