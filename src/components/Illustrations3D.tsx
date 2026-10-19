const baseProps = {
  role: "img",
  preserveAspectRatio: "xMidYMid meet",
} as const;

export function CompostBin() {
  return (
    <svg {...baseProps} aria-label="Tong kompos" viewBox="0 0 160 132">
      <defs>
        <linearGradient id="bin-main" x1="0" y1="0" x2="1" y2="1">
          <stop stopColor="#5AD5B2" />
          <stop offset=".55" stopColor="#19B28D" />
          <stop offset="1" stopColor="#0B6A4E" />
        </linearGradient>
        <linearGradient id="bin-lid" x1="0" y1="0" x2="0" y2="1">
          <stop stopColor="#B7F0DE" />
          <stop offset="1" stopColor="#37BF9C" />
        </linearGradient>
      </defs>
      <ellipse cx="82" cy="120" rx="54" ry="7" fill="#0B3D2E" opacity=".12" />
      <path d="M38 45h87l-8 64c-1 8-7 12-15 12H61c-8 0-14-4-15-12Z" fill="url(#bin-main)" />
      <path d="M103 45h22l-8 64c-1 8-7 12-15 12H91c8 0 13-5 14-12Z" fill="#075D45" opacity=".5" />
      <rect x="31" y="36" width="101" height="18" rx="7" fill="url(#bin-lid)" />
      <rect x="63" y="25" width="39" height="14" rx="5" fill="#0B7A5C" />
      <path d="M71 70c7-10 17-12 26-5-7 1-12 6-12 13 6-3 12-1 16 3-7 13-26 17-38 8-9-8-8-21-2-30 0 7 3 11 10 11Z" fill="#F7FFFC" />
      <path d="M64 90c9-10 18-15 31-20" fill="none" stroke="#0B7A5C" strokeWidth="3" strokeLinecap="round" />
      <path d="M27 25c10 0 17 5 20 15-10 1-18-4-20-15Z" fill="#79CC68" />
      <path d="M119 19c-10 2-15 8-16 18 10-1 16-7 16-18Z" fill="#4EBE75" />
      <path d="M44 28c7-8 15-9 22-2-6 7-13 8-22 2Z" fill="#F4B856" />
    </svg>
  );
}

export function PickupTruck() {
  return (
    <svg {...baseProps} aria-label="Truk penjemputan kompos" viewBox="0 0 180 112">
      <defs>
        <linearGradient id="truck-main" x1="0" y1="0" x2="1" y2="1">
          <stop stopColor="#56D2AF" />
          <stop offset=".58" stopColor="#159E79" />
          <stop offset="1" stopColor="#08634A" />
        </linearGradient>
      </defs>
      <ellipse cx="91" cy="99" rx="74" ry="7" fill="#0B3D2E" opacity=".12" />
      <path d="M18 30h91v58H18Z" fill="url(#truck-main)" />
      <path d="M30 19h67l12 11H18Z" fill="#91E4CC" />
      <path d="M109 49h38l24 22v17h-62Z" fill="#0B7A5C" />
      <path d="M120 56h23l16 15h-39Z" fill="#DDF3EC" />
      <path d="M17 82h154v10H17Z" fill="#07543F" />
      <circle cx="49" cy="91" r="14" fill="#173F35" />
      <circle cx="49" cy="91" r="6" fill="#DCEBE5" />
      <circle cx="143" cy="91" r="14" fill="#173F35" />
      <circle cx="143" cy="91" r="6" fill="#DCEBE5" />
      <path d="M55 49c6-9 16-11 24-5-6 1-10 6-10 11 5-2 10-1 14 4-7 11-24 15-34 6-8-7-7-18-2-26 0 6 3 10 8 10Z" fill="#F7FFFC" />
    </svg>
  );
}

export function GiftBox() {
  return (
    <svg {...baseProps} aria-label="Kotak hadiah" viewBox="0 0 140 120">
      <defs>
        <linearGradient id="gift-main" x1="0" y1="0" x2="1" y2="1">
          <stop stopColor="#6ADAB9" />
          <stop offset=".58" stopColor="#19B28D" />
          <stop offset="1" stopColor="#0B7658" />
        </linearGradient>
      </defs>
      <ellipse cx="70" cy="105" rx="44" ry="7" fill="#0B3D2E" opacity=".11" />
      <path d="M27 49h86v55H27Z" fill="url(#gift-main)" />
      <path d="M80 49h33v55H80Z" fill="#08664C" opacity=".42" />
      <rect x="20" y="39" width="100" height="19" rx="7" fill="#A7E9D6" />
      <path d="M63 39h16v65H63Z" fill="#F7FFFC" opacity=".8" />
      <path d="M70 39c-23-4-27-21-14-24 12-2 16 24 16 24ZM72 39c21-5 25-21 13-24-11-2-15 24-15 24Z" fill="#49C6A2" stroke="#0B7A5C" strokeWidth="3" />
      <path d="M43 76c7-10 17-11 25-5-7 1-11 6-11 12 6-3 11-1 15 3-7 12-24 15-34 7-8-7-7-19-2-27 0 6 3 9 7 10Z" fill="#F7FFFC" />
    </svg>
  );
}

export function LedgerCoin() {
  return (
    <svg {...baseProps} aria-label="Koin poin dan buku mutasi" viewBox="0 0 140 120">
      <defs>
        <linearGradient id="coin-main" x1="0" y1="0" x2="1" y2="1">
          <stop stopColor="#92E4CB" />
          <stop offset=".6" stopColor="#25BB94" />
          <stop offset="1" stopColor="#0B7658" />
        </linearGradient>
      </defs>
      <ellipse cx="72" cy="105" rx="44" ry="7" fill="#0B3D2E" opacity=".11" />
      <path d="M27 36h65c9 0 16 7 16 16v48H43c-9 0-16-7-16-16Z" fill="url(#coin-main)" />
      <path d="M38 36h8v64h-8c-6 0-11-5-11-11V47c0-6 5-11 11-11Z" fill="#087055" />
      <path d="M56 56h35M56 68h27M56 80h31" stroke="#EFFFF9" strokeWidth="4" strokeLinecap="round" opacity=".88" />
      <circle cx="101" cy="38" r="25" fill="#F2C765" />
      <circle cx="101" cy="38" r="18" fill="#FFD97E" stroke="#D99B2E" strokeWidth="3" />
      <path d="M93 39c5-7 11-8 17-4-5 1-8 4-8 8 4-2 7-1 10 2-5 8-16 10-23 4-6-5-5-13-1-18 0 4 2 7 5 8Z" fill="#0B7A5C" />
    </svg>
  );
}
