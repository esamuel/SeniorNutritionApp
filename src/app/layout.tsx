import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  metadataBase: new URL('https://nextjs-r3t61183c-samuels-projects-a0907976.vercel.app'),
  title: 'Senior Nutrition App - Healthy Aging Made Simple',
  description: 'The complete nutrition and health tracking app designed specifically for adults 50+. Voice-guided meal logging, medication reminders, and personalized health insights.',
  keywords: 'senior nutrition, healthy aging, meal tracking, medication reminders, health monitoring, nutrition app for seniors',
  authors: [{ name: 'Senior Nutrition App Team' }],
  creator: 'Senior Nutrition App',
  publisher: 'Senior Nutrition App',
  formatDetection: {
    email: false,
    address: false,
    telephone: false,
  },
  icons: {
    icon: '/favicon.ico',
    apple: '/images/app-icon.png',
  },
  openGraph: {
    title: 'Senior Nutrition App - Healthy Aging Made Simple',
    description: 'The complete nutrition and health tracking app designed specifically for adults 50+. Voice-guided meal logging, medication reminders, and personalized health insights.',
    url: 'https://nextjs-r3t61183c-samuels-projects-a0907976.vercel.app',
    siteName: 'Senior Nutrition App',
    images: [
      {
        url: '/images/app-icon-large.png',
        width: 1024,
        height: 1024,
        alt: 'Senior Nutrition App Icon',
      },
    ],
    locale: 'en_US',
    type: 'website',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Senior Nutrition App - Healthy Aging Made Simple',
    description: 'The complete nutrition and health tracking app designed specifically for adults 50+.',
    images: ['/images/app-icon-large.png'],
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className={inter.className}>{children}</body>
    </html>
  )
} 