"use client";

import Image from "next/image";
import LanguageSwitcher from "./LanguageSwitcher";
import { useState } from "react";
import { useLanguage } from "../contexts/LanguageContext";

export default function Navbar() {
  const { t } = useLanguage();
  const [menuOpen, setMenuOpen] = useState(false);

  return (
    <nav className="bg-white shadow-sm fixed w-full top-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between h-16">
          <div className="flex items-center">
            <a href="/" className="flex items-center space-x-3 hover:opacity-80 transition-opacity">
              <Image 
                src="/images/app-icon.png" 
                alt="Senior Nutrition App Icon" 
                width={40}
                height={40}
                className="rounded-lg shadow-sm"
              />
              <h1 className="text-xl font-bold text-gray-900">Senior Nutrition</h1>
            </a>
          </div>
          {/* Desktop Nav */}
          <div className="hidden md:flex items-center space-x-8">
            <a href="/#features" className="text-gray-700 hover:text-blue-600 transition-colors">{t('nav.features')}</a>
            <a href="/#health" className="text-gray-700 hover:text-blue-600 transition-colors">{t('nav.health')}</a>
            <a href="/#safety" className="text-gray-700 hover:text-blue-600 transition-colors">{t('nav.safety')}</a>
            <a href="/blog" className="text-gray-700 hover:text-blue-600 transition-colors">Blog</a>
            <LanguageSwitcher />
            <a href="/#download" className="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition-colors">{t('nav.download')}</a>
          </div>
          {/* Hamburger Icon for Mobile */}
          <div className="flex items-center md:hidden">
            <LanguageSwitcher />
            <button
              onClick={() => setMenuOpen(!menuOpen)}
              className="ml-2 inline-flex items-center justify-center p-2 rounded-md text-gray-700 hover:text-blue-600 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
              aria-label="Toggle main menu"
            >
              {menuOpen ? (
                <svg className="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                </svg>
              ) : (
                <svg className="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
                </svg>
              )}
            </button>
          </div>
        </div>
      </div>
      {/* Mobile Menu */}
      {menuOpen && (
        <div className="md:hidden bg-white shadow-lg border-t border-gray-100">
          <div className="flex flex-col items-start px-4 py-4 space-y-3">
            <a href="/#features" className="text-gray-700 hover:text-blue-600 transition-colors w-full py-2 px-2 rounded hover:bg-gray-50" onClick={() => setMenuOpen(false)}>{t('nav.features')}</a>
            <a href="/#health" className="text-gray-700 hover:text-blue-600 transition-colors w-full py-2 px-2 rounded hover:bg-gray-50" onClick={() => setMenuOpen(false)}>{t('nav.health')}</a>
            <a href="/#safety" className="text-gray-700 hover:text-blue-600 transition-colors w-full py-2 px-2 rounded hover:bg-gray-50" onClick={() => setMenuOpen(false)}>{t('nav.safety')}</a>
            <a href="/blog" className="text-gray-700 hover:text-blue-600 transition-colors w-full py-2 px-2 rounded hover:bg-gray-50" onClick={() => setMenuOpen(false)}>Blog</a>
            <div className="w-full py-2 border-t border-gray-100 mt-2 pt-4">
              <a href="/#download" className="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors w-full text-center block font-medium" onClick={() => setMenuOpen(false)}>{t('nav.download')}</a>
            </div>
          </div>
        </div>
      )}
    </nav>
  );
} 