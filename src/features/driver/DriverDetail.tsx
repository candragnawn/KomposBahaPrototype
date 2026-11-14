import { useState } from "react"
import { STAGE_STATUS } from "../../constants/status"
import { OfferStage } from "../../types"
import { Badge } from "../../components/ui/Badge"
import { Button } from "../../components/ui/Button"
import { Icon } from "../../components/ui/Icon"
import { PageHeader } from "../../components/ui/PageHeader"
import { SelectField } from "../../components/ui/SelectField"

export interface DriverDetailProps {
  stage: OfferStage
  setStage: (stage: OfferStage) => void
  onBack: () => void
}

export function DriverDetail({ stage, setStage, onBack }: DriverDetailProps) {
  const [pickupPhoto, setPickupPhoto] = useState(false)
  const [failDialog, setFailDialog] = useState(false)
  const [failed, setFailed] = useState(false)
  const [failReason, setFailReason] = useState("Warga tidak di tempat")

  return (
    <div className="screen">
      <button type="button" className="back-link" onClick={onBack}>
        ← Daftar tugas
      </button>

      <PageHeader eyebrow="KB-0412" title="Detail penjemputan" />
      <Badge>{failed ? "Gagal jemput" : STAGE_STATUS[stage]}</Badge>

      <section className="info-card address">
        <span>Alamat</span>
        <strong>Ni Luh Ayu Wulandari</strong>
        <p>Jl. Baha No. 7, Banjar Baha Kelod</p>
        <Button icon="phone">Hubungi warga</Button>
      </section>

      <div className="map-box tall">
        <Icon name="map" />
        <span>Rute menuju lokasi</span>
        <small>1,8 km · sekitar 7 menit</small>
      </div>

      <section className="detail-grid">
        <div>
          <span>Estimasi</span>
          <strong>12 kg</strong>
        </div>
        <div>
          <span>Waktu</span>
          <strong>08.00–10.00</strong>
        </div>
      </section>

      <section className="info-card">
        <span>Catatan warga</span>
        <p>Kompos disimpan di karung putih dekat pintu samping.</p>
        <div className="resident-photo">
          <Icon name="camera" />
          <span>Foto dari warga</span>
        </div>
      </section>

      {stage === "assigned" && (
        <Button variant="primary" wide onClick={() => setStage("pickup")}>
          Mulai jemput
        </Button>
      )}

      {stage === "pickup" && (
        <>
          <button
            type="button"
            className="upload-box"
            onClick={() => setPickupPhoto(true)}
          >
            <Icon name={pickupPhoto ? "check" : "camera"} />
            {pickupPhoto
              ? "Foto pengambilan ditambahkan"
              : "Tambah foto pengambilan (wajib)"}
          </button>
          <Button
            variant="primary"
            wide
            disabled={!pickupPhoto}
            onClick={() => setStage("collected")}
          >
            Konfirmasi sudah diambil
          </Button>
        </>
      )}

      {stage === "collected" && (
        <>
          <div className="notice success">
            Kompos sudah diambil. Antar ke TPS 3R Desa Baha.
          </div>
          <Button
            variant="primary"
            wide
            onClick={() => {
              setStage("delivered")
              onBack()
            }}
          >
            Konfirmasi sudah diantar ke TPS 3R
          </Button>
        </>
      )}

      <Button variant="danger" wide onClick={() => setFailDialog(true)}>
        Gagal jemput
      </Button>

      {failDialog && (
        <div className="modal-backdrop">
          <div className="dialog">
            <h2>Laporkan gagal jemput</h2>
            <SelectField
              label="Alasan"
              value={failReason}
              onChange={setFailReason}
            >
              <option>Warga tidak di tempat</option>
              <option>Kompos tidak sesuai</option>
              <option>Alamat tidak ditemukan</option>
              <option>Lainnya</option>
            </SelectField>
            <div className="dialog-actions">
              <Button onClick={() => setFailDialog(false)}>Kembali</Button>
              <Button
                variant="danger"
                onClick={() => {
                  setFailed(true)
                  setFailDialog(false)
                }}
              >
                Simpan laporan
              </Button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
