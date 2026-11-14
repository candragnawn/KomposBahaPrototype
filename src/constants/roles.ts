import { IconName, Role } from "../types"

export interface RoleConfig {
  id: Role
  label: string
  detail: string
  icon: IconName
}

export const ROLES: RoleConfig[] = [
  {
    id: "warga",
    label: "Warga",
    detail: "Setor kompos dan tukar poin",
    icon: "home",
  },
  {
    id: "driver",
    label: "Driver",
    detail: "Kelola tugas penjemputan",
    icon: "truck",
  },
  {
    id: "tps",
    label: "TPS 3R",
    detail: "Timbang dan verifikasi kompos",
    icon: "box",
  },
  {
    id: "admin",
    label: "Admin Desa",
    detail: "Pantau layanan desa",
    icon: "users",
  },
]
