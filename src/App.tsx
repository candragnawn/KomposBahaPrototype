import { useState } from "react";
import { Gift, History, Home, Plus, User } from "lucide-react";
import { CompostBin, GiftBox, LedgerCoin, PickupTruck } from "./components/Illustrations3D";

type Role = "warga" | "driver" | "tps" | "admin";
type OfferStage = "none" | "waiting" | "assigned" | "pickup" | "collected" | "delivered" | "verified";
type IconName =
  | "home"
  | "plus"
  | "history"
  | "gift"
  | "truck"
  | "user"
  | "box"
  | "users"
  | "settings"
  | "chart"
  | "message"
  | "file"
  | "arrow"
  | "phone"
  | "camera"
  | "map"
  | "check"
  | "close"
  | "logout"
  | "bell"
  | "leaf"
  | "eye";

const STATUS_COLORS: Record<string, string> = {
  Draft: "draft",
  "Menunggu konfirmasi": "waiting",
  "Driver ditugaskan": "assigned",
  "Dalam penjemputan": "pickup",
  "Diterima TPS 3R": "received",
  "Poin diberikan": "points",
  Dibatalkan: "draft",
  "Gagal jemput": "failed",
  "Ditolak TPS": "failed",
};

const stageStatus: Record<OfferStage, string> = {
  none: "",
  waiting: "Menunggu konfirmasi",
  assigned: "Driver ditugaskan",
  pickup: "Dalam penjemputan",
  collected: "Dalam penjemputan",
  delivered: "Diterima TPS 3R",
  verified: "Poin diberikan",
};

function Icon({ name, size = 20 }: { name: IconName; size?: number }) {
  const paths: Record<IconName, React.ReactNode> = {
    home: <><path d="m3 10 9-7 9 7" /><path d="M5 9v11h14V9M9 20v-6h6v6" /></>,
    plus: <><path d="M12 5v14M5 12h14" /></>,
    history: <><path d="M3 12a9 9 0 1 0 3-6.7L3 8" /><path d="M3 3v5h5M12 7v5l3 2" /></>,
    gift: <><path d="M3 10h18v11H3zM2 6h20v4H2zM12 6v15M12 6H8a2 2 0 0 1 0-4c3 0 4 4 4 4ZM12 6h4a2 2 0 0 0 0-4c-3 0-4 4-4 4Z" /></>,
    truck: <><path d="M3 5h11v12H3zM14 9h4l3 4v4h-7z" /><path d="M7 20a2 2 0 1 0 0-4 2 2 0 0 0 0 4ZM18 20a2 2 0 1 0 0-4 2 2 0 0 0 0 4Z" /></>,
    user: <><circle cx="12" cy="8" r="4" /><path d="M4 21a8 8 0 0 1 16 0" /></>,
    box: <><path d="m4 7 8-4 8 4v10l-8 4-8-4zM4 7l8 4 8-4M12 11v10" /></>,
    users: <><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2M9 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8M22 21v-2a4 4 0 0 0-3-3.9M16 3.1a4 4 0 0 1 0 7.8" /></>,
    settings: <><circle cx="12" cy="12" r="3" /><path d="M19.4 15a1.7 1.7 0 0 0 .3 1.9l.1.1-2.8 2.8-.1-.1a1.7 1.7 0 0 0-1.9-.3 1.7 1.7 0 0 0-1 1.6v.2h-4V21a1.7 1.7 0 0 0-1-1.6 1.7 1.7 0 0 0-1.9.3l-.1.1L4.2 17l.1-.1a1.7 1.7 0 0 0 .3-1.9A1.7 1.7 0 0 0 3 14H2.8v-4H3a1.7 1.7 0 0 0 1.6-1 1.7 1.7 0 0 0-.3-1.9L4.2 7 7 4.2l.1.1a1.7 1.7 0 0 0 1.9.3A1.7 1.7 0 0 0 10 3V2.8h4V3a1.7 1.7 0 0 0 1 1.6 1.7 1.7 0 0 0 1.9-.3l.1-.1L19.8 7l-.1.1a1.7 1.7 0 0 0-.3 1.9 1.7 1.7 0 0 0 1.6 1h.2v4H21a1.7 1.7 0 0 0-1.6 1Z" /></>,
    chart: <><path d="M4 20V10M10 20V4M16 20v-7M22 20H2" /></>,
    message: <><path d="M21 15a4 4 0 0 1-4 4H8l-5 3V7a4 4 0 0 1 4-4h10a4 4 0 0 1 4 4z" /></>,
    file: <><path d="M6 2h9l4 4v16H6zM14 2v5h5M9 13h6M9 17h6" /></>,
    arrow: <><path d="m9 18 6-6-6-6" /></>,
    phone: <><path d="M22 16.9v3a2 2 0 0 1-2.2 2 19.8 19.8 0 0 1-8.6-3.1 19.5 19.5 0 0 1-6-6A19.8 19.8 0 0 1 2.1 4.2 2 2 0 0 1 4.1 2h3a2 2 0 0 1 2 1.7c.1 1 .4 2 .7 2.8a2 2 0 0 1-.4 2.1L8.1 9.9a16 16 0 0 0 6 6l1.3-1.3a2 2 0 0 1 2.1-.4 13 13 0 0 0 2.8.7 2 2 0 0 1 1.7 2Z" /></>,
    camera: <><path d="M4 7h4l2-3h4l2 3h4v13H4z" /><circle cx="12" cy="13" r="4" /></>,
    map: <><path d="m3 6 6-3 6 3 6-3v15l-6 3-6-3-6 3zM9 3v15M15 6v15" /></>,
    check: <path d="m5 12 4 4L19 6" />,
    close: <path d="m6 6 12 12M18 6 6 18" />,
    logout: <><path d="M10 17l5-5-5-5M15 12H3M15 4h6v16h-6" /></>,
    bell: <><path d="M18 8a6 6 0 0 0-12 0c0 7-3 7-3 9h18c0-2-3-2-3-9M10 21h4" /></>,
    leaf: <><path d="M20 4C10 4 4 9 4 17c7 1 13-2 16-13Z" /><path d="M4 20c3-6 7-9 13-12" /></>,
    eye: <><path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12Z" /><circle cx="12" cy="12" r="3" /></>,
  };
  return <svg className="icon" width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">{paths[name]}</svg>;
}

const bottomTabs = [
  { key: "beranda", label: "Beranda", Icon: Home },
  { key: "hadiah", label: "Hadiah", Icon: Gift },
  { key: "setor", label: "Setor", Icon: Plus, primary: true },
  { key: "riwayat", label: "Riwayat", Icon: History },
  { key: "profil", label: "Profil", Icon: User },
];

export function BottomBar({ active = "beranda", onSelect }: { active?: string; onSelect?: (key: string) => void }) {
  return (
    <nav
      style={{
        flex: "none",
        width: "100%",
        margin: 0,
        padding: "8px 0 24px",
        background: "linear-gradient(180deg, #0B7A5C, #19B28D)",
        display: "grid",
        gridTemplateColumns: "repeat(5, 1fr)",
        boxSizing: "border-box",
      }}
    >
      {bottomTabs.map(({ key, label, Icon: TabIcon, primary }) => {
        const isActive = key === active;
        return (
          <button
            key={key}
            type="button"
            onClick={() => onSelect?.(key)}
            style={{
              background: "none",
              border: 0,
              padding: 0,
              minWidth: 0,
              display: "flex",
              flexDirection: "column",
              alignItems: "center",
              gap: 4,
              color: "#fff",
              opacity: isActive || primary ? 1 : 0.7,
              cursor: "pointer",
            }}
          >
            <span
              style={{
                width: 40,
                height: 40,
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                borderRadius: primary ? 20 : 0,
                background: primary ? "#fff" : "transparent",
                color: primary ? "#0B7A5C" : "#fff",
              }}
            >
              <TabIcon size={24} strokeWidth={1.75} />
            </span>
            <span
              style={{
                fontSize: 12,
                lineHeight: "16px",
                fontWeight: isActive ? 600 : 400,
                whiteSpace: "nowrap",
              }}
            >
              {label}
            </span>
          </button>
        );
      })}
    </nav>
  );
}

function Button({ children, variant = "secondary", icon, onClick, disabled, type = "button", wide = false }: {
  children: React.ReactNode; variant?: "primary" | "secondary" | "danger" | "text"; icon?: IconName;
  onClick?: () => void; disabled?: boolean; type?: "button" | "submit"; wide?: boolean;
}) {
  return <button type={type} className={`btn btn-${variant}${wide ? " btn-wide" : ""}`} onClick={onClick} disabled={disabled}>{icon && <Icon name={icon} size={18} />}<span>{children}</span></button>;
}

function Badge({ children }: { children: string }) {
  return <span className={`badge badge-${STATUS_COLORS[children] || "draft"}`}>{children}</span>;
}

function Field({ label, value, onChange, placeholder, type = "text", helper, error }: {
  label: string; value?: string; onChange?: (value: string) => void; placeholder?: string; type?: string; helper?: string; error?: string;
}) {
  return <label className="field"><span>{label}</span><input type={type} value={value} onChange={(e) => onChange?.(e.target.value)} placeholder={placeholder} className={error ? "has-error" : ""} />{error ? <small className="error">{error}</small> : helper ? <small>{helper}</small> : null}</label>;
}

function SelectField({ label, value, onChange, children }: { label: string; value?: string; onChange?: (value: string) => void; children: React.ReactNode }) {
  return <label className="field"><span>{label}</span><select value={value} onChange={(e) => onChange?.(e.target.value)}>{children}</select></label>;
}

function PageHeader({ title, eyebrow, action }: { title: string; eyebrow?: string; action?: React.ReactNode }) {
  return <div className="page-header"><div>{eyebrow && <div className="eyebrow">{eyebrow}</div>}<h1>{title}</h1></div>{action}</div>;
}

function StatusTimeline({ stage }: { stage: OfferStage }) {
  const steps = ["Menunggu konfirmasi", "Driver ditugaskan", "Dalam penjemputan", "Diterima TPS 3R", "Poin diberikan"];
  const order = ["waiting", "assigned", "pickup", "delivered", "verified"];
  const current = stage === "collected" ? 2 : order.indexOf(stage);
  const times = ["14 Okt · 08.10", "14 Okt · 08.35", "14 Okt · 10.02", "14 Okt · 11.18", "14 Okt · 15.42"];
  return <div className="timeline">{steps.map((step, i) => <div className={`timeline-row ${i < current ? "done" : i === current ? "current" : ""}`} key={step}><span className="timeline-marker">{i <= current && <Icon name="check" size={12} />}</span><div><strong>{step}</strong><small>{i <= current ? times[i] : "Menunggu"}</small></div></div>)}</div>;
}

function StartScreen({ onRole }: { onRole: (role: Role) => void }) {
  const roles: { id: Role; label: string; detail: string; icon: IconName }[] = [
    { id: "warga", label: "Warga", detail: "Setor kompos dan tukar poin", icon: "home" },
    { id: "driver", label: "Driver", detail: "Kelola tugas penjemputan", icon: "truck" },
    { id: "tps", label: "TPS 3R", detail: "Timbang dan verifikasi kompos", icon: "box" },
    { id: "admin", label: "Admin Desa", detail: "Pantau layanan desa", icon: "users" },
  ];
  return <main className="start-screen"><div className="start-card"><span className="brand-mark"><Icon name="leaf" size={20} /></span><div className="eyebrow">Layanan Desa Baha</div><h1>Kompos Baha</h1><p>Platform pengumpulan kompos rumah tangga untuk lingkungan desa yang lebih bersih.</p><div className="role-grid">{roles.map((role) => <button className="role-button" key={role.id} onClick={() => onRole(role.id)}><Icon name={role.icon} size={24} /><span><strong>{role.label}</strong><small>{role.detail}</small></span><Icon name="arrow" /></button>)}</div><small className="start-note">Pilih peran untuk memulai demonstrasi prototipe.</small></div></main>;
}

function WargaLogin({ onLogin, onBack }: { onLogin: () => void; onBack: () => void }) {
  const [phone, setPhone] = useState("0812 3456 7812");
  const [password, setPassword] = useState("komposbaha");
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const submit = () => {
    if (!phone.trim() || password.length < 6) {
      setError("Nomor HP atau kata sandi salah");
      return;
    }
    setError("");
    setLoading(true);
    window.setTimeout(onLogin, 650);
  };
  return <main className="login-stage"><div className="login-frame"><div className="login-header"><button className="login-back" onClick={onBack}>←</button><div className="login-brand"><span className="brand-mark"><Icon name="leaf" size={20} /></span><div><h1>Kompos Baha</h1><p>Layanan kompos Desa Baha</p></div></div></div><section className="login-sheet"><div><span className="eyebrow">Portal Warga</span><h2>Selamat datang kembali</h2><p>Masuk untuk mengatur penjemputan kompos dan poin Anda.</p></div>{error && <div className="login-error">{error}</div>}<Field label="Nomor HP" value={phone} onChange={setPhone} placeholder="08xx xxxx xxxx" /><label className="field"><span>Kata sandi</span><span className="password-wrap"><input type={showPassword ? "text" : "password"} value={password} onChange={(event) => setPassword(event.target.value)} /><button onClick={() => setShowPassword(!showPassword)} aria-label="Tampilkan kata sandi"><Icon name="eye" size={19} /></button></span></label><Button variant="primary" wide onClick={submit} disabled={loading}>{loading ? "Sedang masuk..." : "Masuk"}</Button><button className="register-link">Belum punya akun? <strong>Daftar lewat kader banjar</strong></button></section></div></main>;
}

const recentBase = [
  { code: "KB-0318", date: "18 Okt 2026", kg: "9 kg", status: "Dibatalkan" },
  { code: "KB-0309", date: "9 Okt 2026", kg: "11 kg", status: "Ditolak TPS" },
  { code: "KB-0227", date: "27 Sep 2026", kg: "14 kg", status: "Poin diberikan" },
];

function MobileShell({ role, active, setActive, onExit, children }: {
  role: "warga" | "driver"; active: string; setActive: (v: string) => void; onExit: () => void; children: React.ReactNode;
}) {
  const tabs = role === "warga"
    ? [{ id: "home", label: "Beranda", icon: "home" as IconName }, { id: "rewards", label: "Hadiah", icon: "gift" as IconName }, { id: "offer", label: "Setor", icon: "plus" as IconName }, { id: "history", label: "Riwayat", icon: "history" as IconName }]
    : [{ id: "tasks", label: "Tugas", icon: "truck" as IconName }, { id: "history", label: "Riwayat", icon: "history" as IconName }, { id: "profile", label: "Profil", icon: "user" as IconName }];
  return <main className={`prototype-stage mobile-stage ${role}-stage`}><div className={`mobile-frame ${role}-frame`}><div className="mobile-content">{children}</div><nav className={`bottom-nav ${role === "warga" ? "warga-nav" : ""}`}>{tabs.map((tab) => <button key={tab.id} className={`${active === tab.id ? "active" : ""}${tab.id === "offer" ? " center-action" : ""}`} onClick={() => setActive(tab.id)}><span className="nav-icon"><Icon name={tab.icon} /></span><span>{tab.label}</span></button>)}</nav><button className="role-exit" onClick={onExit} aria-label="Ganti peran"><Icon name="logout" size={17} /></button></div></main>;
}

function WargaApp({ stage, setStage, points, setPoints, onExit }: {
  stage: OfferStage; setStage: (s: OfferStage) => void; points: number; setPoints: (n: number) => void; onExit: () => void;
}) {
  const [active, setActive] = useState("home");
  const [detail, setDetail] = useState(false);
  const [historyTab, setHistoryTab] = useState("setoran");
  const [photo, setPhoto] = useState(false);
  const [formError, setFormError] = useState("");
  const [loading, setLoading] = useState(false);
  const [reward, setReward] = useState<string | null>(null);
  const [confirm, setConfirm] = useState(false);
  const [redeemState, setRedeemState] = useState<"idle" | "loading" | "success" | "error">("idle");
  const [homePickupState] = useState<"ready" | "empty" | "loading">("ready");

  const go = (tab: string) => { setActive(tab); setDetail(false); setReward(null); setRedeemState("idle"); };
  const selectBottomTab = (key: string) => {
    const target = key === "beranda" ? "home" : key === "hadiah" ? "rewards" : key === "setor" ? "offer" : key === "riwayat" ? "history" : key === "profil" ? "profile" : null;
    if (target) go(target);
  };
  const [offerSuccess, setOfferSuccess] = useState(false);
  const submitOffer = () => {
    if (!photo) { setFormError("Foto kompos wajib ditambahkan."); return; }
    setFormError(""); setLoading(true);
    window.setTimeout(() => { setLoading(false); setStage("waiting"); setOfferSuccess(true); }, 700);
  };
  const redeem = () => {
    const rewardPrice = reward === "Bibit cabai" ? 200 : reward === "Polybag 10 pcs" ? 150 : reward === "Beras 5 kg" ? 600 : 350;
    if (rewardPrice > points) { setRedeemState("error"); setConfirm(false); return; }
    setRedeemState("loading"); setConfirm(false);
    window.setTimeout(() => { setPoints(points - rewardPrice); setRedeemState("success"); }, 700);
  };
  const latest = [
    { code: "KB-0412", date: "18 Okt 2026", kg: "12 kg", status: stage === "none" ? "Driver ditugaskan" : stageStatus[stage] },
    { code: "KB-0409", date: "14 Okt 2026", kg: "8 kg", status: "Poin diberikan" },
    { code: "KB-0405", date: "9 Okt 2026", kg: "10 kg", status: "Ditolak TPS" },
    { code: "KB-0401", date: "2 Okt 2026", kg: "9 kg", status: "Gagal jemput" },
    { code: "KB-0398", date: "25 Sep 2026", kg: "11 kg", status: "Dibatalkan" },
  ];

  let content: React.ReactNode;
  if (active === "home") content = <>
    <header className="home-flex-header">
      <div className="system-status"><strong>9:41</strong><svg width="68" height="16" viewBox="0 0 68 16" fill="none" aria-label="Sinyal, Wi-Fi, dan baterai"><path d="M1 13h3V9H1v4Zm5 0h3V6H6v7Zm5 0h3V3h-3v10Z" fill="currentColor" /><path d="M22 6.5c4-4 10-4 14 0M25 9.5c2.5-2.4 5.5-2.4 8 0M29 13h.1" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" /><rect x="43" y="3" width="20" height="10" rx="2" stroke="currentColor" strokeWidth="1.5" /><path d="M65 6v4" stroke="currentColor" strokeWidth="2" strokeLinecap="round" /><rect x="45.5" y="5.5" width="14" height="5" rx="1" fill="currentColor" /></svg></div>
      <div className="home-user-row"><div className="avatar">WS</div><div className="home-user-copy"><small>Selamat pagi</small><strong>I Wayan Sudarta</strong></div><span className="points-pill"><Icon name="leaf" size={16} />{points.toLocaleString("id-ID")} poin</span><button className="header-icon" aria-label="Notifikasi"><Icon name="bell" size={20} /></button></div>
      <section className="home-flex-hero"><div><span>Setoran bulan ini</span><strong>42,5 <small>kg</small></strong><p>terkirim ke TPS 3R</p></div><span className="hero-art-box"><CompostBin /></span></section>
    </header>
    <main className="home-flex-content"><section className="home-services"><h2>Layanan</h2><div className="home-service-grid"><button onClick={() => go("offer")}><span><CompostBin /></span><strong>Setor kompos</strong></button><button onClick={() => go("rewards")}><span><GiftBox /></span><strong>Tukar hadiah</strong></button><button onClick={() => go("history")}><span><LedgerCoin /></span><strong>Mutasi poin</strong></button></div></section>
      <section className="home-pickups"><div className="home-section-row"><h2>Penjemputan aktif</h2><button onClick={() => go("history")}>Lihat semua</button></div>{homePickupState === "loading" ? <div className="home-loading" aria-label="Memuat penjemputan"><div><i /><i /><i /></div><b /></div> : homePickupState === "empty" ? <div className="home-empty"><div><Icon name="truck" size={24} /><strong>Belum ada penjemputan</strong><small>Jadwalkan pengambilan kompos dari rumah Anda.</small></div><Button variant="primary" onClick={() => go("offer")}>Setor kompos</Button></div> : <div className="home-pickup-list"><button className="home-pickup-primary" onClick={() => { setActive("offer"); setDetail(true); }}><div><strong>KB-0412 · 12 kg</strong><span><Icon name="map" size={14} />Jl. Baha No. 18, Baha Kelod</span><small>Besok, 08.00-10.00</small><Badge>Driver ditugaskan</Badge></div><span className="home-truck-box"><PickupTruck /></span></button><button className="home-pickup-complete" onClick={() => { setActive("offer"); setDetail(true); }}><div><strong>KB-0409 · 8 kg</strong><small>14 Okt 2026</small><Badge>Poin diberikan</Badge></div><Icon name="check" size={20} /></button></div>}</section>
    </main>
  </>;
  else if (active === "offer" && detail) content = <div className="screen detail-screen">
    <header className="page-title"><button onClick={() => setDetail(false)}>←</button><div><span>Detail pesanan</span><h1>KB-0409</h1></div><Badge>{stage === "none" ? "Poin diberikan" : stageStatus[stage]}</Badge></header>
    <section className="timeline-card"><StatusTimeline stage={stage === "none" ? "verified" : stage} /><div className="timeline-date">14 Okt 2026 · 15.42 WITA</div></section>
    <section className="driver-card"><div className="avatar">KD</div><div><small>Driver</small><strong>Kadek Dwi Arta</strong></div><button><Icon name="phone" /></button></section>
    <section className="result-card mint-result"><h2>Hasil verifikasi TPS 3R</h2><dl><div><dt>Berat resmi</dt><dd>8,2 kg</dd></div><div><dt>Kualitas</dt><dd>Baik</dd></div><div><dt>Poin diperoleh</dt><dd>+82 poin</dd></div></dl><div className="photo-proof"><Icon name="camera" /><span>Foto bukti penimbangan</span></div></section>
    {(stage === "waiting" || stage === "assigned") && <Button variant="danger" wide onClick={() => { setStage("none"); setDetail(false); }}>Batalkan penawaran</Button>}
  </div>;
  else if (active === "offer") content = <div className="screen offer-screen">
    <header className="page-title"><button onClick={() => go("home")}>←</button><div><span>Setor kompos</span><h1>Buat penawaran</h1></div></header>
    <div className="notice">Poin diberikan setelah berat dan kualitas disahkan TPS 3R.</div>
    <div className="form-stack"><Field label="Estimasi berat (kg)" value="12" helper="Berat resmi ditentukan saat penimbangan" />
      <div className="field"><span>Foto kompos</span><button className={`upload-box ${formError ? "has-error" : ""}`} onClick={() => { setPhoto(true); setFormError(""); }}><Icon name={photo ? "check" : "camera"} />{photo ? "Foto kompos-sudarta.jpg ditambahkan" : "Tambahkan foto kompos"}</button>{formError && <small className="error">{formError}</small>}</div>
      <Field label="Alamat penjemputan" value="Jl. Baha No. 18, Banjar Baha Kelod" /><div className="map-box"><Icon name="map" /><span>Lokasi penjemputan</span><small>Banjar Baha Kelod, Mengwi</small></div>
      <div className="field-row"><Field label="Tanggal siap" type="date" value="2026-10-18" /><SelectField label="Jam siap" value="08.00–10.00"><option>08.00–10.00</option><option>10.00–12.00</option></SelectField></div>
      <label className="field"><span>Catatan</span><textarea defaultValue="Kompos disimpan di karung putih dekat pintu samping." /></label>
      <Button variant="primary" wide onClick={submitOffer} disabled={loading}>{loading ? "Mengirim penawaran..." : "Kirim penawaran"}</Button>
    </div>{offerSuccess && <div className="modal-backdrop bottom"><div className="success-sheet"><span className="success-icon"><Icon name="check" size={28} /></span><h2>Penawaran terkirim</h2><p>Kode penawaran Anda</p><strong className="success-code">KB-0412</strong><Button variant="primary" wide onClick={() => { setOfferSuccess(false); setDetail(true); }}>Lihat status</Button></div></div>}
  </div>;
  else if (active === "history") content = <div className="screen history-screen">
    <header className="page-title"><div><span>Aktivitas Anda</span><h1>Riwayat</h1></div></header><div className="tabs"><button className={historyTab === "setoran" ? "active" : ""} onClick={() => setHistoryTab("setoran")}>Setoran</button><button className={historyTab === "poin" ? "active" : ""} onClick={() => setHistoryTab("poin")}>Mutasi poin</button></div>
    {historyTab === "setoran" ? <div className="list history-list">{latest.map((item) => <button className="list-item" key={item.code} onClick={() => { setActive("offer"); setDetail(true); }}><div><strong>{item.code}</strong><small>{item.date} · {item.kg}</small></div><Badge>{item.status}</Badge></button>)}</div>
      : <div className="ledger">{[{ d: "14 Okt", x: "Setoran KB-0409", p: "+82", s: "1.240" }, { d: "10 Okt", x: "Tukar Bibit cabai", p: "−200", s: "1.158" }, { d: "3 Okt", x: "Setoran KB-0400", p: "+95", s: "1.358" }].map((r) => <div className="ledger-row" key={r.d + r.x}><span>{r.d}</span><div><strong>{r.x}</strong><small>Saldo setelah {r.s}</small></div><b className={r.p.startsWith("+") ? "positive" : "negative"}>{r.p}</b></div>)}</div>}
  </div>;
  else if (active === "rewards") {
    const rewards = [{ name: "Bibit cabai", price: 200, stock: 12, tone: "green" as const }, { name: "Polybag 10 pcs", price: 150, stock: 8, tone: "amber" as const }, { name: "Beras 5 kg", price: 600, stock: 5, tone: "cream" as const }, { name: "Kopi Baha 250 g", price: 350, stock: 0, tone: "coffee" as const }];
    if (redeemState === "success") content = <div className="screen success-screen"><div className="success-icon"><Icon name="check" size={32} /></div><div className="eyebrow">Penukaran berhasil</div><h1>Hadiah siap diambil</h1><p>Tunjukkan kode ini kepada petugas Kantor Desa Baha.</p><div className="redeem-code"><span>Kode penukaran</span><strong>TKR-7F3A</strong></div><Button variant="primary" wide onClick={() => { go("home"); }}>Selesai</Button></div>;
    else if (reward) {
      const item = rewards.find((r) => r.name === reward)!;
      content = <div className="screen reward-detail"><button className="back-link" onClick={() => { setReward(null); setRedeemState("idle"); }}>← Katalog hadiah</button><div className="reward-image large"><GiftBox /></div><PageHeader title={item.name} /><div className="reward-price">{item.price.toLocaleString("id-ID")} poin</div><section className="section"><h2>Syarat penukaran</h2><ul className="requirements"><li>Hadiah diambil di Kantor Desa Baha.</li><li>Tunjukkan kode penukaran dan KTP.</li><li>Kode berlaku selama 7 hari.</li></ul></section>{item.stock === 0 && <div className="error-box"><strong>Stok habis</strong><span>Hadiah ini akan tersedia kembali setelah stok diperbarui.</span></div>}{redeemState === "error" && <div className="error-box"><strong>Poin tidak cukup</strong></div>}<Button variant="primary" wide disabled={item.stock === 0} onClick={() => setConfirm(true)}>Tukar poin</Button>{confirm && <div className="modal-backdrop"><div className="dialog" role="dialog"><h2>Konfirmasi penukaran</h2><dl><div><dt>Saldo sebelum</dt><dd>{points.toLocaleString("id-ID")}</dd></div><div><dt>Saldo sesudah</dt><dd>{(points - item.price).toLocaleString("id-ID")}</dd></div></dl><div className="dialog-actions"><Button onClick={() => setConfirm(false)}>Kembali</Button><Button variant="primary" onClick={redeem}>Konfirmasi</Button></div></div></div>}{redeemState === "loading" && <div className="loading-bar">Memproses penukaran...</div>}</div>;
    } else content = <div className="screen rewards-screen"><header className="page-title"><div><span>Katalog warga</span><h1>Hadiah</h1></div><span className="points-pill"><Icon name="leaf" size={15} />{points.toLocaleString("id-ID")} poin</span></header><div className="reward-grid">{rewards.map((item) => <button className="reward-card" key={item.name} onClick={() => setReward(item.name)}><div><strong>{item.name}</strong><span>{item.price.toLocaleString("id-ID")} poin</span><small>{item.stock ? `Stok ${item.stock}` : "Stok habis"}</small></div><div className="reward-image"><GiftBox /></div></button>)}</div></div>;
  } else content = <div className="screen warga-profile"><header className="page-title"><div><span>Akun warga</span><h1>Profil</h1></div></header><section className="profile-block"><div className="avatar">WS</div><h2>I Wayan Sudarta</h2><p>Warga terverifikasi · Desa Baha</p></section><dl className="data-list"><div><dt>Nomor HP</dt><dd>0812 3456 7812</dd></div><div><dt>Banjar</dt><dd>Baha Kelod</dd></div><div><dt>Alamat</dt><dd>Jl. Baha No. 18</dd></div><div><dt>Total setoran</dt><dd>42,5 kg</dd></div></dl><Button variant="danger" icon="logout" wide onClick={onExit}>Keluar dari akun</Button></div>;
  if (active === "home") return <div className="warga-home-root">{content}<BottomBar active="beranda" onSelect={selectBottomTab} /></div>;
  const bottomActive = active === "rewards" ? "hadiah" : active === "offer" ? "setor" : active === "history" ? "riwayat" : active === "profile" ? "profil" : "beranda";
  return <div className="warga-flow-root"><div className="warga-flow-status" /><div className="warga-flow-content">{content}</div><BottomBar active={bottomActive} onSelect={selectBottomTab} /></div>;
}

function DriverApp({ stage, setStage, onExit }: { stage: OfferStage; setStage: (s: OfferStage) => void; onExit: () => void }) {
  const [active, setActive] = useState("tasks");
  const [detail, setDetail] = useState(false);
  const [ready, setReady] = useState(true);
  const [pickupPhoto, setPickupPhoto] = useState(false);
  const [failDialog, setFailDialog] = useState(false);
  const [failed, setFailed] = useState(false);
  let content: React.ReactNode;
  if (active === "tasks" && detail) content = <div className="screen"><button className="back-link" onClick={() => setDetail(false)}>← Daftar tugas</button><PageHeader eyebrow="KB-0412" title="Detail penjemputan" /><Badge>{failed ? "Gagal jemput" : stageStatus[stage]}</Badge><section className="info-card address"><span>Alamat</span><strong>Ni Luh Ayu Wulandari</strong><p>Jl. Baha No. 7, Banjar Baha Kelod</p><Button icon="phone">Hubungi warga</Button></section><div className="map-box tall"><Icon name="map" /><span>Rute menuju lokasi</span><small>1,8 km · sekitar 7 menit</small></div><section className="detail-grid"><div><span>Estimasi</span><strong>12 kg</strong></div><div><span>Waktu</span><strong>08.00–10.00</strong></div></section><section className="info-card"><span>Catatan warga</span><p>Kompos disimpan di karung putih dekat pintu samping.</p><div className="resident-photo"><Icon name="camera" /><span>Foto dari warga</span></div></section>{stage === "assigned" && <Button variant="primary" wide onClick={() => setStage("pickup")}>Mulai jemput</Button>}{stage === "pickup" && <><button className="upload-box" onClick={() => setPickupPhoto(true)}><Icon name={pickupPhoto ? "check" : "camera"} />{pickupPhoto ? "Foto pengambilan ditambahkan" : "Tambah foto pengambilan (wajib)"}</button><Button variant="primary" wide disabled={!pickupPhoto} onClick={() => setStage("collected")}>Konfirmasi sudah diambil</Button></>}{stage === "collected" && <><div className="notice success">Kompos sudah diambil. Antar ke TPS 3R Desa Baha.</div><Button variant="primary" wide onClick={() => { setStage("delivered"); setDetail(false); }}>Konfirmasi sudah diantar ke TPS 3R</Button></>}<Button variant="danger" wide onClick={() => setFailDialog(true)}>Gagal jemput</Button>{failDialog && <div className="modal-backdrop"><div className="dialog"><h2>Laporkan gagal jemput</h2><SelectField label="Alasan" value="Warga tidak di tempat"><option>Warga tidak di tempat</option><option>Kompos tidak sesuai</option><option>Alamat tidak ditemukan</option><option>Lainnya</option></SelectField><div className="dialog-actions"><Button onClick={() => setFailDialog(false)}>Kembali</Button><Button variant="danger" onClick={() => { setFailed(true); setFailDialog(false); }}>Simpan laporan</Button></div></div></div>}</div>;
  else if (active === "tasks") content = <div className="screen driver-tasks"><div className="driver-greeting"><div><span>Halo,</span><h1>Kadek Dwi Arta</h1></div><button className="availability" onClick={() => setReady(!ready)}><span><strong>Siap menerima tugas</strong></span><span className={`switch ${ready ? "on" : ""}`}><i /></span></button></div><section className="driver-summary"><div><span>Hari ini</span><strong>3 tugas · 35 kg</strong><small>18 Oktober 2026</small></div><span className="row-art"><PickupTruck /></span></section><div className="group-label">Banjar Baha Kelod · 08.00–10.00</div><div className="task-list">{[["Ni Luh Ayu Wulandari","Jl. Baha No. 7","12 kg"],["I Made Sukarta","Gg. Melati No. 3","8 kg"]].map((task) => <button className="task-card" key={task[0]} onClick={() => setDetail(true)}><div><strong>{task[0]}</strong><span>{task[1]}</span><small>{task[2]} · 08.00–10.00</small></div><Badge>Driver ditugaskan</Badge></button>)}</div><div className="group-label">Banjar Baha Kaja · 10.00–12.00</div><div className="task-list"><button className="task-card"><div><strong>Ni Kadek Sari</strong><span>Jl. Baha Kaja No. 22</span><small>15 kg · 10.00–12.00</small></div><Badge>Driver ditugaskan</Badge></button></div></div>;
  else if (active === "history") content = <div className="screen"><PageHeader title="Riwayat tugas" /><div className="balance-inline"><span>Total minggu ini</span><strong>74 kg</strong></div><div className="list">{["Ni Made Suriati|18 Okt 2026|12 kg", "I Ketut Merta|17 Okt 2026|16 kg", "Putu Eka Pramana|15 Okt 2026|11 kg", "Ni Nyoman Rai|12 Okt 2026|14 kg"].map((x) => { const [n,d,k]=x.split("|"); return <div className="list-item" key={n}><div><strong>{n}</strong><small>{d} · {k}</small></div><Badge>Poin diberikan</Badge></div>})}</div></div>;
  else content = <div className="screen"><PageHeader title="Profil driver" /><section className="profile-block"><div className="avatar">KD</div><h2>Kadek Dwi Arta</h2><p>Driver terverifikasi · Desa Baha</p></section><dl className="data-list"><div><dt>Nomor telepon</dt><dd>0812 8842 1976</dd></div><div><dt>Kendaraan</dt><dd>DK 4821 FI</dd></div><div><dt>Tugas bulan ini</dt><dd>42 selesai</dd></div></dl></div>;
  return <MobileShell role="driver" active={active} setActive={(v) => { setActive(v); setDetail(false); }} onExit={onExit}>{content}</MobileShell>;
}

const openOffers = [
  ["KB-0415", "Ni Kadek Sari", "Baha Kaja", "15", "Menunggu konfirmasi", "18 Okt, 10.00"],
  ["KB-0412", "Ni Luh Ayu Wulandari", "Baha Kelod", "12", "Driver ditugaskan", "18 Okt, 08.00"],
  ["KB-0322", "I Ketut Merta", "Baha Tengah", "14–16", "Dalam penjemputan", "Hari ini, 09.00"],
  ["KB-0321", "Putu Eka Pramana", "Baha Kelod", "9–11", "Diterima TPS 3R", "Kemarin, 15.20"],
  ["KB-0320", "Ni Made Suriati", "Baha Kaja", "12–14", "Menunggu konfirmasi", "Besok, 09.00"],
  ["KB-0319", "I Made Ariasa", "Baha Tengah", "7–9", "Driver ditugaskan", "Besok, 13.00"],
  ["KB-0317", "Ni Kadek Purnami", "Baha Kelod", "10–12", "Gagal jemput", "23 Mar, 10.30"],
  ["KB-0316", "I Nyoman Budi", "Baha Kaja", "6–8", "Ditolak TPS", "22 Mar, 16.10"],
];

function DesktopShell({ role, active, setActive, onExit, children }: { role: "tps" | "admin"; active: string; setActive: (v: string) => void; onExit: () => void; children: React.ReactNode }) {
  const tps = [{ id: "incoming", label: "Kompos masuk", icon: "box" }, { id: "assign", label: "Penugasan driver", icon: "truck" }, { id: "suppliers", label: "Rekap pemasok", icon: "users" }, { id: "quota", label: "Pengaturan kuota", icon: "settings" }];
  const admin = [{ id: "summary", label: "Ringkasan", icon: "home" }, { id: "transactions", label: "Transaksi", icon: "history" }, { id: "users", label: "Pengguna", icon: "users" }, { id: "points", label: "Poin dan hadiah", icon: "gift" }, { id: "complaints", label: "Pengaduan", icon: "message" }, { id: "reports", label: "Laporan", icon: "file" }];
  const links = role === "tps" ? tps : admin;
  return <main className="desktop-app"><aside className="sidebar"><div className="desktop-brand"><span className="brand-mark small">KB</span><div><strong>Kompos Baha</strong><small>{role === "tps" ? "TPS 3R Desa Baha" : "Admin Desa Baha"}</small></div></div><nav>{links.map((l) => <button key={l.id} className={active === l.id ? "active" : ""} onClick={() => setActive(l.id)}><Icon name={l.icon as IconName} /><span>{l.label}</span></button>)}</nav><button className="sidebar-exit" onClick={onExit}><Icon name="logout" /><span>Ganti peran</span></button></aside><div className="desktop-main"><header className="topbar"><span>Desa Baha, Mengwi</span><div className="topbar-user"><span>{role === "tps" ? "I Made Sutama" : "Ni Luh Sri Wahyuni"}<small>{role === "tps" ? "Petugas TPS 3R" : "Administrator"}</small></span><div className="avatar small">{role === "tps" ? "MS" : "SW"}</div></div></header><div className="desktop-content">{children}</div></div></main>;
}

function DataTable({ headers, rows, onRow }: { headers: string[]; rows: React.ReactNode[][]; onRow?: (i: number) => void }) {
  return <div className="table-wrap"><table><thead><tr>{headers.map((h) => <th key={h}>{h}<span className="sort">↕</span></th>)}</tr></thead><tbody>{rows.map((row, i) => <tr key={i} onClick={() => onRow?.(i)} className={onRow ? "clickable" : ""}>{row.map((cell, j) => <td key={j}>{cell}</td>)}</tr>)}</tbody></table></div>;
}

function TpsApp({ stage, setStage, setPoints, onExit }: { stage: OfferStage; setStage: (s: OfferStage) => void; setPoints: (n: number) => void; onExit: () => void }) {
  const [active, setActive] = useState("incoming");
  const [panel, setPanel] = useState(false);
  const [officialWeight, setOfficialWeight] = useState("11,5");
  const [assigned, setAssigned] = useState(false);
  const [reject, setReject] = useState(false);
  const [rejected, setRejected] = useState(false);
  const dynamicStatus = rejected ? "Ditolak TPS" : stage === "none" ? "Menunggu konfirmasi" : stageStatus[stage];
  const rows = openOffers.map((r, i) => i === 0 ? ["KB-0412", "Ni Luh Ayu Wulandari", "Baha Kelod", stage === "waiting" || stage === "none" ? "Kadek Dwi Arta" : "Kadek Dwi Arta", "12 kg", <Badge>{dynamicStatus}</Badge>, "18 Okt, 08.00"] : [r[0], r[1], r[2], i % 3 === 0 ? "I Gede Arta" : "I Ketut Budi", `${r[3]} kg`, <Badge>{r[4]}</Badge>, r[5]]);
  let content: React.ReactNode;
  if (active === "incoming") content = <><PageHeader eyebrow="Operasional" title="Kompos masuk" action={<Button icon="history">Muat ulang</Button>} /><div className="filters"><SelectField label="Status" value="Semua status"><option>Semua status</option><option>Diterima TPS 3R</option></SelectField><SelectField label="Banjar" value="Semua banjar"><option>Semua banjar</option><option>Baha Kelod</option><option>Baha Kaja</option></SelectField><Field label="Tanggal" type="date" value="2026-10-18" /></div><div className="table-meta"><span>8 penawaran terbuka</span><span>Diperbarui 10.42 WITA</span></div><DataTable headers={["Kode", "Warga", "Banjar", "Driver", "Estimasi kg", "Status", "Waktu"]} rows={rows} onRow={(i) => i === 0 && setPanel(true)} />{panel && <div className="side-panel"><div className="panel-header"><div><div className="eyebrow">KB-0412</div><h2>Verifikasi kompos</h2></div><button className="icon-button" onClick={() => setPanel(false)}><Icon name="close" /></button></div><div className="panel-body"><Badge>{dynamicStatus}</Badge><dl className="data-list compact"><div><dt>Warga</dt><dd>Ni Luh Ayu Wulandari</dd></div><div><dt>Driver</dt><dd>Kadek Dwi Arta</dd></div><div><dt>Estimasi</dt><dd>12 kg</dd></div></dl><Field label="Berat resmi (kg)" value={officialWeight} onChange={setOfficialWeight} /><SelectField label="Kualitas" value="Baik"><option>Baik</option><option>Cukup</option><option>Kurang</option></SelectField><div className="checklist"><span>Pemeriksaan kualitas</span>{["Tidak tercampur plastik", "Kadar air sesuai", "Sudah matang"].map((x) => <label key={x}><input type="checkbox" defaultChecked /> <span>{x}</span></label>)}</div><button className="upload-box"><Icon name="camera" />Foto bukti penimbangan.jpg</button><div className="points-preview"><span>Poin yang akan diberikan</span><strong>{Math.round(Number(officialWeight.replace(",", ".") || 0) * 10)} poin</strong><small>{officialWeight || 0} kg × 10 poin per kg</small></div>{stage !== "verified" && <><Button variant="primary" wide onClick={() => { setStage("verified"); setPoints(1355); }}>Terima dan berikan poin</Button><Button variant="danger" wide onClick={() => setReject(true)}>Tolak</Button></>}{reject && <div className="reject-box"><SelectField label="Alasan penolakan" value="Tercampur sampah anorganik"><option>Tercampur sampah anorganik</option><option>Kompos belum matang</option><option>Kadar air terlalu tinggi</option></SelectField><Button variant="danger" wide onClick={() => { setRejected(true); setReject(false); }}>Konfirmasi penolakan</Button></div>}</div></div>}</>;
  else if (active === "assign") content = <><PageHeader eyebrow="Operasional" title="Penugasan driver" /><div className="assignment-grid"><section><div className="section-heading"><h2>Belum ditugaskan</h2><span>3 penawaran</span></div>{[["KB-0415","Ni Kadek Sari","Baha Kaja · 15 kg"],["KB-0414","Ni Made Suriati","Baha Kelod · 11 kg"],["KB-0413","I Ketut Sudarma","Baha Kaja · 9 kg"]].map((o, i) => <div className="assignment-card" key={o[0]}><div><strong>{o[0]} · {o[1]}</strong><span>{o[2]}</span></div><Button variant={i === 0 && assigned ? "secondary" : "primary"} disabled={i === 0 && assigned} onClick={() => { if(i===0){setAssigned(true);setStage("assigned");} }}>{i === 0 && assigned ? "Ditugaskan" : "Tugaskan"}</Button></div>)}</section><section><div className="section-heading"><h2>Driver aktif</h2><span>3 tersedia</span></div>{[["Kadek Dwi Arta","3 tugas","Siap"],["I Ketut Budi","1 tugas","Siap"],["I Gede Arta","0 tugas","Siap"]].map((d) => <div className="driver-row" key={d[0]}><div className="avatar small">{d[0].split(" ").slice(-2).map(x=>x[0]).join("")}</div><div><strong>{d[0]}</strong><span>{d[1]} hari ini</span></div><span className="availability-label">{d[2]}</span></div>)}</section></div></>;
  else if (active === "suppliers") content = <><PageHeader eyebrow="Oktober 2026" title="Rekap pemasok" /><DataTable headers={["Warga", "Banjar", "Jumlah setoran", "Total kg", "Rata-rata kg", "Poin"]} rows={[["I Wayan Sudarta","Baha Kelod","3","38 kg","12,7 kg","380"],["Ni Luh Ayu Wulandari","Baha Kaja","4","45 kg","11,3 kg","450"],["I Ketut Merta","Baha Tengah","3","41 kg","13,7 kg","410"],["Putu Eka Pramana","Baha Kelod","2","23 kg","11,5 kg","230"]]} /></>;
  else content = <><PageHeader title="Pengaturan kuota" /><div className="settings-panel"><h2>Kuota penerimaan harian</h2><p>Atur batas kompos yang dapat diterima TPS 3R per hari.</p><Field label="Kuota Senin–Jumat (kg)" value="500" /><Field label="Kuota Sabtu (kg)" value="300" /><Button variant="primary">Simpan pengaturan</Button></div></>;
  return <DesktopShell role="tps" active={active} setActive={(v) => { setActive(v); setPanel(false); }} onExit={onExit}>{content}</DesktopShell>;
}

function AdminApp({ onExit }: { onExit: () => void }) {
  const [active, setActive] = useState("summary");
  const [pointsTab, setPointsTab] = useState("rate");
  const [complaint, setComplaint] = useState(false);
  const transactionRows = openOffers.slice(0, 5).map((r) => [r[0], r[1], r[2], `${r[3]} kg`, <Badge>{r[4]}</Badge>, r[5]]);
  let content: React.ReactNode;
  if (active === "summary") content = <><PageHeader eyebrow="25 Oktober 2026" title="Ringkasan layanan" /><div className="admin-stats">{[["Kg kompos terserap bulan ini","1.284 kg","+12% dari September"],["Warga aktif","186","dari 324 terdaftar"],["Rata-rata penjemputan","2,4 jam","target di bawah 3 jam"],["Poin ditukar","8.460","bulan berjalan"]].map((s) => <div className="admin-stat" key={s[0]}><span>{s[0]}</span><strong>{s[1]}</strong><small>{s[2]}</small></div>)}</div><div className="dashboard-grid"><section className="chart-card"><div className="section-heading"><div><h2>Kompos per minggu</h2><span>Oktober 2026 · kilogram</span></div><strong>1.284 kg</strong></div><div className="bar-chart">{[["M1",230],["M2",310],["M3",286],["M4",458]].map(([l,v]) => <div className="bar-column" key={l}><span>{v}</span><div style={{height:`${Number(v)/1.5}px`}} /><small>{l}</small></div>)}</div></section><section className="metric-list"><h2>Status layanan</h2><div><span>Menunggu driver</span><strong>3</strong></div><div><span>Dalam penjemputan</span><strong>4</strong></div><div><span>Menunggu verifikasi</span><strong>5</strong></div><div><span>Pengaduan terbuka</span><strong>2</strong></div></section></div><section className="section"><div className="section-heading"><h2>Transaksi terbaru</h2><button className="text-link" onClick={() => setActive("transactions")}>Lihat semua</button></div><DataTable headers={["Kode","Warga","Banjar","Estimasi","Status","Waktu"]} rows={transactionRows} /></section></>;
  else if (active === "transactions") content = <><PageHeader title="Transaksi" /><div className="filters"><SelectField label="Status"><option>Semua status</option></SelectField><SelectField label="Banjar"><option>Semua banjar</option></SelectField><Field label="Cari warga atau kode" placeholder="Masukkan kata kunci" /></div><DataTable headers={["Kode","Warga","Banjar","Estimasi","Status","Waktu"]} rows={transactionRows} /></>;
  else if (active === "users") content = <><PageHeader title="Pengguna" action={<Button variant="primary" icon="plus">Tambah pengguna</Button>} /><DataTable headers={["Nama","Peran","Banjar","Telepon","Status verifikasi","Tindakan"]} rows={[["I Wayan Sudarta","Warga","Baha Kelod","0812 3456 7812",<Badge>Poin diberikan</Badge>,<Button>Detail</Button>],["Ni Luh Ayu Wulandari","Warga","Baha Kaja","0813 7788 1209",<Badge>Menunggu konfirmasi</Badge>,<Button variant="primary">Verifikasi</Button>],["Kadek Dwi Arta","Driver","Baha Kelod","0812 8842 1976",<Badge>Poin diberikan</Badge>,<Button>Detail</Button>],["Komang Adi Putra","Driver","Baha Tengah","0819 4612 8401",<Badge>Poin diberikan</Badge>,<Button>Detail</Button>]]} /></>;
  else if (active === "points") content = <><PageHeader title="Poin dan hadiah" /><div className="tabs desktop-tabs"><button className={pointsTab==="rate"?"active":""} onClick={()=>setPointsTab("rate")}>Tarif poin dan ongkos</button><button className={pointsTab==="catalog"?"active":""} onClick={()=>setPointsTab("catalog")}>Katalog hadiah</button><button className={pointsTab==="redemption"?"active":""} onClick={()=>setPointsTab("redemption")}>Penukaran</button></div>{pointsTab==="rate" ? <div className="settings-panel wide"><div className="rate-box"><span>Tarif aktif</span><strong>10 poin / kg</strong><small>Berlaku sejak 1 Oktober 2026</small></div><h2>Aturan bonus</h2><p>Tambahan 20 poin untuk setoran kualitas Baik dengan berat minimal 15 kg.</p><h2>Riwayat versi</h2><DataTable headers={["Versi","Tarif","Aturan bonus","Tanggal efektif"]} rows={[["v2.1","10 poin/kg","+20 poin ≥ 15 kg","1 Okt 2026"],["v2.0","8 poin/kg","Tidak ada","1 Jul 2026"]]} /></div> : pointsTab==="catalog" ? <><div className="toolbar"><span>4 hadiah aktif</span><Button variant="primary" icon="plus">Tambah hadiah</Button></div><DataTable headers={["Hadiah","Stok","Harga poin","Status","Tindakan"]} rows={[["Bibit cabai","12","200","Aktif",<Button>Ubah</Button>],["Polybag 10 pcs","8","150","Aktif",<Button>Ubah</Button>],["Beras 5 kg","5","600","Aktif",<Button>Ubah</Button>],["Kopi Baha 250 g","0","350","Nonaktif",<Button>Ubah</Button>]]} /></> : <DataTable headers={["Kode","Warga","Hadiah","Poin","Tanggal","Tindakan"]} rows={[["KBH-8468","Ni Made Suriati","Sekop kebun","600","18 Okt 2026",<div className="table-actions"><Button variant="primary">Setujui</Button><Button variant="danger">Tolak</Button></div>],["KBH-8461","I Ketut Merta","Beras lokal 2 kg","1.000","17 Okt 2026",<div className="table-actions"><Button variant="primary">Setujui</Button><Button variant="danger">Tolak</Button></div>]]} />}</>;
  else if (active === "complaints") content = <><PageHeader title="Pengaduan" /><DataTable headers={["Nomor","Pelapor","Topik","Tanggal","Status"]} rows={[["PGD-018","Ni Luh Ayu Wulandari","Driver terlambat","18 Okt 2026",<Badge>Menunggu konfirmasi</Badge>],["PGD-017","I Made Ariasa","Poin belum masuk","17 Okt 2026",<Badge>Diterima TPS 3R</Badge>]]} onRow={() => setComplaint(true)} />{complaint && <div className="side-panel"><div className="panel-header"><div><div className="eyebrow">PGD-018</div><h2>Driver terlambat</h2></div><button className="icon-button" onClick={()=>setComplaint(false)}><Icon name="close"/></button></div><div className="panel-body"><p>Penjemputan dijadwalkan pukul 09.00–11.00, tetapi driver belum tiba sampai pukul 12.30.</p><Field label="Balasan kepada warga" placeholder="Tulis tanggapan resmi" /><Button variant="primary" wide>Kirim balasan</Button></div></div>}</>;
  else content = <><PageHeader title="Laporan" /><div className="report-controls"><Field label="Bulan laporan" type="month" value="2026-10" /><div><Button icon="file">Ekspor PDF</Button><Button icon="file">Ekspor CSV</Button></div></div><div className="admin-stats three"><div className="admin-stat"><span>Kompos terserap</span><strong>1.284 kg</strong><small>124 transaksi</small></div><div className="admin-stat"><span>Poin diterbitkan</span><strong>12.840</strong><small>senilai setoran terverifikasi</small></div><div className="admin-stat"><span>Poin ditukar</span><strong>8.460</strong><small>66% dari poin terbit</small></div></div><DataTable headers={["Banjar","Total kg","Setoran","Warga aktif","Poin terbit"]} rows={[["Baha Kelod","486 kg","44","68","4.860"],["Baha Kaja","421 kg","41","62","4.210"],["Baha Tengah","377 kg","39","56","3.770"]]} /></>;
  return <DesktopShell role="admin" active={active} setActive={setActive} onExit={onExit}>{content}</DesktopShell>;
}

export default function App() {
  const [role, setRole] = useState<Role | null>(null);
  const [wargaLoggedIn, setWargaLoggedIn] = useState(false);
  const [stage, setStage] = useState<OfferStage>("none");
  const [points, setPoints] = useState(1240);
  if (!role) return <StartScreen onRole={setRole} />;
  if (role === "warga" && !wargaLoggedIn) return <WargaLogin onLogin={() => setWargaLoggedIn(true)} onBack={() => setRole(null)} />;
  if (role === "warga") return <WargaApp stage={stage} setStage={setStage} points={points} setPoints={setPoints} onExit={() => setRole(null)} />;
  if (role === "driver") return <DriverApp stage={stage} setStage={setStage} onExit={() => setRole(null)} />;
  if (role === "tps") return <TpsApp stage={stage} setStage={setStage} setPoints={setPoints} onExit={() => setRole(null)} />;
  return <AdminApp onExit={() => setRole(null)} />;
}
