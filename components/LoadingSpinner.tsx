export function LoadingSpinner() {
  return (
    <div className="flex items-center justify-center p-8">
      <div className="relative w-16 h-16">
        <div className="absolute inset-0 rounded-full border-4 border-brand-purple/20" />
        <div className="absolute inset-0 rounded-full border-4 border-transparent border-t-brand-purple animate-spin" />
      </div>
    </div>
  )
}

export function FullScreenLoader() {
  return (
    <div className="fixed inset-0 flex items-center justify-center bg-bg-main z-50">
      <div className="text-center">
        <LoadingSpinner />
        <p className="mt-4 text-white/70">Loading...</p>
      </div>
    </div>
  )
}
