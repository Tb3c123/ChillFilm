'use client';

import React from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';

export const NavbarMobile: React.FC = () => {
  const pathname = usePathname();

  const navItems = [
    { label: 'Trang Chủ', href: '/', icon: '🏠' },
    { label: 'Tìm Kiếm', href: '/search', icon: '🔍' },
    { label: 'Tủ Phim', href: '/library', icon: '🔖' },
  ];

  return (
    <nav className="md:hidden fixed bottom-0 left-0 right-0 z-50 bg-cinema-900/95 backdrop-blur border-t border-slate-800 flex justify-around items-center py-2">
      {navItems.map((item) => {
        const isActive = pathname === item.href;
        return (
          <Link
            key={item.href}
            href={item.href}
            className={`flex flex-col items-center space-y-1 text-xs ${
              isActive ? 'text-cyan-400 font-bold' : 'text-slate-400'
            }`}
          >
            <span className="text-base">{item.icon}</span>
            <span>{item.label}</span>
          </Link>
        );
      })}
    </nav>
  );
};
