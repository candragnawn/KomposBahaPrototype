import { Button } from "../../components/ui/Button"
import { Field } from "../../components/ui/Field"
import { PageHeader } from "../../components/ui/PageHeader"

export function TpsQuota() {
  return (
    <>
      <PageHeader title="Pengaturan kuota" />
      <div className="settings-panel">
        <h2>Kuota penerimaan harian</h2>
        <p>Atur batas kompos yang dapat diterima TPS 3R per hari.</p>
        <Field label="Kuota Senin–Jumat (kg)" defaultValue="500" />
        <Field label="Kuota Sabtu (kg)" defaultValue="300" />
        <Button variant="primary">Simpan pengaturan</Button>
      </div>
    </>
  )
}
