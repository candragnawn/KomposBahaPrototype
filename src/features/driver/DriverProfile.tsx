import { PageHeader } from "../../components/ui/PageHeader"

export function DriverProfile() {
  return (
    <div className="screen">
      <PageHeader title="Profil driver" />
      <section className="profile-block">
        <div className="avatar">KD</div>
        <h2>Kadek Dwi Arta</h2>
        <p>Driver terverifikasi · Desa Baha</p>
      </section>
      <dl className="data-list">
        <div>
          <dt>Nomor telepon</dt>
          <dd>0812 8842 1976</dd>
        </div>
        <div>
          <dt>Kendaraan</dt>
          <dd>DK 4821 FI</dd>
        </div>
        <div>
          <dt>Tugas bulan ini</dt>
          <dd>42 selesai</dd>
        </div>
      </dl>
    </div>
  )
}
