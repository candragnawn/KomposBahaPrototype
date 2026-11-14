import React, { createContext, useContext, useState } from "react"
import {
  ComplaintItem,
  LedgerItem,
  OfferStage,
  PickupOrder,
  RewardItem,
  Role,
  UserItem,
} from "../types"
import {
  INITIAL_COMPLAINTS,
  INITIAL_LEDGER,
  INITIAL_PICKUP_ORDERS,
  INITIAL_REWARDS,
  INITIAL_USERS,
} from "../constants/mockData"
import { STAGE_STATUS } from "../constants/status"

export interface AppContextType {
  role: Role | null
  setRole: (role: Role | null) => void
  wargaLoggedIn: boolean
  setWargaLoggedIn: (loggedIn: boolean) => void
  stage: OfferStage
  setStage: (stage: OfferStage) => void
  points: number
  setPoints: (points: number | ((prev: number) => number)) => void
  orders: PickupOrder[]
  rewards: RewardItem[]
  ledger: LedgerItem[]
  users: UserItem[]
  complaints: ComplaintItem[]
  addOffer: (data: {
    estimatedWeight: string
    address: string
    timeSlot: string
    notes?: string
  }) => string
  redeemReward: (rewardName: string) => { success: boolean; error?: string };
  assignDriverToOrder: (code: string, driverName: string) => void
  verifyOrder: (
    code: string,
    officialWeight: string,
    quality: "Baik" | "Cukup" | "Kurang",
  ) => void
  rejectOrder: (code: string, reason: string) => void
  failDriverPickup: (code: string, reason: string) => void
  respondComplaint: (id: string, reply: string) => void
}

const AppContext = createContext<AppContextType | undefined>(undefined)

export function AppProvider({ children }: { children: React.ReactNode }) {
  const [role, setRole] = useState<Role | null>(null)
  const [wargaLoggedIn, setWargaLoggedIn] = useState(false)
  const [stage, setStage] = useState<OfferStage>("none")
  const [points, setPoints] = useState(1240)
  const [orders, setOrders] = useState<PickupOrder[]>(INITIAL_PICKUP_ORDERS)
  const [rewards, setRewards] = useState<RewardItem[]>(INITIAL_REWARDS)
  const [ledger, setLedger] = useState<LedgerItem[]>(INITIAL_LEDGER)
  const [users] = useState<UserItem[]>(INITIAL_USERS)
  const [complaints, setComplaints] =
    useState<ComplaintItem[]>(INITIAL_COMPLAINTS)

  const addOffer = (data: {
    estimatedWeight: string
    address: string
    timeSlot: string
    notes?: string
  }): string => {
    const code = `KB-${Math.floor(1000 + Math.random() * 9000)}`
    const newOrder: PickupOrder = {
      code,
      residentName: "I Wayan Sudarta",
      banjar: "Baha Kelod",
      address: data.address,
      estimatedWeight: data.estimatedWeight,
      status: "Menunggu konfirmasi",
      date: "Hari ini",
      timeSlot: data.timeSlot,
      notes: data.notes,
      photoResident: true,
    }
    setOrders((prev) => [newOrder, ...prev])
    setStage("waiting")
    return code
  }

  const redeemReward = (rewardName: string): {
    success: boolean
    error?: string
  } => {
    const targetReward = rewards.find((r) => r.name === rewardName)
    if (!targetReward) {
      return { success: false, error: "Hadiah tidak ditemukan" }
    }
    if (targetReward.stock <= 0) {
      return { success: false, error: "Stok hadiah habis" }
    }
    if (points < targetReward.price) {
      return { success: false, error: "Poin tidak mencukupi" }
    }

    const nextPoints = points - targetReward.price
    setPoints(nextPoints)

    setRewards((prev) =>
      prev.map((r) =>
        r.name === rewardName ? { ...r, stock: Math.max(0, r.stock - 1) } : r,
      ),
    )

    const now = new Date()
    const day = now.getDate()
    const month = now.toLocaleDateString("id-ID", { month: "short" })
    setLedger((prev) => [
      {
        date: `${day} ${month}`,
        description: `Tukar ${rewardName}`,
        points: `−${targetReward.price}`,
        balanceAfter: nextPoints.toLocaleString("id-ID"),
      },
      ...prev,
    ])

    return { success: true }
  }

  const assignDriverToOrder = (code: string, driverName: string) => {
    setOrders((prev) =>
      prev.map((order) =>
        order.code === code
          ? { ...order, driverName, status: "Driver ditugaskan" }
          : order,
      ),
    )
    if (code === "KB-0412") {
      setStage("assigned")
    }
  }

  const verifyOrder = (
    code: string,
    officialWeight: string,
    quality: "Baik" | "Cukup" | "Kurang",
  ) => {
    const numericWeight = parseFloat(officialWeight.replace(",", ".")) || 0
    const earnedPoints = Math.round(numericWeight * 10)

    setOrders((prev) =>
      prev.map((order) =>
        order.code === code
          ? {
              ...order,
              officialWeight,
              quality,
              status: "Poin diberikan",
              pointsEarned: earnedPoints,
              photoProof: true,
            }
          : order,
      ),
    )

    setPoints((prev) => {
      const nextBal = prev + earnedPoints
      setLedger((prevLedger) => [
        {
          date: "Hari ini",
          description: `Setoran ${code}`,
          points: `+${earnedPoints}`,
          balanceAfter: nextBal.toLocaleString("id-ID"),
        },
        ...prevLedger,
      ])
      return nextBal
    })

    if (code === "KB-0412") {
      setStage("verified")
    }
  }

  const rejectOrder = (code: string, reason: string) => {
    setOrders((prev) =>
      prev.map((order) =>
        order.code === code
          ? { ...order, status: "Ditolak TPS", rejectionReason: reason }
          : order,
      ),
    )
  }

  const failDriverPickup = (code: string, reason: string) => {
    setOrders((prev) =>
      prev.map((order) =>
        order.code === code
          ? { ...order, status: "Gagal jemput", failureReason: reason }
          : order,
      ),
    )
  }

  const respondComplaint = (id: string, reply: string) => {
    setComplaints((prev) =>
      prev.map((c) =>
        c.id === id ? { ...c, status: "Diterima TPS 3R", reply } : c,
      ),
    )
  }

  return (
    <AppContext.Provider
      value={{
        role,
        setRole,
        wargaLoggedIn,
        setWargaLoggedIn,
        stage,
        setStage,
        points,
        setPoints,
        orders,
        rewards,
        ledger,
        users,
        complaints,
        addOffer,
        redeemReward,
        assignDriverToOrder,
        verifyOrder,
        rejectOrder,
        failDriverPickup,
        respondComplaint,
      }}
    >
      {children}
    </AppContext.Provider>
  )
}

export function useApp() {
  const context = useContext(AppContext)
  if (!context) {
    throw new Error("useApp must be used within an AppProvider")
  }
  return context
}
