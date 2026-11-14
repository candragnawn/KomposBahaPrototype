import React from "react"
import { IconName } from "../../types"
import { Icon } from "../ui/Icon"

export interface MobileShellProps {
  role: "warga" | "driver"
  active: string
  setActive: (v: string) => void
  onExit: () => void
  children: React.ReactNode
}

export function MobileShell({
  role,
  active,
  setActive,
  onExit,
  children,
}: MobileShellProps) {
  const tabs =
    role === "warga"
      ? [
          { id: "home", label: "Beranda", icon: "home" as IconName },
          { id: "rewards", label: "Hadiah", icon: "gift" as IconName },
          { id: "offer", label: "Setor", icon: "plus" as IconName },
          { id: "history", label: "Riwayat", icon: "history" as IconName },
        ]
      : [
          { id: "tasks", label: "Tugas", icon: "truck" as IconName },
          { id: "history", label: "Riwayat", icon: "history" as IconName },
          { id: "profile", label: "Profil", icon: "user" as IconName },
        ]

  return (
    <main className={`prototype-stage mobile-stage ${role}-stage`}>
      <div className={`mobile-frame ${role}-frame`}>
        <div className="mobile-content">{children}</div>
        <nav className={`bottom-nav ${role === "warga" ? "warga-nav" : ""}`}>
          {tabs.map((tab) => (
            <button
              key={tab.id}
              className={`${active === tab.id ? "active" : ""}${
                tab.id === "offer" ? " center-action" : ""
              }`}
              onClick={() => setActive(tab.id)}
            >
              <span className="nav-icon">
                <Icon name={tab.icon} />
              </span>
              <span>{tab.label}</span>
            </button>
          ))}
        </nav>
        <button className="role-exit" onClick={onExit} aria-label="Ganti peran">
          <Icon name="logout" size={17} />
        </button>
      </div>
    </main>
  )
}
