import type { Config } from 'tailwindcss';

const config: Config = {
  darkMode: 'class',
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        cinema: {
          950: '#030508',
          900: '#07090e',
          850: '#0c1018',
          800: '#121722',
          750: '#19202e',
          accent: '#e50914',
          gold: '#fbbf24',
          cyan: '#00e5ff',
          cyanHover: '#00b4d8',
          cyanGlow: '#70f3ff',
        },
        cyan: {
          300: '#70f3ff',
          400: '#00e5ff',
          500: '#00b8e6',
          600: '#008fb3',
        },
      },
      boxShadow: {
        'tv-glow': '0 0 40px rgba(0, 229, 255, 0.95)',
        'card-shadow': '0 12px 35px -10px rgba(0, 0, 0, 0.9)',
      },
    },
  },
  plugins: [],
};
export default config;
