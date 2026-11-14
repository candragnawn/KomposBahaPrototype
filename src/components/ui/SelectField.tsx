import React from "react"

export interface SelectFieldProps {
  label: string
  value?: string
  defaultValue?: string
  onChange?: (value: string) => void
  children: React.ReactNode
  className?: string
  disabled?: boolean
}

export function SelectField({
  label,
  value,
  defaultValue,
  onChange,
  children,
  className = "",
  disabled = false,
}: SelectFieldProps) {
  return (
    <label className={`field ${className}`.trim()}>
      <span>{label}</span>
      <select
        value={value}
        defaultValue={defaultValue}
        onChange={(e) => onChange?.(e.target.value)}
        disabled={disabled}
      >
        {children}
      </select>
    </label>
  )
}
