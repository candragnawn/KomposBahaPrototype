import { useState } from "react"
import { Button } from "../../components/ui/Button"
import { DataTable } from "../../components/ui/DataTable"
import { PageHeader } from "../../components/ui/PageHeader"

export function AdminPoints() {
  const [pointsTab, setPointsTab] = useState<"rate" | "catalog" | "redemption">(
    "rate",
  )

  return (
    <>
      <PageHeader title="Poin dan hadiah" />
      <div className="tabs desktop-tabs">
        <button
          type="button"
          className={pointsTab === "rate" ? "active" : ""}
          onClick={() => setPointsTab("rate")}
        >
          Tarif poin dan ongkos
        </button>
        <button
          type="button"
          className={pointsTab === "catalog" ? "active" : ""}
          onClick={() => setPointsTab("catalog")}
        >
          Katalog hadiah
        </button>
        <button
          type="button"
          className={pointsTab === "redemption" ? "active" : ""}
          onClick={() => setPointsTab("redemption")}
        >
          Penukaran
        </button>
      </div>

      {pointsTab === "rate" ? (
        <div className="settings-panel wide">
          <div className="rate-box">
            <span>Tarif aktif</span>
            <strong>10 poin / kg</strong>
            <small>Berlaku sejak 1 Oktober 2026</small>
          </div>
          <h2>Aturan bonus</h2>
          <p>
            Tambahan 20 poin untuk setoran kualitas Baik dengan berat minimal 15
            kg.
          </p>
          <h2>Riwayat versi</h2>
          <DataTable
            headers={["Versi", "Tarif", "Aturan bonus", "Tanggal efektif"]}
            rows={[
              ["v2.1", "10 poin/kg", "+20 poin ≥ 15 kg", "1 Okt 2026"],
              ["v2.0", "8 poin/kg", "Tidak ada", "1 Jul 2026"],
            ]}
          />
        </div>
      ) : pointsTab === "catalog" ? (
        <>
          <div className="toolbar">
            <span>4 hadiah aktif</span>
            <Button variant="primary" icon="plus">
              Tambah hadiah
            </Button>
          </div>
          <DataTable
            headers={["Hadiah", "Stok", "Harga poin", "Status", "Tindakan"]}
            rows={[
              [
                "Bibit cabai",
                "12",
                "200",
                "Aktif",
                <Button key="1">Ubah</Button>,
              ],
              [
                "Polybag 10 pcs",
                "8",
                "150",
                "Aktif",
                <Button key="2">Ubah</Button>,
              ],
              [
                "Beras 5 kg",
                "5",
                "600",
                "Aktif",
                <Button key="3">Ubah</Button>,
              ],
              [
                "Kopi Baha 250 g",
                "0",
                "350",
                "Nonaktif",
                <Button key="4">Ubah</Button>,
              ],
            ]}
          />
        </>
      ) : (
        <DataTable
          headers={["Kode", "Warga", "Hadiah", "Poin", "Tanggal", "Tindakan"]}
          rows={[
            [
              "KBH-8468",
              "Ni Made Suriati",
              "Sekop kebun",
              "600",
              "18 Okt 2026",
              <div className="table-actions" key="a1">
                <Button variant="primary">Setujui</Button>
                <Button variant="danger">Tolak</Button>
              </div>,
            ],
            [
              "KBH-8461",
              "I Ketut Merta",
              "Beras lokal 2 kg",
              "1.000",
              "17 Okt 2026",
              <div className="table-actions" key="a2">
                <Button variant="primary">Setujui</Button>
                <Button variant="danger">Tolak</Button>
              </div>,
            ],
          ]}
        />
      )}
    </>
  )
}
