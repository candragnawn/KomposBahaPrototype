import React from "react"

export interface DataTableProps {
  headers: string[]
  rows: React.ReactNode[][]
  onRow?: (index: number) => void
  emptyMessage?: string
}

export function DataTable({
  headers,
  rows,
  onRow,
  emptyMessage = "Tidak ada data.",
}: DataTableProps) {
  return (
    <div className="table-wrap">
      <table>
        <thead>
          <tr>
            {headers.map((h) => (
              <th key={h}>
                {h}
                <span className="sort">↕</span>
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.length === 0 ? (
            <tr>
              <td
                colSpan={headers.length}
                style={{
                  textAlign: "center",
                  padding: "24px",
                  color: "var(--muted)",
                }}
              >
                {emptyMessage}
              </td>
            </tr>
          ) : (
            rows.map((row, i) => (
              <tr
                key={i}
                onClick={() => onRow?.(i)}
                className={onRow ? "clickable" : ""}
              >
                {row.map((cell, j) => (
                  <td key={j}>{cell}</td>
                ))}
              </tr>
            ))
          )}
        </tbody>
      </table>
    </div>
  )
}
