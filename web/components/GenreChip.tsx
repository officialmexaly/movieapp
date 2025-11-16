'use client'

interface GenreChipProps {
  name: string
  selected?: boolean
  onClick?: () => void
}

export function GenreChip({ name, selected = false, onClick }: GenreChipProps) {
  return (
    <button
      onClick={onClick}
      className={`px-4 py-2 rounded-full text-sm font-medium transition-all whitespace-nowrap ${
        selected
          ? 'bg-gradient-brand text-white'
          : 'bg-bg-card text-white/70 hover:bg-bg-hover hover:text-white'
      }`}
    >
      {name}
    </button>
  )
}
