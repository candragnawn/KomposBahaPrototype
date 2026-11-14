import { DataTable } from "../../components/ui/DataTable"
import { PageHeader } from "../../components/ui/PageHeader"

export function TpsSuppliers() {
  const supplierRows = [
    ["I Wayan Sudarta", "Baha Kelod", "3", "38 kg", "12,7 kg", "380"],
    ["Ni Luh Ayu Wulandari", "Baha Kaja", "4", "45 kg", "11,3 kg", "450"],
    ["I Ketut Merta", "Baha Tengah", "3", "41 kg", "13,7 kg", "410"],
    ["Putu Eka Pramana", "Baha Kelod", "2", "23 kg", "11,5 kg", "230"],
  ]

  return (
    <>
      <PageHeader eyebrow="Oktober 2026" title="Rekap pemasok" />
      <DataTable
        headers={[
          "Warga",
          "Banjar",
          "Jumlah setoran",
          "Total kg",
          "Rata-rata kg",
          "Poin",
        ]}
        rows={supplierRows}
      />
    </>
  )
}
