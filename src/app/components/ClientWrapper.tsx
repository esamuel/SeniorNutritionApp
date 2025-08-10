"use client";

import { LanguageProvider } from "../contexts/LanguageContext";

export default function ClientWrapper({ children }: { children: React.ReactNode }) {
  return (
    <LanguageProvider>
      {children}
    </LanguageProvider>
  );
} 