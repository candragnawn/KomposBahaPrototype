import { useState } from "react"
import { Badge } from "../../components/ui/Badge"
import { Button } from "../../components/ui/Button"
import { DataTable } from "../../components/ui/DataTable"
import { Field } from "../../components/ui/Field"
import { Icon } from "../../components/ui/Icon"
import { PageHeader } from "../../components/ui/PageHeader"

export function AdminComplaints() {
  const [complaint, setComplaint] = useState(false)
  const [replyText, setReplyText] = useState("")
  const [replySent, setReplySent] = useState(false)

  const complaintRows = [
    [
      "PGD-018",
      "Ni Luh Ayu Wulandari",
      "Driver terlambat",
      "18 Okt 2026",
      <Badge key="1">Menunggu konfirmasi</Badge>,
    ],
    [
      "PGD-017",
      "I Made Ariasa",
      "Poin belum masuk",
      "17 Okt 2026",
      <Badge key="2">Diterima TPS 3R</Badge>,
    ],
  ]

  const handleSendReply = () => {
    setReplySent(true)
    setTimeout(() => {
      setComplaint(false)
      setReplySent(false)
      setReplyText("")
    }, 1000)
  }

  return (
    <>
      <PageHeader title="Pengaduan" />
      <DataTable
        headers={["Nomor", "Pelapor", "Topik", "Tanggal", "Status"]}
        rows={complaintRows}
        onRow={() => setComplaint(true)}
      />

      {complaint && (
        <div className="side-panel">
          <div className="panel-header">
            <div>
              <div className="eyebrow">PGD-018</div>
              <h2>Driver terlambat</h2>
            </div>
            <button
              type="button"
              className="icon-button"
              onClick={() => setComplaint(false)}
              aria-label="Tutup panel"
            >
              <Icon name="close" />
            </button>
          </div>
          <div className="panel-body">
            <p>
              Penjemputan dijadwalkan pukul 09.00–11.00, tetapi driver belum
              tiba sampai pukul 12.30.
            </p>
            <Field
              label="Balasan kepada warga"
              placeholder="Tulis tanggapan resmi"
              value={replyText}
              onChange={setReplyText}
            />
            <Button
              variant="primary"
              wide
              onClick={handleSendReply}
              disabled={replySent}
            >
              {replySent ? "Terkirim!" : "Kirim balasan"}
            </Button>
          </div>
        </div>
      )}
    </>
  )
}
