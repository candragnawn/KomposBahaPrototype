import { useState } from "react"
import { STAGE_STATUS } from "../../constants/status"
import { OfferStage } from "../../types"
import { Badge } from "../../components/ui/Badge"
import { Button } from "../../components/ui/Button"
import { DataTable } from "../../components/ui/DataTable"
import { Field } from "../../components/ui/Field"
import { Icon } from "../../components/ui/Icon"
import { PageHeader } from "../../components/ui/PageHeader"
import { SelectField } from "../../components/ui/SelectField"

const DEFAULT_OFFERS = [
  [
    "KB-0415",
    "Ni Kadek Sari",
    "Baha Kaja",
    "15",
    "Menunggu konfirmasi",
    "18 Okt, 10.00",
  ],
  [
    "KB-0412",
    "Ni Luh Ayu Wulandari",
    "Baha Kelod",
    "12",
    "Driver ditugaskan",
    "18 Okt, 08.00",
  ],
  [
    "KB-0322",
    "I Ketut Merta",
    "Baha Tengah",
    "14–16",
    "Dalam penjemputan",
    "Hari ini, 09.00",
  ],
  [
    "KB-0321",
    "Putu Eka Pramana",
    "Baha Kelod",
    "9–11",
    "Diterima TPS 3R",
    "Kemarin, 15.20",
  ],
  [
    "KB-0320",
    "Ni Made Suriati",
    "Baha Kaja",
    "12–14",
    "Menunggu konfirmasi",
    "Besok, 09.00",
  ],
  [
    "KB-0319",
    "I Made Ariasa",
    "Baha Tengah",
    "7–9",
    "Driver ditugaskan",
    "Besok, 13.00",
  ],
  [
    "KB-0317",
    "Ni Kadek Purnami",
    "Baha Kelod",
    "10–12",
    "Gagal jemput",
    "23 Mar, 10.30",
  ],
  [
    "KB-0316",
    "I Nyoman Budi",
    "Baha Kaja",
    "6–8",
    "Ditolak TPS",
    "22 Mar, 16.10",
  ],
]

export interface TpsIncomingProps {
  stage: OfferStage
  setStage: (stage: OfferStage) => void
  setPoints: (points: number | ((prev: number) => number)) => void
}

export function TpsIncoming({ stage, setStage, setPoints }: TpsIncomingProps) {
  const [panel, setPanel] = useState(false)
  const [officialWeight, setOfficialWeight] = useState("11,5")
  const [reject, setReject] = useState(false)
  const [rejected, setRejected] = useState(false)

  const dynamicStatus = rejected
    ? "Ditolak TPS"
    : stage === "none"
      ? "Menunggu konfirmasi"
      : STAGE_STATUS[stage]

  const calculatedPoints = Math.round(
    Number(officialWeight.replace(",", ".") || 0) * 10,
  )

  const rows = DEFAULT_OFFERS.map((r, i) =>
    i === 0
      ? [
          "KB-0412",
          "Ni Luh Ayu Wulandari",
          "Baha Kelod",
          "Kadek Dwi Arta",
          "12 kg",
          <Badge key="badge-0">{dynamicStatus}</Badge>,
          "18 Okt, 08.00",
        ]
      : [
          r[0],
          r[1],
          r[2],
          i % 3 === 0 ? "I Gede Arta" : "I Ketut Budi",
          `${r[3]} kg`,
          <Badge key={`badge-${i}`}>{r[4]}</Badge>,
          r[5],
        ],
  )

  return (
    <>
      <PageHeader
        eyebrow="Operasional"
        title="Kompos masuk"
        action={<Button icon="history">Muat ulang</Button>}
      />

      <div className="filters">
        <SelectField label="Status" defaultValue="Semua status">
          <option>Semua status</option>
          <option>Diterima TPS 3R</option>
        </SelectField>
        <SelectField label="Banjar" defaultValue="Semua banjar">
          <option>Semua banjar</option>
          <option>Baha Kelod</option>
          <option>Baha Kaja</option>
        </SelectField>
        <Field label="Tanggal" type="date" defaultValue="2026-10-18" />
      </div>

      <div className="table-meta">
        <span>8 penawaran terbuka</span>
        <span>Diperbarui 10.42 WITA</span>
      </div>

      <DataTable
        headers={[
          "Kode",
          "Warga",
          "Banjar",
          "Driver",
          "Estimasi kg",
          "Status",
          "Waktu",
        ]}
        rows={rows}
        onRow={(i) => {
          if (i === 0) setPanel(true)
        }}
      />

      {panel && (
        <div className="side-panel">
          <div className="panel-header">
            <div>
              <div className="eyebrow">KB-0412</div>
              <h2>Verifikasi kompos</h2>
            </div>
            <button
              type="button"
              className="icon-button"
              onClick={() => setPanel(false)}
              aria-label="Tutup panel"
            >
              <Icon name="close" />
            </button>
          </div>

          <div className="panel-body">
            <Badge>{dynamicStatus}</Badge>
            <dl className="data-list compact">
              <div>
                <dt>Warga</dt>
                <dd>Ni Luh Ayu Wulandari</dd>
              </div>
              <div>
                <dt>Driver</dt>
                <dd>Kadek Dwi Arta</dd>
              </div>
              <div>
                <dt>Estimasi</dt>
                <dd>12 kg</dd>
              </div>
            </dl>

            <Field
              label="Berat resmi (kg)"
              value={officialWeight}
              onChange={setOfficialWeight}
            />

            <SelectField label="Kualitas" defaultValue="Baik">
              <option>Baik</option>
              <option>Cukup</option>
              <option>Kurang</option>
            </SelectField>

            <div className="checklist">
              <span>Pemeriksaan kualitas</span>
              {[
                "Tidak tercampur plastik",
                "Kadar air sesuai",
                "Sudah matang",
              ].map((x) => (
                <label key={x}>
                  <input type="checkbox" defaultChecked /> <span>{x}</span>
                </label>
              ))}
            </div>

            <button type="button" className="upload-box">
              <Icon name="camera" />
              Foto bukti penimbangan.jpg
            </button>

            <div className="points-preview">
              <span>Poin yang akan diberikan</span>
              <strong>{calculatedPoints} poin</strong>
              <small>{officialWeight || 0} kg × 10 poin per kg</small>
            </div>

            {stage !== "verified" && (
              <>
                <Button
                  variant="primary"
                  wide
                  onClick={() => {
                    setStage("verified")
                    setPoints(1355)
                  }}
                >
                  Terima dan berikan poin
                </Button>
                <Button variant="danger" wide onClick={() => setReject(true)}>
                  Tolak
                </Button>
              </>
            )}

            {reject && (
              <div className="reject-box">
                <SelectField
                  label="Alasan penolakan"
                  defaultValue="Tercampur sampah anorganik"
                >
                  <option>Tercampur sampah anorganik</option>
                  <option>Kompos belum matang</option>
                  <option>Kadar air terlalu tinggi</option>
                </SelectField>
                <Button
                  variant="danger"
                  wide
                  onClick={() => {
                    setRejected(true)
                    setReject(false)
                  }}
                >
                  Konfirmasi penolakan
                </Button>
              </div>
            )}
          </div>
        </div>
      )}
    </>
  )
}
