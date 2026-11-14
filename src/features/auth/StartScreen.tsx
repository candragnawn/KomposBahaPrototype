import { ROLES } from "../../constants/roles"
import { Role } from "../../types"
import { Icon } from "../../components/ui/Icon"

export interface StartScreenProps {
  onRole: (role: Role) => void
}

export function StartScreen({ onRole }: StartScreenProps) {
  return (
    <main className="start-screen">
      <div className="start-card">
        <span className="brand-mark">
          <Icon name="leaf" size={20} />
        </span>
        <div className="eyebrow">Layanan Desa Baha</div>
        <h1>Kompos Baha</h1>
        <p>
          Platform pengumpulan kompos rumah tangga untuk lingkungan desa yang
          lebih bersih.
        </p>
        <div className="role-grid">
          {ROLES.map((role) => (
            <button
              className="role-button"
              key={role.id}
              onClick={() => onRole(role.id)}
            >
              <Icon name={role.icon} size={24} />
              <span>
                <strong>{role.label}</strong>
                <small>{role.detail}</small>
              </span>
              <Icon name="arrow" />
            </button>
          ))}
        </div>
        <small className="start-note">
          Pilih peran untuk memulai demonstrasi prototipe.
        </small>
      </div>
    </main>
  )
}
