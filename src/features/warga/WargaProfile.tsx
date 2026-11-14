import { Button } from "../../components/ui/Button"

export interface WargaProfileProps {
  onExit: () => void
}

export function WargaProfile({ onExit }: WargaProfileProps) {
  return (
    <div className="screen warga-profile">
      <header className="page-title">
        <div>
          <span>Akun warga</span>
          <h1>Profil</h1>
        </div>
      </header>

      <section className="profile-block">
        <div className="avatar">WS</div>
        <h2>I Wayan Sudarta</h2>
        <p>Warga terverifikasi · Desa Baha</p>
      </section>

      <dl className="data-list">
        <div>
          <dt>Nomor HP</dt>
          <dd>0812 3456 7812</dd>
        </div>
        <div>
          <dt>Banjar</dt>
          <dd>Baha Kelod</dd>
        </div>
        <div>
          <dt>Alamat</dt>
          <dd>Jl. Baha No. 18</dd>
        </div>
        <div>
          <dt>Total setoran</dt>
          <dd>42,5 kg</dd>
        </div>
      </dl>

      <Button variant="danger" icon="logout" wide onClick={onExit}>
        Keluar dari akun
      </Button>
    </div>
  )
}
