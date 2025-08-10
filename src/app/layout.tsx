import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import ClientWrapper from "./components/ClientWrapper";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  metadataBase: new URL('https://seniornutritionapp.com'),
  title: "Senior Nutrition App - Your Personal Health Companion",
  description: "Comprehensive health and wellness app designed specifically for adults aged 50 and above. Track nutrition, manage medications, monitor health metrics, and follow safe fasting protocols.",
  keywords: "senior nutrition, health tracking, medication management, fasting, wellness, aging, health app",
  authors: [{ name: "Senior Nutrition Team" }],
  openGraph: {
    title: "Senior Nutrition App - Your Personal Health Companion",
    description: "Comprehensive health and wellness app designed specifically for adults aged 50 and above.",
    url: "https://seniornutritionapp.com",
    siteName: "Senior Nutrition App",
    images: [
      {
        url: "/images/app-icon-large.png",
        width: 1024,
        height: 1024,
        alt: "Senior Nutrition App Icon",
      },
    ],
    locale: "en_US",
    type: "website",
  },
  twitter: {
    card: "summary_large_image",
    title: "Senior Nutrition App - Your Personal Health Companion",
    description: "Comprehensive health and wellness app designed specifically for adults aged 50 and above.",
    images: ["/images/app-icon-large.png"],
  },
  robots: {
    index: true,
    follow: true,
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <ClientWrapper>
          {children}
        </ClientWrapper>
      </body>
    </html>
  );
} 