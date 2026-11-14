import React from "react"
import { IconName } from "../../types"
import { Icon } from "../ui/Icon"

export interface DesktopShellProps {
  role: "tps" | "admin"
  active: string
  setActive: (v: string) => void
  onExit: () => void
  children: React.ReactNode
}

export function DesktopShell({
  role,
  active,
  setActive,
  onExit,
  children,
}: DesktopShellProps) {
  const tpsLinks: { id: string; label: string; icon: IconName }[] = [
    { id: "incoming", label: "Kompos masuk", icon: "box" },
    { id: "assign", label: "Penugasan driver", icon: "truck" },
    { id: "suppliers", label: "Rekap pemasok", icon: "users" },
    { id: "quota", label: "Pengaturan kuota", icon: "settings" },
  ];

  const adminLinks: { id: string; label: string; icon: IconName }[] = [
    { id: "summary", label: "Ringkasan", icon: "home" },
    { id: "transactions", label: "Transaksi", icon: "history" },
    { id: "users", label: "Pengguna", icon: "users" },
    { id: "points", label: "Poin dan hadiah", icon: "gift" },
    { id: "complaints", label: "Pengaduan", icon: "message" },
    { id: "reports", label: "Laporan", icon: "file" },
  ]

  const links = role === "tps" ? tpsLinks : adminLinks

  return (
    <main className="desktop-app">
      <aside className="sidebar">
        <div className="desktop-brand">
          <span className="brand-mark small">KB</span>
          <div>
            <strong>Kompos Baha</strong>
            <small>
              {role === "tps" ? "TPS 3R Desa Baha" : "Admin Desa Baha"}
            </small>
          </div>
        </div>
        <nav>
          {links.map((l) => (
            <button
              key={l.id}
              className={active === l.id ? "active" : ""}
              onClick={() => setActive(l.id)}
            >
              <Icon name={l.icon} />
              <span>{l.label}</span>
            </button>
          ))}
        </nav>
        <button className="sidebar-exit" onClick={onExit}>
          <Icon name="logout" />
          <span>Ganti peran</span>
        </button>
      </aside>
      <div className="desktop-main">
        <header className="topbar">
          <span>Desa Baha, Mengwi</span>
          <div className="topbar-user">
            <span>
              {role === "tps" ? "I Made Sutama" : "Ni Luh Sri Wahyuni"}
              <small>
                {role === "tps" ? "Petugas TPS 3R" : "Administrator"}
              </small>
            </span>
            <div className="avatar small">{role === "tps" ? "MS" : "SW"}</div>
          </div>
        </header>
        <div className="desktop-content">{children}</div>
      </div>
    </main>
  )
}
