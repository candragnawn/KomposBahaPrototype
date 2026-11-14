import { useState } from "react"
import {
  CompostBin,
  GiftBox,
  LedgerCoin,
  PickupTruck,
} from "../../components/Illustrations3D"
import { Badge } from "../../components/ui/Badge"
import { Button } from "../../components/ui/Button"
import { Icon } from "../../components/ui/Icon"

export interface WargaHomeProps {
  points: number
  onNavigate: (tab: string) => void
  onOpenDetail: () => void
}

export function WargaHome({
  points,
  onNavigate,
  onOpenDetail,
}: WargaHomeProps) {
  const [homePickupState] = useState<"ready" | "empty" | "loading">("ready")

  return (
    <>
      <header className="home-flex-header">
        <div className="system-status">
          <strong>9:41</strong>
          <svg
            width="68"
            height="16"
            viewBox="0 0 68 16"
            fill="none"
            aria-label="Sinyal, Wi-Fi, dan baterai"
          >
            <path
              d="M1 13h3V9H1v4Zm5 0h3V6H6v7Zm5 0h3V3h-3v10Z"
              fill="currentColor"
            />
            <path
              d="M22 6.5c4-4 10-4 14 0M25 9.5c2.5-2.4 5.5-2.4 8 0M29 13h.1"
              stroke="currentColor"
              strokeWidth="1.5"
              strokeLinecap="round"
            />
            <rect
              x="43"
              y="3"
              width="20"
              height="10"
              rx="2"
              stroke="currentColor"
              strokeWidth="1.5"
            />
            <path
              d="M65 6v4"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
            />
            <rect
              x="45.5"
              y="5.5"
              width="14"
              height="5"
              rx="1"
              fill="currentColor"
            />
          </svg>
        </div>
        <div className="home-user-row">
          <div className="avatar">WS</div>
          <div className="home-user-copy">
            <small>Selamat pagi</small>
            <strong>I Wayan Sudarta</strong>
          </div>
          <span className="points-pill">
            <Icon name="leaf" size={16} />
            {points.toLocaleString("id-ID")} poin
          </span>
          <button className="header-icon" aria-label="Notifikasi" type="button">
            <Icon name="bell" size={20} />
          </button>
        </div>
        <section className="home-flex-hero">
          <div>
            <span>Setoran bulan ini</span>
            <strong>
              42,5 <small>kg</small>
            </strong>
            <p>terkirim ke TPS 3R</p>
          </div>
          <span className="hero-art-box">
            <CompostBin />
          </span>
        </section>
      </header>

      <main className="home-flex-content">
        <section className="home-services">
          <h2>Layanan</h2>
          <div className="home-service-grid">
            <button type="button" onClick={() => onNavigate("offer")}>
              <span>
                <CompostBin />
              </span>
              <strong>Setor kompos</strong>
            </button>
            <button type="button" onClick={() => onNavigate("rewards")}>
              <span>
                <GiftBox />
              </span>
              <strong>Tukar hadiah</strong>
            </button>
            <button type="button" onClick={() => onNavigate("history")}>
              <span>
                <LedgerCoin />
              </span>
              <strong>Mutasi poin</strong>
            </button>
          </div>
        </section>

        <section className="home-pickups">
          <div className="home-section-row">
            <h2>Penjemputan aktif</h2>
            <button type="button" onClick={() => onNavigate("history")}>
              Lihat semua
            </button>
          </div>
          {homePickupState === "loading" ? (
            <div className="home-loading" aria-label="Memuat penjemputan">
              <div>
                <i />
                <i />
                <i />
              </div>
              <b />
            </div>
          ) : homePickupState === "empty" ? (
            <div className="home-empty">
              <div>
                <Icon name="truck" size={24} />
                <strong>Belum ada penjemputan</strong>
                <small>Jadwalkan pengambilan kompos dari rumah Anda.</small>
              </div>
              <Button variant="primary" onClick={() => onNavigate("offer")}>
                Setor kompos
              </Button>
            </div>
          ) : (
            <div className="home-pickup-list">
              <button
                type="button"
                className="home-pickup-primary"
                onClick={onOpenDetail}
              >
                <div>
                  <strong>KB-0412 · 12 kg</strong>
                  <span>
                    <Icon name="map" size={14} />
                    Jl. Baha No. 18, Baha Kelod
                  </span>
                  <small>Besok, 08.00-10.00</small>
                  <Badge>Driver ditugaskan</Badge>
                </div>
                <span className="home-truck-box">
                  <PickupTruck />
                </span>
              </button>
              <button
                type="button"
                className="home-pickup-complete"
                onClick={onOpenDetail}
              >
                <div>
                  <strong>KB-0409 · 8 kg</strong>
                  <small>14 Okt 2026</small>
                  <Badge>Poin diberikan</Badge>
                </div>
                <Icon name="check" size={20} />
              </button>
            </div>
          )}
        </section>
      </main>
    </>
  )
}
