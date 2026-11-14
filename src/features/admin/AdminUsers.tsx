import { Badge } from "../../components/ui/Badge"
import { Button } from "../../components/ui/Button"
import { DataTable } from "../../components/ui/DataTable"
import { PageHeader } from "../../components/ui/PageHeader"

export function AdminUsers() {
  const userRows = [
    [
      "I Wayan Sudarta",
      "Warga",
      "Baha Kelod",
      "0812 3456 7812",
      <Badge key="1">Poin diberikan</Badge>,
      <Button key="b1">Detail</Button>,
    ],
    [
      "Ni Luh Ayu Wulandari",
      "Warga",
      "Baha Kaja",
      "0813 7788 1209",
      <Badge key="2">Menunggu konfirmasi</Badge>,
      <Button key="b2" variant="primary">
        Verifikasi
      </Button>,
    ],
    [
      "Kadek Dwi Arta",
      "Driver",
      "Baha Kelod",
      "0812 8842 1976",
      <Badge key="3">Poin diberikan</Badge>,
      <Button key="b3">Detail</Button>,
    ],
    [
      "Komang Adi Putra",
      "Driver",
      "Baha Tengah",
      "0819 4612 8401",
      <Badge key="4">Poin diberikan</Badge>,
      <Button key="b4">Detail</Button>,
    ],
  ]

  return (
    <>
      <PageHeader
        title="Pengguna"
        action={
          <Button variant="primary" icon="plus">
            Tambah pengguna
          </Button>
        }
      />
      <DataTable
        headers={[
          "Nama",
          "Peran",
          "Banjar",
          "Telepon",
          "Status verifikasi",
          "Tindakan",
        ]}
        rows={userRows}
      />
    </>
  )
}
