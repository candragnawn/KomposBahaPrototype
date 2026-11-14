import { useState } from "react"
import { Badge } from "../../components/ui/Badge"
import { DataTable } from "../../components/ui/DataTable"
import { Field } from "../../components/ui/Field"
import { PageHeader } from "../../components/ui/PageHeader"
import { SelectField } from "../../components/ui/SelectField"

export function AdminTransactions() {
  const [search, setSearch] = useState("")
  const [selectedStatus, setSelectedStatus] = useState("Semua status")
  const [selectedBanjar, setSelectedBanjar] = useState("Semua banjar")

  const rawTransactions = [
    [
      "KB-0415",
      "Ni Kadek Sari",
      "Baha Kaja",
      "15 kg",
      "Menunggu konfirmasi",
      "18 Okt, 10.00",
    ],
    [
      "KB-0412",
      "Ni Luh Ayu Wulandari",
      "Baha Kelod",
      "12 kg",
      "Driver ditugaskan",
      "18 Okt, 08.00",
    ],
    [
      "KB-0322",
      "I Ketut Merta",
      "Baha Tengah",
      "14–16 kg",
      "Dalam penjemputan",
      "Hari ini, 09.00",
    ],
    [
      "KB-0321",
      "Putu Eka Pramana",
      "Baha Kelod",
      "9–11 kg",
      "Diterima TPS 3R",
      "Kemarin, 15.20",
    ],
    [
      "KB-0320",
      "Ni Made Suriati",
      "Baha Kaja",
      "12–14 kg",
      "Menunggu konfirmasi",
      "Besok, 09.00",
    ],
    [
      "KB-0319",
      "I Made Ariasa",
      "Baha Tengah",
      "7–9 kg",
      "Driver ditugaskan",
      "Besok, 13.00",
    ],
    [
      "KB-0317",
      "Ni Kadek Purnami",
      "Baha Kelod",
      "10–12 kg",
      "Gagal jemput",
      "23 Mar, 10.30",
    ],
    [
      "KB-0316",
      "I Nyoman Budi",
      "Baha Kaja",
      "6–8 kg",
      "Ditolak TPS",
      "22 Mar, 16.10",
    ],
  ]

  const filtered = rawTransactions.filter(([code, name, banjar, , status]) => {
    const matchesSearch =
      !search ||
      code.toLowerCase().includes(search.toLowerCase()) ||
      name.toLowerCase().includes(search.toLowerCase())
    const matchesStatus =
      selectedStatus === "Semua status" || status === selectedStatus
    const matchesBanjar =
      selectedBanjar === "Semua banjar" || banjar === selectedBanjar
    return matchesSearch && matchesStatus && matchesBanjar
  })

  const transactionRows = filtered.map((r, i) => [
    r[0],
    r[1],
    r[2],
    r[3],
    <Badge key={i}>{r[4]}</Badge>,
    r[5],
  ])

  return (
    <>
      <PageHeader title="Transaksi" />
      <div className="filters">
        <SelectField
          label="Status"
          value={selectedStatus}
          onChange={setSelectedStatus}
        >
          <option>Semua status</option>
          <option>Menunggu konfirmasi</option>
          <option>Driver ditugaskan</option>
          <option>Dalam penjemputan</option>
          <option>Diterima TPS 3R</option>
          <option>Gagal jemput</option>
          <option>Ditolak TPS</option>
        </SelectField>
        <SelectField
          label="Banjar"
          value={selectedBanjar}
          onChange={setSelectedBanjar}
        >
          <option>Semua banjar</option>
          <option>Baha Kelod</option>
          <option>Baha Kaja</option>
          <option>Baha Tengah</option>
        </SelectField>
        <Field
          label="Cari warga atau kode"
          placeholder="Masukkan kata kunci"
          value={search}
          onChange={setSearch}
        />
      </div>
      <DataTable
        headers={["Kode", "Warga", "Banjar", "Estimasi", "Status", "Waktu"]}
        rows={transactionRows}
      />
    </>
  )
}
