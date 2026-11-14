import { Badge } from "../../components/ui/Badge"
import { DataTable } from "../../components/ui/DataTable"
import { PageHeader } from "../../components/ui/PageHeader"

export interface AdminSummaryProps {
  onNavigateToTransactions: () => void
}

export function AdminSummary({ onNavigateToTransactions }: AdminSummaryProps) {
  const adminStats = [
    ["Kg kompos terserap bulan ini", "1.284 kg", "+12% dari September"],
    ["Warga aktif", "186", "dari 324 terdaftar"],
    ["Rata-rata penjemputan", "2,4 jam", "target di bawah 3 jam"],
    ["Poin ditukar", "8.460", "bulan berjalan"],
  ]

  const barData: [string, number][] = [
    ["M1", 230],
    ["M2", 310],
    ["M3", 286],
    ["M4", 458],
  ]

  const transactionRows = [
    [
      "KB-0415",
      "Ni Kadek Sari",
      "Baha Kaja",
      "15 kg",
      <Badge key="1">Menunggu konfirmasi</Badge>,
      "18 Okt, 10.00",
    ],
    [
      "KB-0412",
      "Ni Luh Ayu Wulandari",
      "Baha Kelod",
      "12 kg",
      <Badge key="2">Driver ditugaskan</Badge>,
      "18 Okt, 08.00",
    ],
    [
      "KB-0322",
      "I Ketut Merta",
      "Baha Tengah",
      "14–16 kg",
      <Badge key="3">Dalam penjemputan</Badge>,
      "Hari ini, 09.00",
    ],
    [
      "KB-0321",
      "Putu Eka Pramana",
      "Baha Kelod",
      "9–11 kg",
      <Badge key="4">Diterima TPS 3R</Badge>,
      "Kemarin, 15.20",
    ],
    [
      "KB-0320",
      "Ni Made Suriati",
      "Baha Kaja",
      "12–14 kg",
      <Badge key="5">Menunggu konfirmasi</Badge>,
      "Besok, 09.00",
    ],
  ]

  return (
    <>
      <PageHeader eyebrow="25 Oktober 2026" title="Ringkasan layanan" />

      <div className="admin-stats">
        {adminStats.map((s) => (
          <div className="admin-stat" key={s[0]}>
            <span>{s[0]}</span>
            <strong>{s[1]}</strong>
            <small>{s[2]}</small>
          </div>
        ))}
      </div>

      <div className="dashboard-grid">
        <section className="chart-card">
          <div className="section-heading">
            <div>
              <h2>Kompos per minggu</h2>
              <span>Oktober 2026 · kilogram</span>
            </div>
            <strong>1.284 kg</strong>
          </div>
          <div className="bar-chart">
            {barData.map(([l, v]) => (
              <div className="bar-column" key={l}>
                <span>{v}</span>
                <div style={{ height: `${Number(v) / 1.5}px` }} />
                <small>{l}</small>
              </div>
            ))}
          </div>
        </section>

        <section className="metric-list">
          <h2>Status layanan</h2>
          <div>
            <span>Menunggu driver</span>
            <strong>3</strong>
          </div>
          <div>
            <span>Dalam penjemputan</span>
            <strong>4</strong>
          </div>
          <div>
            <span>Menunggu verifikasi</span>
            <strong>5</strong>
          </div>
          <div>
            <span>Pengaduan terbuka</span>
            <strong>2</strong>
          </div>
        </section>
      </div>

      <section className="section">
        <div className="section-heading">
          <h2>Transaksi terbaru</h2>
          <button
            type="button"
            className="text-link"
            onClick={onNavigateToTransactions}
          >
            Lihat semua
          </button>
        </div>
        <DataTable
          headers={["Kode", "Warga", "Banjar", "Estimasi", "Status", "Waktu"]}
          rows={transactionRows}
        />
      </section>
    </>
  )
}
