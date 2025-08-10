"use client";

import Image from "next/image";
import { useLanguage } from "./contexts/LanguageContext";
import LanguageSwitcher from "./components/LanguageSwitcher";
import { useState } from "react";
import Navbar from "./components/Navbar";

const handleImageError = (e: React.SyntheticEvent<HTMLImageElement, Event>) => {
  e.currentTarget.style.display = 'none';
  const nextElement = e.currentTarget.nextElementSibling as HTMLElement;
  if (nextElement) {
    nextElement.style.display = 'flex';
  }
};

export default function Home() {
  const { t, language } = useLanguage();
  const [menuOpen, setMenuOpen] = useState(false);

  return (
    <div className="min-h-screen bg-white">
      <Navbar />
      {/* Hero Section */}
      <section className="pt-24 pb-20 bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center">
            {/* App Icon Display */}
            <div className="mb-8">
              <Image 
                src="/images/app-icon.png" 
                alt="Senior Nutrition App Icon" 
                width={120}
                height={120}
                className="mx-auto rounded-3xl shadow-2xl"
              />
            </div>
            
            <h1 className="text-4xl md:text-6xl font-bold text-gray-900 mb-6">
              {t('hero.title.part1')}
              <span className="text-blue-600"> {t('hero.title.part2')}</span>
              <br />{t('hero.title.part3')}
            </h1>
            <p className="text-xl text-gray-600 mb-8 max-w-3xl mx-auto">
              {t('hero.subtitle')}
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center mb-12">
              <a href="#download" className="bg-blue-600 text-white px-8 py-4 rounded-lg font-medium hover:bg-blue-700 transition-colors text-lg">
                {t('hero.download')}
              </a>
              <a href="#features" className="border border-gray-300 text-gray-700 px-8 py-4 rounded-lg font-medium hover:bg-gray-50 transition-colors text-lg">
                {t('hero.explore')}
              </a>
            </div>
            
            {/* App Preview with Screenshots */}
            <div className="max-w-4xl mx-auto">
              <div className="bg-gray-900 rounded-2xl p-8 shadow-2xl">
                <div className="grid md:grid-cols-3 gap-6">
                  <div className="bg-white rounded-xl overflow-hidden shadow-lg">
                    <div className="h-64 bg-gradient-to-br from-green-100 to-green-200 flex items-center justify-center">
                      <Image 
                        src="/images/screenshots/nutrition-tracking.png" 
                        alt="Nutrition Tracking Screen" 
                        width={200}
                        height={400}
                        className="max-w-full max-h-full object-contain rounded-lg"
                        onError={handleImageError}
                      />
                      <div className="hidden flex-col items-center justify-center text-center p-4">
                        <div className="text-4xl mb-2">🍽️</div>
                        <p className="text-sm text-gray-600">Add nutrition-tracking.png screenshot here</p>
                      </div>
                    </div>
                    <div className="p-4 text-center">
                      <h3 className="font-semibold text-gray-900 mb-2">{t('features.nutrition.title')}</h3>
                      <p className="text-sm text-gray-600">Smart meal logging with nutritional analysis</p>
                    </div>
                  </div>
                  
                  <div className="bg-white rounded-xl overflow-hidden shadow-lg">
                    <div className="h-64 bg-gradient-to-br from-orange-100 to-orange-200 flex items-center justify-center">
                      <Image 
                        src="/images/screenshots/fasting-timer.png" 
                        alt="Fasting Timer Screen" 
                        width={200}
                        height={400}
                        className="max-w-full max-h-full object-contain rounded-lg"
                        onError={handleImageError}
                      />
                      <div className="hidden flex-col items-center justify-center text-center p-4">
                        <div className="text-4xl mb-2">⏱️</div>
                        <p className="text-sm text-gray-600">Add fasting-timer.png screenshot here</p>
                      </div>
                    </div>
                    <div className="p-4 text-center">
                      <h3 className="font-semibold text-gray-900 mb-2">{t('features.fasting.title')}</h3>
                      <p className="text-sm text-gray-600">Senior-friendly intermittent fasting protocols</p>
                    </div>
                  </div>
                  
                  <div className="bg-white rounded-xl overflow-hidden shadow-lg">
                    <div className="h-64 bg-gradient-to-br from-purple-100 to-purple-200 flex items-center justify-center">
                      <Image 
                        src="/images/screenshots/medication-management.png" 
                        alt="Medication Management Screen" 
                        width={200}
                        height={400}
                        className="max-w-full max-h-full object-contain rounded-lg"
                        onError={handleImageError}
                      />
                      <div className="hidden flex-col items-center justify-center text-center p-4">
                        <div className="text-4xl mb-2">💊</div>
                        <p className="text-sm text-gray-600">Add medication-management.png screenshot here</p>
                      </div>
                    </div>
                    <div className="p-4 text-center">
                      <h3 className="font-semibold text-gray-900 mb-2">{t('features.medication.title')}</h3>
                      <p className="text-sm text-gray-600">Visual pill identification and smart reminders</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Key Features Section */}
      <section id="features" className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">{t('features.title')}</h2>
            <p className="text-xl text-gray-600">{t('features.subtitle')}</p>
          </div>
          
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            {/* Nutrition Tracking */}
            <div className="bg-green-50 p-8 rounded-2xl hover:shadow-lg transition-shadow">
              <div className="flex items-center justify-between mb-6">
                <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center">
                  <span className="text-2xl">🍽️</span>
                </div>
                <div className="w-20 h-20 bg-white rounded-lg overflow-hidden shadow-sm">
                  <Image 
                    src="/images/screenshots/nutrition-tracking.png" 
                    alt="Nutrition Tracking Preview" 
                    width={80}
                    height={160}
                    className="w-full h-full object-cover"
                        onError={handleImageError}
                  />
                  <div className="hidden w-full h-full bg-gray-200 items-center justify-center">
                    <span className="text-xs text-gray-500">📸</span>
                  </div>
                </div>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-4">{t('features.nutrition.title')}</h3>
              <ul className="text-gray-600 space-y-2">
                <li>• {t('features.nutrition.photo')}</li>
                <li>• {t('features.nutrition.barcode')}</li>
                <li>• {t('features.nutrition.voice')}</li>
                <li>• {t('features.nutrition.analysis')}</li>
                <li>• {t('features.nutrition.recommendations')}</li>
              </ul>
            </div>

            {/* Fasting Timer */}
            <div className="bg-orange-50 p-8 rounded-2xl hover:shadow-lg transition-shadow">
              <div className="flex items-center justify-between mb-6">
                <div className="w-16 h-16 bg-orange-100 rounded-full flex items-center justify-center">
                  <span className="text-2xl">⏱️</span>
                </div>
                <div className="w-20 h-20 bg-white rounded-lg overflow-hidden shadow-sm">
                  <Image 
                    src="/images/screenshots/fasting-timer.png" 
                    alt="Fasting Timer Preview" 
                    width={80}
                    height={160}
                    className="w-full h-full object-cover"
                        onError={handleImageError}
                  />
                  <div className="hidden w-full h-full bg-gray-200 items-center justify-center">
                    <span className="text-xs text-gray-500">📸</span>
                  </div>
                </div>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-4">{t('features.fasting.title')}</h3>
              <ul className="text-gray-600 space-y-2">
                <li>• {t('features.fasting.options')}</li>
                <li>• {t('features.fasting.tracking')}</li>
                <li>• {t('features.fasting.emergency')}</li>
                <li>• {t('features.fasting.integration')}</li>
                <li>• {t('features.fasting.safety')}</li>
              </ul>
            </div>

            {/* Medication Management */}
            <div className="bg-purple-50 p-8 rounded-2xl hover:shadow-lg transition-shadow">
              <div className="flex items-center justify-between mb-6">
                <div className="w-16 h-16 bg-purple-100 rounded-full flex items-center justify-center">
                  <span className="text-2xl">💊</span>
                </div>
                <div className="w-20 h-20 bg-white rounded-lg overflow-hidden shadow-sm">
                  <Image 
                    src="/images/screenshots/medication-management.png" 
                    alt="Medication Management Preview" 
                    width={80}
                    height={160}
                    className="w-full h-full object-cover"
                        onError={handleImageError}
                  />
                  <div className="hidden w-full h-full bg-gray-200 items-center justify-center">
                    <span className="text-xs text-gray-500">📸</span>
                  </div>
                </div>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-4">{t('features.medication.title')}</h3>
              <ul className="text-gray-600 space-y-2">
                <li>• {t('features.medication.visual')}</li>
                <li>• {t('features.medication.reminders')}</li>
                <li>• {t('features.medication.schedule')}</li>
                <li>• {t('features.medication.interactions')}</li>
                <li>• {t('features.medication.export')}</li>
              </ul>
            </div>

            {/* Health Monitoring */}
            <div className="bg-blue-50 p-8 rounded-2xl hover:shadow-lg transition-shadow">
              <div className="flex items-center justify-between mb-6">
                <div className="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center">
                  <span className="text-2xl">❤️</span>
                </div>
                <div className="w-20 h-20 bg-white rounded-lg overflow-hidden shadow-sm">
                  <Image 
                    src="/images/screenshots/health-monitoring.png" 
                    alt="Health Monitoring Preview" 
                    width={80}
                    height={160}
                    className="w-full h-full object-cover"
                        onError={handleImageError}
                  />
                  <div className="hidden w-full h-full bg-gray-200 items-center justify-center">
                    <span className="text-xs text-gray-500">📸</span>
                  </div>
                </div>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-4">{t('features.health.title')}</h3>
              <ul className="text-gray-600 space-y-2">
                <li>• {t('features.health.blood')}</li>
                <li>• {t('features.health.heart')}</li>
                <li>• {t('features.health.weight')}</li>
                <li>• {t('features.health.sugar')}</li>
                <li>• {t('features.health.trends')}</li>
              </ul>
            </div>

            {/* Appointment Management */}
            <div className="bg-indigo-50 p-8 rounded-2xl hover:shadow-lg transition-shadow">
              <div className="flex items-center justify-between mb-6">
                <div className="w-16 h-16 bg-indigo-100 rounded-full flex items-center justify-center">
                  <span className="text-2xl">📅</span>
                </div>
                <div className="w-20 h-20 bg-white rounded-lg overflow-hidden shadow-sm">
                  <Image 
                    src="/images/screenshots/appointment-view.png" 
                    alt="Appointment Management Preview" 
                    width={80}
                    height={160}
                    className="w-full h-full object-cover"
                        onError={handleImageError}
                  />
                  <div className="hidden w-full h-full bg-gray-200 items-center justify-center">
                    <span className="text-xs text-gray-500">📸</span>
                  </div>
                </div>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-4">{t('features.appointments.title')}</h3>
              <ul className="text-gray-600 space-y-2">
                <li>• {t('features.appointments.schedule')}</li>
                <li>• {t('features.appointments.reminders')}</li>
                <li>• {t('features.appointments.notes')}</li>
                <li>• {t('features.appointments.export')}</li>
                <li>• {t('features.appointments.coordination')}</li>
              </ul>
            </div>

            {/* Voice Assistance */}
            <div className="bg-pink-50 p-8 rounded-2xl hover:shadow-lg transition-shadow">
              <div className="flex items-center justify-between mb-6">
                <div className="w-16 h-16 bg-pink-100 rounded-full flex items-center justify-center">
                  <span className="text-2xl">🎤</span>
                </div>
                <div className="w-20 h-20 bg-white rounded-lg overflow-hidden shadow-sm">
                  <Image 
                    src="/images/screenshots/home-screen.png" 
                    alt="Voice Assistance Preview" 
                    width={80}
                    height={160}
                    className="w-full h-full object-cover"
                        onError={handleImageError}
                  />
                  <div className="hidden w-full h-full bg-gray-200 items-center justify-center">
                    <span className="text-xs text-gray-500">📸</span>
                  </div>
                </div>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-4">Voice Assistance</h3>
              <ul className="text-gray-600 space-y-2">
                <li>• Multi-language support</li>
                <li>• Voice-guided meal logging</li>
                <li>• Hands-free medication reminders</li>
                <li>• Accessibility features</li>
                <li>• Senior-friendly voice commands</li>
              </ul>
            </div>
          </div>
        </div>
      </section>

      {/* Health Monitoring Section */}
      <section id="health" className="py-20 bg-gradient-to-r from-green-50 to-blue-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">{t('health.section.title')}</h2>
            <p className="text-xl text-gray-600">{t('health.section.subtitle')}</p>
          </div>
          
          <div className="grid md:grid-cols-2 gap-12 items-center">
            <div>
              <div className="space-y-6">
                <div className="flex items-start space-x-4">
                  <div className="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center flex-shrink-0">
                    <span className="text-xl">❤️</span>
                  </div>
                  <div>
                    <h3 className="text-xl font-bold text-gray-900 mb-2">{t('health.metric.blood_pressure.title')}</h3>
                    <p className="text-gray-600">{t('health.metric.blood_pressure.desc')}</p>
                  </div>
                </div>
                
                <div className="flex items-start space-x-4">
                  <div className="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center flex-shrink-0">
                    <span className="text-xl">💓</span>
                  </div>
                  <div>
                    <h3 className="text-xl font-bold text-gray-900 mb-2">{t('health.metric.heart_rate.title')}</h3>
                    <p className="text-gray-600">{t('health.metric.heart_rate.desc')}</p>
                  </div>
                </div>
                
                <div className="flex items-start space-x-4">
                  <div className="w-12 h-12 bg-purple-100 rounded-full flex items-center justify-center flex-shrink-0">
                    <span className="text-xl">⚖️</span>
                  </div>
                  <div>
                    <h3 className="text-xl font-bold text-gray-900 mb-2">{t('health.metric.weight.title')}</h3>
                    <p className="text-gray-600">{t('health.metric.weight.desc')}</p>
                  </div>
                </div>
                
                <div className="flex items-start space-x-4">
                  <div className="w-12 h-12 bg-orange-100 rounded-full flex items-center justify-center flex-shrink-0">
                    <span className="text-xl">🩸</span>
                  </div>
                  <div>
                    <h3 className="text-xl font-bold text-gray-900 mb-2">{t('health.metric.blood_sugar.title')}</h3>
                    <p className="text-gray-600">{t('health.metric.blood_sugar.desc')}</p>
                  </div>
                </div>
              </div>
            </div>
            
            <div className="bg-white rounded-2xl p-8 shadow-xl">
              <h3 className="text-2xl font-bold text-gray-900 mb-6">{t('health.summary.title')}</h3>
              
                  <div className="space-y-4">
                    <div className="flex justify-between items-center p-4 bg-red-50 rounded-lg">
                      <div className="flex items-center space-x-3">
                        <span className="text-red-600">❤️</span>
                    <span className="font-medium">{t('health.summary.blood_pressure')}</span>
                      </div>
                      <span className="font-bold text-red-600">120/80 mmHg</span>
                    </div>
                    
                    <div className="flex justify-between items-center p-4 bg-orange-50 rounded-lg">
                      <div className="flex items-center space-x-3">
                        <span className="text-orange-600">📊</span>
                    <span className="font-medium">{t('health.summary.heart_rate')}</span>
                      </div>
                      <span className="font-bold text-orange-600">72 BPM</span>
                    </div>
                    
                    <div className="flex justify-between items-center p-4 bg-blue-50 rounded-lg">
                      <div className="flex items-center space-x-3">
                        <span className="text-blue-600">⚖️</span>
                    <span className="font-medium">{t('health.summary.weight')}</span>
                      </div>
                      <span className="font-bold text-blue-600">75.2 kg</span>
                    </div>
                    
                    <div className="flex justify-between items-center p-4 bg-purple-50 rounded-lg">
                      <div className="flex items-center space-x-3">
                        <span className="text-purple-600">🩸</span>
                    <span className="font-medium">{t('health.summary.blood_sugar')}</span>
                      </div>
                      <span className="font-bold text-purple-600">95 mg/dL</span>
                    </div>
                  </div>
                  
                  <div className="mt-6 p-4 bg-green-50 rounded-lg">
                <p className="text-sm text-green-700 font-medium">✅ {t('health.summary.healthy')}</p>
              </div>
              </div>
              
              {/* Instructions for missing screenshot */}
              <div className="text-center text-gray-500 text-sm">
                <p>📸 Add <strong>health-monitoring.png</strong> screenshot to show actual health dashboard</p>
                <p className="mt-1">Screenshot should show: Blood pressure, heart rate, weight, and blood sugar tracking</p>
            </div>
          </div>
        </div>
      </section>

      {/* Safety & Senior Focus */}
      <section id="safety" className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">{t('safety.title')}</h2>
            <p className="text-xl text-gray-600">{t('safety.subtitle')}</p>
          </div>
          
          <div className="grid md:grid-cols-3 gap-8">
            <div className="text-center p-6">
              <div className="w-20 h-20 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-6">
                <span className="text-3xl">🛡️</span>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-4">{t('safety.emergency.title')}</h3>
              <p className="text-gray-600">{t('safety.emergency.desc')}</p>
            </div>
            
            <div className="text-center p-6">
              <div className="w-20 h-20 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-6">
                <span className="text-3xl">👨‍⚕️</span>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-4">{t('safety.healthcare.title')}</h3>
              <p className="text-gray-600">{t('safety.healthcare.desc')}</p>
            </div>
            
            <div className="text-center p-6">
              <div className="w-20 h-20 bg-purple-100 rounded-full flex items-center justify-center mx-auto mb-6">
                <span className="text-3xl">🔒</span>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-4">{t('safety.privacy.title')}</h3>
              <p className="text-gray-600">{t('safety.privacy.desc')}</p>
            </div>
          </div>
        </div>
      </section>

      {/* Language Support */}
      <section className="py-20 bg-gradient-to-r from-blue-50 to-indigo-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-6">{t('language.title')}</h2>
          <p className="text-xl text-gray-600 mb-12">{t('language.subtitle')}</p>
          
          <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
            <div className="bg-white p-6 rounded-xl shadow-sm">
              <div className="text-3xl mb-3">🇺🇸</div>
              <h3 className="font-semibold">{t('language.english')}</h3>
            </div>
            <div className="bg-white p-6 rounded-xl shadow-sm">
              <div className="text-3xl mb-3">🇮🇱</div>
              <h3 className="font-semibold">{t('language.hebrew')}</h3>
            </div>
            <div className="bg-white p-6 rounded-xl shadow-sm">
              <div className="text-3xl mb-3">🇫🇷</div>
              <h3 className="font-semibold">{t('language.french')}</h3>
            </div>
            <div className="bg-white p-6 rounded-xl shadow-sm">
              <div className="text-3xl mb-3">🇪🇸</div>
              <h3 className="font-semibold">{t('language.spanish')}</h3>
            </div>
          </div>
        </div>
      </section>

      {/* Download Section */}
      <section id="download" className="py-20 bg-gray-900 text-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl md:text-4xl font-bold mb-6">{t('download.title')}</h2>
          <p className="text-xl text-gray-300 mb-12">
            {t('download.subtitle')}
          </p>
          
          <div className="flex flex-col sm:flex-row gap-6 justify-center mb-12">
            <a 
              // href removed for Coming Soon
              className="bg-white text-gray-900 px-8 py-4 rounded-lg font-medium hover:bg-gray-100 transition-colors text-lg flex items-center justify-center space-x-3"
            >
              <span className="text-2xl">📱</span>
              <span>{t('download.button')}</span>
            </a>
          </div>
          
          <div className="grid md:grid-cols-3 gap-8 text-center">
            <div>
              <div className="text-3xl font-bold text-blue-400 mb-2">50+</div>
              <p className="text-gray-300">{t('download.age')}</p>
            </div>
            <div>
              <div className="text-3xl font-bold text-green-400 mb-2">4.8★</div>
              <p className="text-gray-300">{t('download.rating')}</p>
            </div>
            <div>
              <div className="text-3xl font-bold text-purple-400 mb-2">10K+</div>
              <p className="text-gray-300">{t('download.users')}</p>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-50 py-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid md:grid-cols-4 gap-8">
            <div>
              <div className="flex items-center space-x-3 mb-4">
                <img 
                  src="/images/app-icon.png" 
                  alt="Senior Nutrition App Icon" 
                  className="w-8 h-8 rounded-lg shadow-sm"
                />
                <h3 className="text-lg font-semibold text-gray-900">Senior Nutrition</h3>
              </div>
              <p className="text-gray-600">
                {t('footer.description')}
              </p>
            </div>
            
            <div>
              <h3 className="text-lg font-semibold text-gray-900 mb-4">{t('footer.features.title')}</h3>
              <ul className="space-y-2 text-gray-600">
                <li>{t('footer.features.nutrition')}</li>
                <li>{t('footer.features.fasting')}</li>
                <li>{t('footer.features.health')}</li>
                <li>{t('footer.features.medication')}</li>
                <li>{t('footer.features.appointments')}</li>
              </ul>
            </div>
            
            <div>
              <h3 className="text-lg font-semibold text-gray-900 mb-4">{t('footer.support.title')}</h3>
              <ul className="space-y-2 text-gray-600">
                <li>{t('footer.support.help')}</li>
                <li>{t('footer.support.tutorials')}</li>
                <li>{t('footer.support.contact')}</li>
                <li>{t('footer.support.privacy')}</li>
                <li>{t('footer.support.terms')}</li>
              </ul>
            </div>
            
            <div>
              <h3 className="text-lg font-semibold text-gray-900 mb-4">{t('footer.connect.title')}</h3>
              <ul className="space-y-2 text-gray-600">
                <li>support@seniornutrition.com</li>
                <li>+1 (800) 123-4567</li>
                <li>App Store Reviews</li>
                <li>Healthcare Providers</li>
              </ul>
            </div>
          </div>
          
          <div className="border-t border-gray-200 mt-8 pt-8 text-center text-gray-600">
            <p>{t('footer.copyright')}</p>
          </div>
        </div>
      </footer>
    </div>
  );
} 