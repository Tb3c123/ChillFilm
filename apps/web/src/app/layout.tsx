import React from 'react';
import type { Metadata } from 'next';
import './globals.css';
import { ErrorBoundary } from '../components/common/ErrorBoundary';
import { Footer } from '../components/common/Footer';
import { NavbarMobile } from '../components/common/NavbarMobile';

export const metadata: Metadata = {
  title: 'ChillPhim - Xem Phim Online Chất Lượng Cao HD',
  description: 'ChillPhim - Trải nghiệm xem phim online đa nền tảng kết nối API phim.nguonc.com',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="vi" className="dark h-full">
      <head>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
      </head>
      <body className="bg-cinema-950 text-slate-100 antialiased min-h-screen flex flex-col pb-16 md:pb-0 font-sans">
        <ErrorBoundary>
          {children}
          <Footer />
          <NavbarMobile />
        </ErrorBoundary>
      </body>
    </html>
  );
}
