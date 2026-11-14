import React from "react"

export type Role = "warga" | "driver" | "tps" | "admin"

export type OfferStage = "none" | "waiting" | "assigned" | "pickup" | "collected" | "delivered" | "verified"

export type IconName = "home" | "plus" | "history" | "gift" | "truck" | "user" | "box" | "users" | "settings" | "chart" | "message" | "file" | "arrow" | "phone" | "camera" | "map" | "check" | "close" | "logout" | "bell" | "leaf" | "eye"

export interface PickupOrder {
  code: string
  residentName: string
  banjar: string
  address: string
  driverName?: string
  estimatedWeight: string
  officialWeight?: string
  quality?: "Baik" | "Cukup" | "Kurang"
  status: string
  date: string
  timeSlot: string
  notes?: string
  photoResident?: boolean
  photoPickup?: boolean
  photoProof?: boolean
  pointsEarned?: number
  rejectionReason?: string
  failureReason?: string
}

export interface RewardItem {
  id?: string
  name: string
  price: number
  stock: number
  tone: "green" | "amber" | "cream" | "coffee"
  status?: "Aktif" | "Nonaktif"
}

export interface LedgerItem {
  date: string
  description: string
  points: string
  balanceAfter: string
}

export interface UserItem {
  name: string
  role: string
  banjar: string
  phone: string
  verificationStatus: string
}

export interface ComplaintItem {
  id: string
  residentName: string
  topic: string
  date: string
  status: string
  description: string
  reply?: string
}
