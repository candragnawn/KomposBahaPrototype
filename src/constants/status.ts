import { OfferStage } from "../types"

export const STATUS_COLORS: Record<string, string> = {
  Draft: "draft",
  "Menunggu konfirmasi": "waiting",
  "Driver ditugaskan": "assigned",
  "Dalam penjemputan": "pickup",
  "Diterima TPS 3R": "received",
  "Poin diberikan": "points",
  Dibatalkan: "draft",
  "Gagal jemput": "failed",
  "Ditolak TPS": "failed",
}

export const STAGE_STATUS: Record<OfferStage, string> = {
  none: "",
  waiting: "Menunggu konfirmasi",
  assigned: "Driver ditugaskan",
  pickup: "Dalam penjemputan",
  collected: "Dalam penjemputan",
  delivered: "Diterima TPS 3R",
  verified: "Poin diberikan",
}
