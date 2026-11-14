import { useState } from "react"
import { Button } from "../../components/ui/Button"
import { Field } from "../../components/ui/Field"
import { Icon } from "../../components/ui/Icon"

export interface WargaLoginProps {
  onLogin: () => void
  onBack: () => void
}

export function WargaLogin({ onLogin, onBack }: WargaLoginProps) {
  const [phone, setPhone] = useState("0812 3456 7812")
  const [password, setPassword] = useState("komposbaha")
  const [showPassword, setShowPassword] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState("")

  const submit = () => {
    if (!phone.trim() || password.length < 6) {
      setError("Nomor HP atau kata sandi salah")
      return
    }
    setError("")
    setLoading(true)
    window.setTimeout(onLogin, 650)
  }

  return (
    <main className="login-stage">
      <div className="login-frame">
        <div className="login-header">
          <button
            className="login-back"
            onClick={onBack}
            aria-label="Kembali ke pilih peran"
          >
            ←
          </button>
          <div className="login-brand">
            <span className="brand-mark">
              <Icon name="leaf" size={20} />
            </span>
            <div>
              <h1>Kompos Baha</h1>
              <p>Layanan kompos Desa Baha</p>
            </div>
          </div>
        </div>
        <section className="login-sheet">
          <div>
            <span className="eyebrow">Portal Warga</span>
            <h2>Selamat datang kembali</h2>
            <p>Masuk untuk mengatur penjemputan kompos dan poin Anda.</p>
          </div>
          {error && <div className="login-error">{error}</div>}
          <Field
            label="Nomor HP"
            value={phone}
            onChange={setPhone}
            placeholder="08xx xxxx xxxx"
          />
          <label className="field">
            <span>Kata sandi</span>
            <span className="password-wrap">
              <input
                type={showPassword ? "text" : "password"}
                value={password}
                onChange={(event) => setPassword(event.target.value)}
              />
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                aria-label="Tampilkan kata sandi"
              >
                <Icon name="eye" size={19} />
              </button>
            </span>
          </label>
          <Button variant="primary" wide onClick={submit} disabled={loading}>
            {loading ? "Sedang masuk..." : "Masuk"}
          </Button>
          <button className="register-link" type="button">
            Belum punya akun? <strong>Daftar lewat kader banjar</strong>
          </button>
        </section>
      </div>
    </main>
  )
}
