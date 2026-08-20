'use client';

import React, { Component, ErrorInfo, ReactNode } from 'react';

interface Props {
  children: ReactNode;
}

interface State {
  hasError: boolean;
  error: Error | null;
}

export class ErrorBoundary extends Component<Props, State> {
  public state: State = {
    hasError: false,
    error: null,
  };

  public static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  public componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    console.error('[ErrorBoundary] Uncaught application error:', error, errorInfo);
  }

  public render() {
    if (this.state.hasError) {
      return (
        <div className="min-h-screen bg-cinema-950 flex flex-col items-center justify-center p-6 text-center">
          <div className="max-w-md bg-cinema-900 border border-red-500/30 rounded-3xl p-8 space-y-4 shadow-2xl">
            <div className="w-16 h-16 bg-red-600/20 text-cinema-accent rounded-full flex items-center justify-center mx-auto text-3xl font-black">
              !
            </div>
            <h2 className="text-xl font-black text-white">Đã Xảy Ra Lỗi</h2>
            <p className="text-xs text-slate-300">
              {this.state.error?.message || 'Ứng dụng gặp sự cố ngoài dự kiến. Vui lòng kiểm tra lại kết nối mạng.'}
            </p>
            <button
              onClick={() => window.location.reload()}
              className="w-full bg-cinema-accent hover:bg-red-700 text-white font-bold py-3 rounded-xl shadow-lg transition"
            >
              Thử Lại Trực Tiếp
            </button>
          </div>
        </div>
      );
    }

    return this.props.children;
  }
}
