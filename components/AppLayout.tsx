'use client'

import { Header } from './Header'
import { Sidebar } from './Sidebar'
import { BottomNav } from './BottomNav'
import { SidebarProvider } from '@/contexts/SidebarContext'

export function AppLayout({ children }: { children: React.ReactNode }) {
  return (
    <SidebarProvider>
      <div className="min-h-screen bg-bg-main">
        <Header />
        <Sidebar />
        {children}
        <BottomNav />
      </div>
    </SidebarProvider>
  )
}
