import { useState } from "react"
import { OfferStage, Role } from "./types"
import { StartScreen } from "./features/auth/StartScreen"
import { WargaLogin } from "./features/auth/WargaLogin"
import { WargaApp } from "./features/warga/WargaApp"
import { DriverApp } from "./features/driver/DriverApp"
import { TpsApp } from "./features/tps/TpsApp"
import { AdminApp } from "./features/admin/AdminApp"

export { BottomBar } from "./components/ui/BottomBar"

export default function App() {
  const [role, setRole] = useState<Role | null>(null)
  const [wargaLoggedIn, setWargaLoggedIn] = useState(false)
  const [stage, setStage] = useState<OfferStage>("none")
  const [points, setPoints] = useState(1240)

  if (!role) {
    return <StartScreen onRole={setRole} />
  }

  if (role === "warga" && !wargaLoggedIn) {
    return (
      <WargaLogin
        onLogin={() => setWargaLoggedIn(true)}
        onBack={() => setRole(null)}
      />
    )
  }

  if (role === "warga") {
    return (
      <WargaApp
        stage={stage}
        setStage={setStage}
        points={points}
        setPoints={setPoints}
        onExit={() => setRole(null)}
      />
    )
  }

  if (role === "driver") {
    return (
      <DriverApp
        stage={stage}
        setStage={setStage}
        onExit={() => setRole(null)}
      />
    )
  }

  if (role === "tps") {
    return (
      <TpsApp
        stage={stage}
        setStage={setStage}
        setPoints={setPoints}
        onExit={() => setRole(null)}
      />
    )
  }

  return <AdminApp onExit={() => setRole(null)} />
}
