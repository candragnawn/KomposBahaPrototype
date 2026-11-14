import React from "react"

export interface FieldProps {
  label: string
  value?: string
  defaultValue?: string
  onChange?: (value: string) => void
  placeholder?: string
  type?: string
  helper?: string
  error?: string
  className?: string
  disabled?: boolean
}

export function Field({
  label,
  value,
  defaultValue,
  onChange,
  placeholder,
  type = "text",
  helper,
  error,
  className = "",
  disabled = false,
}: FieldProps) {
  return (
    <label className={`field ${className}`.trim()}>
      <span>{label}</span>
      <input
        type={type}
        value={value}
        defaultValue={defaultValue}
        onChange={(e) => onChange?.(e.target.value)}
        placeholder={placeholder}
        className={error ? "has-error" : ""}
        disabled={disabled}
      />
      {error ? (
        <small className="error">{error}</small>
      ) : helper ? (
        <small>{helper}</small>
      ) : null}
    </label>
  )
}
