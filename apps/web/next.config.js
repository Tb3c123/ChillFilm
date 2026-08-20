/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  images: {
    unoptimized: true,
    remotePatterns: [
      {
        protocol: 'https',
        hostname: '**',
      },
    ],
  },
  async rewrites() {
    return [
      {
        source: '/api-proxy/:path*',
        destination: 'https://phim.nguonc.com/api/:path*',
      },
    ];
  },
};

module.exports = nextConfig;
