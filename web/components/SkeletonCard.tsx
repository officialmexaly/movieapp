export function SkeletonCard() {
  return (
    <div className="aspect-[2/3] rounded-lg overflow-hidden bg-bg-card skeleton" />
  )
}

export function SkeletonSection() {
  return (
    <div className="mb-12">
      <div className="h-8 w-48 bg-bg-card skeleton rounded mb-4" />
      <div className="flex gap-4 overflow-hidden px-4">
        {Array.from({ length: 6 }).map((_, i) => (
          <div key={i} className="flex-none w-40 md:w-48">
            <SkeletonCard />
          </div>
        ))}
      </div>
    </div>
  )
}
