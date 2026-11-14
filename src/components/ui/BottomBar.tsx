import { Gift, History, Home, Plus, User, LucideIcon } from "lucide-react"

interface BottomTabItem {
  key: string
  label: string
  Icon: LucideIcon
  primary?: boolean
}

const BOTTOM_TABS: BottomTabItem[] = [
  { key: "beranda", label: "Beranda", Icon: Home },
  { key: "hadiah", label: "Hadiah", Icon: Gift },
  { key: "setor", label: "Setor", Icon: Plus, primary: true },
  { key: "riwayat", label: "Riwayat", Icon: History },
  { key: "profil", label: "Profil", Icon: User },
]

export interface BottomBarProps {
  active?: string
  onSelect?: (key: string) => void
}

export function BottomBar({ active = "beranda", onSelect }: BottomBarProps) {
  return (
    <nav
      style={{
        flex: "none",
        width: "100%",
        margin: 0,
        padding: "8px 0 24px",
        background: "linear-gradient(180deg, #0B7A5C, #19B28D)",
        display: "grid",
        gridTemplateColumns: "repeat(5, 1fr)",
        boxSizing: "border-box",
      }}
    >
      {BOTTOM_TABS.map(({ key, label, Icon: TabIcon, primary }) => {
        const isActive = key === active
        return (
          <button
            key={key}
            type="button"
            onClick={() => onSelect?.(key)}
            style={{
              background: "none",
              border: 0,
              padding: 0,
              minWidth: 0,
              display: "flex",
              flexDirection: "column",
              alignItems: "center",
              gap: 4,
              color: "#fff",
              opacity: isActive || primary ? 1 : 0.7,
              cursor: "pointer",
            }}
          >
            <span
              style={{
                width: 40,
                height: 40,
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                borderRadius: primary ? 20 : 0,
                background: primary ? "#fff" : "transparent",
                color: primary ? "#0B7A5C" : "#fff",
              }}
            >
              <TabIcon size={24} strokeWidth={1.75} />
            </span>
            <span
              style={{
                fontSize: 12,
                lineHeight: "16px",
                fontWeight: isActive ? 600 : 400,
                whiteSpace: "nowrap",
              }}
            >
              {label}
            </span>
          </button>
        )
      })}
    </nav>
  )
}
