import { useState } from "react"
import { GiftBox } from "../../components/Illustrations3D"
import { Button } from "../../components/ui/Button"
import { Icon } from "../../components/ui/Icon"
import { PageHeader } from "../../components/ui/PageHeader"
import { RewardItem } from "../../types"

export interface WargaRewardsProps {
  points: number
  setPoints: (points: number | ((prev: number) => number)) => void
  rewards?: RewardItem[]
  onFinish?: () => void
}

export function WargaRewards({
  points,
  setPoints,
  rewards: initialRewards,
  onFinish,
}: WargaRewardsProps) {
  const [selectedReward, setSelectedReward] = useState<string | null>(null)
  const [confirm, setConfirm] = useState(false)
  const [redeemState, setRedeemState] =
    useState<"idle" | "loading" | "success" | "error">("idle")

  const rewards: RewardItem[] = initialRewards || [
    { name: "Bibit cabai", price: 200, stock: 12, tone: "green" },
    { name: "Polybag 10 pcs", price: 150, stock: 8, tone: "amber" },
    { name: "Beras 5 kg", price: 600, stock: 5, tone: "cream" },
    { name: "Kopi Baha 250 g", price: 350, stock: 0, tone: "coffee" },
  ]

  const redeem = () => {
    const item = rewards.find((r) => r.name === selectedReward)
    if (!item) return

    if (item.price > points) {
      setRedeemState("error")
      setConfirm(false)
      return
    }

    setRedeemState("loading")
    setConfirm(false)
    window.setTimeout(() => {
      setPoints((prev) => prev - item.price)
      setRedeemState("success")
    }, 700)
  }

  if (redeemState === "success") {
    return (
      <div className="screen success-screen">
        <div className="success-icon">
          <Icon name="check" size={32} />
        </div>
        <div className="eyebrow">Penukaran berhasil</div>
        <h1>Hadiah siap diambil</h1>
        <p>Tunjukkan kode ini kepada petugas Kantor Desa Baha.</p>
        <div className="redeem-code">
          <span>Kode penukaran</span>
          <strong>TKR-7F3A</strong>
        </div>
        <Button
          variant="primary"
          wide
          onClick={() => {
            setSelectedReward(null)
            setRedeemState("idle")
            onFinish?.()
          }}
        >
          Selesai
        </Button>
      </div>
    )
  }

  if (selectedReward) {
    const item = rewards.find((r) => r.name === selectedReward) || rewards[0]
    return (
      <div className="screen reward-detail">
        <button
          type="button"
          className="back-link"
          onClick={() => {
            setSelectedReward(null)
            setRedeemState("idle")
          }}
        >
          ← Katalog hadiah
        </button>
        <div className="reward-image large">
          <GiftBox />
        </div>
        <PageHeader title={item.name} />
        <div className="reward-price">
          {item.price.toLocaleString("id-ID")} poin
        </div>
        <section className="section">
          <h2>Syarat penukaran</h2>
          <ul className="requirements">
            <li>Hadiah diambil di Kantor Desa Baha.</li>
            <li>Tunjukkan kode penukaran dan KTP.</li>
            <li>Kode berlaku selama 7 hari.</li>
          </ul>
        </section>
        {item.stock === 0 && (
          <div className="error-box">
            <strong>Stok habis</strong>
            <span>
              Hadiah ini akan tersedia kembali setelah stok diperbarui.
            </span>
          </div>
        )}
        {redeemState === "error" && (
          <div className="error-box">
            <strong>Poin tidak cukup</strong>
          </div>
        )}
        <Button
          variant="primary"
          wide
          disabled={item.stock === 0}
          onClick={() => setConfirm(true)}
        >
          Tukar poin
        </Button>

        {confirm && (
          <div className="modal-backdrop">
            <div className="dialog" role="dialog">
              <h2>Konfirmasi penukaran</h2>
              <dl>
                <div>
                  <dt>Saldo sebelum</dt>
                  <dd>{points.toLocaleString("id-ID")}</dd>
                </div>
                <div>
                  <dt>Saldo sesudah</dt>
                  <dd>{(points - item.price).toLocaleString("id-ID")}</dd>
                </div>
              </dl>
              <div className="dialog-actions">
                <Button onClick={() => setConfirm(false)}>Kembali</Button>
                <Button variant="primary" onClick={redeem}>
                  Konfirmasi
                </Button>
              </div>
            </div>
          </div>
        )}

        {redeemState === "loading" && (
          <div className="loading-bar">Memproses penukaran...</div>
        )}
      </div>
    )
  }

  return (
    <div className="screen rewards-screen">
      <header className="page-title">
        <div>
          <span>Katalog warga</span>
          <h1>Hadiah</h1>
        </div>
        <span className="points-pill">
          <Icon name="leaf" size={15} />
          {points.toLocaleString("id-ID")} poin
        </span>
      </header>
      <div className="reward-grid">
        {rewards.map((item) => (
          <button
            type="button"
            className="reward-card"
            key={item.name}
            onClick={() => setSelectedReward(item.name)}
          >
            <div>
              <strong>{item.name}</strong>
              <span>{item.price.toLocaleString("id-ID")} poin</span>
              <small>{item.stock ? `Stok ${item.stock}` : "Stok habis"}</small>
            </div>
            <div className="reward-image">
              <GiftBox />
            </div>
          </button>
        ))}
      </div>
    </div>
  )
}
