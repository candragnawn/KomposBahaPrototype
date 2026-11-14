import { Button } from "../../components/ui/Button"
import { DataTable } from "../../components/ui/DataTable"
import { Field } from "../../components/ui/Field"
import { PageHeader } from "../../components/ui/PageHeader"

export function AdminReports() {
  const banjarReports = [
    ["Baha Kelod", "486 kg", "44", "68", "4.860"],
    ["Baha Kaja", "421 kg", "41", "62", "4.210"],
    ["Baha Tengah", "377 kg", "39", "56", "3.770"],
  ]

  return (
    <>
      <PageHeader title="Laporan" />
      <div className="report-controls">
        <Field label="Bulan laporan" type="month" defaultValue="2026-10" />
        <div>
          <Button icon="file">Ekspor PDF</Button>
          <Button icon="file">Ekspor CSV</Button>
        </div>
      </div>
      <div className="admin-stats three">
        <div className="admin-stat">
          <span>Kompos terserap</span>
          <strong>1.284 kg</strong>
          <small>124 transaksi</small>
        </div>
        <div className="admin-stat">
          <span>Poin diterbitkan</span>
          <strong>12.840</strong>
          <small>senilai setoran terverifikasi</small>
        </div>
        <div className="admin-stat">
          <span>Poin ditukar</span>
          <strong>8.460</strong>
          <small>66% dari poin terbit</small>
        </div>
      </div>
      <DataTable
        headers={[
          "Banjar",
          "Total kg",
          "Setoran",
          "Warga aktif",
          "Poin terbit",
        ]}
        rows={banjarReports}
      />
    </>
  )
}
