import { useState } from "react"
import { STAGE_STATUS } from "../../constants/status"
import { OfferStage } from "../../types"
import { Badge } from "../../components/ui/Badge"
import { Button } from "../../components/ui/Button"
import { Field } from "../../components/ui/Field"
import { Icon } from "../../components/ui/Icon"
import { SelectField } from "../../components/ui/SelectField"
import { StatusTimeline } from "../../components/ui/StatusTimeline"

export interface WargaOfferProps {
  stage: OfferStage
  setStage: (stage: OfferStage) => void
  detail: boolean
  setDetail: (detail: boolean) => void
  onBackToHome: () => void
  onOfferSubmitted?: (code: string) => void
}

export function WargaOffer({
  stage,
  setStage,
  detail,
  setDetail,
  onBackToHome,
  onOfferSubmitted,
}: WargaOfferProps) {
  const [photo, setPhoto] = useState(false)
  const [formError, setFormError] = useState("")
  const [loading, setLoading] = useState(false)
  const [offerSuccess, setOfferSuccess] = useState(false)
  const [generatedCode, setGeneratedCode] = useState("KB-0412")

  const submitOffer = () => {
    if (!photo) {
      setFormError("Foto kompos wajib ditambahkan.")
      return
    }
    setFormError("")
    setLoading(true)
    window.setTimeout(() => {
      setLoading(false)
      setStage("waiting")
      setOfferSuccess(true)
      const code = `KB-${Math.floor(1000 + Math.random() * 9000)}`
      setGeneratedCode(code)
      onOfferSubmitted?.(code)
    }, 700)
  }

  if (detail) {
    return (
      <div className="screen detail-screen">
        <header className="page-title">
          <button
            type="button"
            onClick={() => setDetail(false)}
            aria-label="Kembali"
          >
            ←
          </button>
          <div>
            <span>Detail pesanan</span>
            <h1>{generatedCode}</h1>
          </div>
          <Badge>
            {stage === "none" ? "Poin diberikan" : STAGE_STATUS[stage]}
          </Badge>
        </header>

        <section className="timeline-card">
          <StatusTimeline stage={stage === "none" ? "verified" : stage} />
          <div className="timeline-date">14 Okt 2026 · 15.42 WITA</div>
        </section>

        <section className="driver-card">
          <div className="avatar">KD</div>
          <div>
            <small>Driver</small>
            <strong>Kadek Dwi Arta</strong>
          </div>
          <button type="button" aria-label="Telepon driver">
            <Icon name="phone" />
          </button>
        </section>

        <section className="result-card mint-result">
          <h2>Hasil verifikasi TPS 3R</h2>
          <dl>
            <div>
              <dt>Berat resmi</dt>
              <dd>8,2 kg</dd>
            </div>
            <div>
              <dt>Kualitas</dt>
              <dd>Baik</dd>
            </div>
            <div>
              <dt>Poin diperoleh</dt>
              <dd>+82 poin</dd>
            </div>
          </dl>
          <div className="photo-proof">
            <Icon name="camera" />
            <span>Foto bukti penimbangan</span>
          </div>
        </section>

        {(stage === "waiting" || stage === "assigned") && (
          <Button
            variant="danger"
            wide
            onClick={() => {
              setStage("none")
              setDetail(false)
            }}
          >
            Batalkan penawaran
          </Button>
        )}
      </div>
    )
  }

  return (
    <div className="screen offer-screen">
      <header className="page-title">
        <button
          type="button"
          onClick={onBackToHome}
          aria-label="Kembali ke beranda"
        >
          ←
        </button>
        <div>
          <span>Setor kompos</span>
          <h1>Buat penawaran</h1>
        </div>
      </header>

      <div className="notice">
        Poin diberikan setelah berat dan kualitas disahkan TPS 3R.
      </div>

      <div className="form-stack">
        <Field
          label="Estimasi berat (kg)"
          defaultValue="12"
          helper="Berat resmi ditentukan saat penimbangan"
        />
        <div className="field">
          <span>Foto kompos</span>
          <button
            type="button"
            className={`upload-box ${formError ? "has-error" : ""}`}
            onClick={() => {
              setPhoto(true)
              setFormError("")
            }}
          >
            <Icon name={photo ? "check" : "camera"} />
            {photo
              ? "Foto kompos-sudarta.jpg ditambahkan"
              : "Tambahkan foto kompos"}
          </button>
          {formError && <small className="error">{formError}</small>}
        </div>

        <Field
          label="Alamat penjemputan"
          defaultValue="Jl. Baha No. 18, Banjar Baha Kelod"
        />

        <div className="map-box">
          <Icon name="map" />
          <span>Lokasi penjemputan</span>
          <small>Banjar Baha Kelod, Mengwi</small>
        </div>

        <div className="field-row">
          <Field label="Tanggal siap" type="date" defaultValue="2026-10-18" />
          <SelectField label="Jam siap" defaultValue="08.00–10.00">
            <option>08.00–10.00</option>
            <option>10.00–12.00</option>
          </SelectField>
        </div>

        <label className="field">
          <span>Catatan</span>
          <textarea defaultValue="Kompos disimpan di karung putih dekat pintu samping." />
        </label>

        <Button variant="primary" wide onClick={submitOffer} disabled={loading}>
          {loading ? "Mengirim penawaran..." : "Kirim penawaran"}
        </Button>
      </div>

      {offerSuccess && (
        <div className="modal-backdrop bottom">
          <div className="success-sheet">
            <span className="success-icon">
              <Icon name="check" size={28} />
            </span>
            <h2>Penawaran terkirim</h2>
            <p>Kode penawaran Anda</p>
            <strong className="success-code">{generatedCode}</strong>
            <Button
              variant="primary"
              wide
              onClick={() => {
                setOfferSuccess(false)
                setDetail(true)
              }}
            >
              Lihat status
            </Button>
          </div>
        </div>
      )}
    </div>
  )
}
