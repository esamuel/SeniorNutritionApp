"use client";

import React, { createContext, useContext, useState, useEffect } from 'react';

export type Language = 'en' | 'he' | 'fr' | 'es';

interface LanguageContextType {
  language: Language;
  setLanguage: (lang: Language) => void;
  t: (key: string) => string;
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined);

// Translation data
const translations: Record<Language, Record<string, string>> = {
  en: {
    // Navigation
    'nav.features': 'Features',
    'nav.health': 'Health Tracking',
    'nav.safety': 'Safety',
    'nav.download': 'Download App',
    
    // Hero Section
    'hero.title.part1': 'Your Personal',
    'hero.title.part2': 'Nutrition Companion',
    'hero.title.part3': 'for Healthy Aging',
    'hero.subtitle': 'Senior Nutrition is a comprehensive health and wellness app designed specifically for adults aged 50 and above. Track nutrition, manage medications, monitor health metrics, and follow safe fasting protocols - all in one accessible app.',
    'hero.download': '📱 Download on App Store',
    'hero.explore': 'Explore Features',
    
    // Features Section
    'features.title': 'Comprehensive Health Management',
    'features.subtitle': 'Everything you need to maintain your health and independence as you age',
    'features.nutrition.title': 'Smart Nutrition Tracking',
    'features.nutrition.photo': 'Photo-based meal logging',
    'features.nutrition.barcode': 'Barcode scanner for packaged foods',
    'features.nutrition.voice': 'Voice input for hands-free recording',
    'features.nutrition.analysis': 'Personalized nutritional analysis',
    'features.nutrition.recommendations': 'Senior-specific dietary recommendations',
    
    'features.fasting.title': 'Safe Fasting Protocols',
    'features.fasting.options': 'Multiple fasting options (12:12, 14:10, 16:8)',
    'features.fasting.tracking': 'Real-time progress tracking',
    'features.fasting.emergency': 'Emergency override with one tap',
    'features.fasting.integration': 'Integration with medication schedules',
    'features.fasting.safety': 'Health safety monitoring',
    
    'features.medication.title': 'Medication Management',
    'features.medication.visual': 'Visual pill identification',
    'features.medication.reminders': 'Smart medication reminders',
    'features.medication.schedule': 'Flexible dosing schedules',
    'features.medication.interactions': 'Drug interaction warnings',
    'features.medication.export': 'Export for healthcare providers',
    
    'features.health.title': 'Health Monitoring',
    'features.health.blood': 'Blood pressure tracking',
    'features.health.heart': 'Heart rate monitoring',
    'features.health.weight': 'Weight management',
    'features.health.sugar': 'Blood sugar tracking',
    'features.health.trends': 'Health trend analysis',
    
    'features.appointments.title': 'Appointment Management',
    'features.appointments.schedule': 'Schedule medical appointments',
    'features.appointments.reminders': 'Smart appointment reminders',
    'features.appointments.notes': 'Pre-visit preparation notes',
    'features.appointments.export': 'Export health data for visits',
    'features.appointments.coordination': 'Healthcare coordination',
    
    // Safety Section
    'safety.title': 'Safety First, Always',
    'safety.subtitle': 'Designed specifically for seniors with safety features and emergency protocols',
    'safety.emergency.title': 'Emergency Override',
    'safety.emergency.desc': 'One-tap emergency override for fasting protocols when you need immediate nutrition or medication',
    'safety.healthcare.title': 'Healthcare Integration',
    'safety.healthcare.desc': 'Export all your health data to share with doctors and healthcare providers for better care coordination',
    'safety.privacy.title': 'Privacy Protection',
    'safety.privacy.desc': 'Your health data stays on your device. Encrypted, secure, and never shared with third parties without your consent',
    
    // Language Section
    'language.title': 'Available in Multiple Languages',
    'language.subtitle': 'Designed to serve diverse communities with full language support',
    'language.english': 'English',
    'language.hebrew': 'Hebrew',
    'language.french': 'French',
    'language.spanish': 'Spanish',
    
    // Download Section
    'download.title': 'Ready to Start Your Health Journey?',
    'download.subtitle': 'Download Senior Nutrition today and take control of your health with confidence',
    'download.button': 'Coming Soon',
    'download.age': 'Age range designed for',
    'download.rating': 'Average user rating',
    'download.users': 'Happy users',
    
    // Footer
    'footer.description': 'Your comprehensive health companion designed specifically for seniors, supporting healthy aging through personalized nutrition and wellness tracking.',
    'footer.features.title': 'Features',
    'footer.features.nutrition': 'Nutrition Tracking',
    'footer.features.fasting': 'Fasting Protocols',
    'footer.features.health': 'Health Monitoring',
    'footer.features.medication': 'Medication Management',
    'footer.features.appointments': 'Appointment Scheduling',
    'footer.support.title': 'Support',
    'footer.support.help': 'Help Center',
    'footer.support.tutorials': 'Video Tutorials',
    'footer.support.contact': 'Contact Support',
    'footer.support.privacy': 'Privacy Policy',
    'footer.support.terms': 'Terms of Service',
    'footer.connect.title': 'Connect',
    'footer.copyright': '© 2024 Senior Nutrition App. All rights reserved. Designed for healthy aging with safety and accessibility in mind.',

    // Health Tracking Section
    'health.section.title': 'Comprehensive Health Tracking',
    'health.section.subtitle': 'Monitor all your vital health metrics in one place with senior-friendly interfaces',
    'health.metric.blood_pressure.title': 'Blood Pressure Monitoring',
    'health.metric.blood_pressure.desc': 'Track systolic and diastolic readings with trend analysis and alerts for abnormal values',
    'health.metric.heart_rate.title': 'Heart Rate Tracking',
    'health.metric.heart_rate.desc': 'Monitor resting and active heart rates with personalized target zones',
    'health.metric.weight.title': 'Weight Management',
    'health.metric.weight.desc': 'Track weight changes with goal setting and progress visualization',
    'health.metric.blood_sugar.title': 'Blood Sugar Monitoring',
    'health.metric.blood_sugar.desc': 'Log glucose readings with meal correlation and trend analysis',
    'health.summary.title': "Today's Health Summary",
    'health.summary.blood_pressure': 'Blood Pressure',
    'health.summary.heart_rate': 'Heart Rate',
    'health.summary.weight': 'Weight',
    'health.summary.blood_sugar': 'Blood Sugar',
    'health.summary.healthy': 'All readings within healthy ranges',
  },
  
  he: {
    // Navigation
    'nav.features': 'תכונות',
    'nav.health': 'מעקב בריאות',
    'nav.safety': 'בטיחות',
    'nav.download': 'הורד אפליקציה',
    
    // Hero Section
    'hero.title.part1': 'המלווה התזונתי',
    'hero.title.part2': 'האישי שלך',
    'hero.title.part3': 'להזדקנות בריאה',
    'hero.subtitle': 'תזונה לגיל השלישי היא אפליקציה מקיפה לבריאות ורווחה המיועדת במיוחד למבוגרים בני 50 ומעלה. עקוב אחר תזונה, נהל תרופות, בדוק מדדי בריאות ועקוב אחר פרוטוקולי צום בטוחים - הכל באפליקציה נגישה אחת.',
    'hero.download': '📱 הורד ב-App Store',
    'hero.explore': 'חקור תכונות',
    
    // Features Section
    'features.title': 'ניהול בריאות מקיף',
    'features.subtitle': 'כל מה שצריך לשמור על הבריאות והעצמאות שלך ככל שאתה מזדקן',
    'features.nutrition.title': 'מעקב תזונה חכם',
    'features.nutrition.photo': 'תיעוד ארוחות מבוסס תמונות',
    'features.nutrition.barcode': 'סריקת ברקוד למזון ארוז',
    'features.nutrition.voice': 'קלט קולי לתיעוד ללא ידיים',
    'features.nutrition.analysis': 'ניתוח תזונתי מותאם אישית',
    'features.nutrition.recommendations': 'המלצות תזונתיות מותאמות לגיל השלישי',
    
    'features.fasting.title': 'פרוטוקולי צום בטוחים',
    'features.fasting.options': 'אפשרויות צום מרובות (12:12, 14:10, 16:8)',
    'features.fasting.tracking': 'מעקב התקדמות בזמן אמת',
    'features.fasting.emergency': 'עקיפה חירום בלחיצה אחת',
    'features.fasting.integration': 'אינטגרציה עם לוחות זמנים לתרופות',
    'features.fasting.safety': 'ניטור בטיחות בריאות',
    
    'features.medication.title': 'ניהול תרופות',
    'features.medication.visual': 'זיהוי גלולות חזותי',
    'features.medication.reminders': 'תזכורות תרופות חכמות',
    'features.medication.schedule': 'לוחות זמנים גמישים למינון',
    'features.medication.interactions': 'אזהרות אינטראקציות תרופות',
    'features.medication.export': 'ייצוא לספקי שירותי בריאות',
    
    'features.health.title': 'ניטור בריאות',
    'features.health.blood': 'מעקב לחץ דם',
    'features.health.heart': 'ניטור קצב לב',
    'features.health.weight': 'ניהול משקל',
    'features.health.sugar': 'מעקב סוכר בדם',
    'features.health.trends': 'ניתוח מגמות בריאות',
    
    'features.appointments.title': 'ניהול פגישות',
    'features.appointments.schedule': 'תזמן פגישות רפואיות',
    'features.appointments.reminders': 'תזכורות פגישות חכמות',
    'features.appointments.notes': 'הערות הכנה לפני ביקור',
    'features.appointments.export': 'ייצוא נתוני בריאות לביקורים',
    'features.appointments.coordination': 'תיאום שירותי בריאות',
    
    // Safety Section
    'safety.title': 'בטיחות קודמת לכל',
    'safety.subtitle': 'עוצב במיוחד עבור גיל השלישי עם תכונות בטיחות ופרוטוקולי חירום',
    'safety.emergency.title': 'עקיפה חירום',
    'safety.emergency.desc': 'עקיפה חירום בלחיצה אחת לפרוטוקולי צום כאשר אתה צריך תזונה או תרופות מיידיות',
    'safety.healthcare.title': 'אינטגרציה עם שירותי בריאות',
    'safety.healthcare.desc': 'ייצא את כל נתוני הבריאות שלך לשיתוף עם רופאים וספקי שירותי בריאות לתיאום טיפול טוב יותר',
    'safety.privacy.title': 'הגנת פרטיות',
    'safety.privacy.desc': 'נתוני הבריאות שלך נשארים במכשיר שלך. מוצפנים, מאובטחים ולעולם לא משותפים עם צדדים שלישיים ללא הסכמתך',
    
    // Language Section
    'language.title': 'זמין במספר שפות',
    'language.subtitle': 'עוצב לשרת קהילות מגוונות עם תמיכה מלאה בשפה',
    'language.english': 'English',
    'language.hebrew': 'עברית',
    'language.french': 'Français',
    'language.spanish': 'Español',
    
    // Download Section
    'download.title': 'מוכן להתחיל את מסע הבריאות שלך?',
    'download.subtitle': 'הורד תזונה לגיל השלישי היום וקח שליטה על הבריאות שלך בביטחון',
    'download.button': 'בקרוב',
    'download.age': 'טווח גילאים שעוצב עבור',
    'download.rating': 'דירוג ממוצע של משתמשים',
    'download.users': 'משתמשים מרוצים',
    
    // Footer
    'footer.description': 'המלווה המקיף שלך לבריאות המיועד במיוחד לגיל השלישי, תומך בהזדקנות בריאה באמצעות תזונה מותאמת אישית ומעקב רווחה.',
    'footer.features.title': 'תכונות',
    'footer.features.nutrition': 'מעקב תזונה',
    'footer.features.fasting': 'פרוטוקולי צום',
    'footer.features.health': 'ניטור בריאות',
    'footer.features.medication': 'ניהול תרופות',
    'footer.features.appointments': 'תזמון פגישות',
    'footer.support.title': 'תמיכה',
    'footer.support.help': 'מרכז עזרה',
    'footer.support.tutorials': 'סרטוני הדרכה',
    'footer.support.contact': 'צור קשר עם תמיכה',
    'footer.support.privacy': 'מדיניות פרטיות',
    'footer.support.terms': 'תנאי שירות',
    'footer.connect.title': 'התחבר',
    'footer.copyright': '© 2024 אפליקציית תזונה לגיל השלישי. כל הזכויות שמורות. עוצב להזדקנות בריאה עם בטיחות ונגישות במחשבה.',

    // Health Tracking Section
    'health.section.title': 'מעקב בריאות מקיף',
    'health.section.subtitle': 'עקוב אחר כל מדדי הבריאות החיוניים שלך במקום אחד עם ממשקים ידידותיים לגיל השלישי',
    'health.metric.blood_pressure.title': 'מעקב לחץ דם',
    'health.metric.blood_pressure.desc': 'עקוב אחר ערכי סיסטולי ודיאסטולי עם ניתוח מגמות והתראות לערכים חריגים',
    'health.metric.heart_rate.title': 'מעקב קצב לב',
    'health.metric.heart_rate.desc': 'ניטור קצב לב במנוחה ובפעילות עם טווחי יעד מותאמית',
    'health.metric.weight.title': 'ניהול משקל',
    'health.metric.weight.desc': 'עקוב אחר שינויים במשקל עם קביעת יעדים והמחשת התקדמות',
    'health.metric.blood_sugar.title': 'מעקב סוכר בדם',
    'health.metric.blood_sugar.desc': 'רשום ערכי סוכר עם קשר לארוחות וניתוח מגמות',
    'health.summary.title': 'סיכום בריאות להיום',
    'health.summary.blood_pressure': 'לחץ דם',
    'health.summary.heart_rate': 'קצב לב',
    'health.summary.weight': 'משקל',
    'health.summary.blood_sugar': 'סוכר בדם',
    'health.summary.healthy': 'כל הערכים בטווחים בריאים',
  },
  
  fr: {
    // Navigation
    'nav.features': 'Fonctionnalités',
    'nav.health': 'Suivi Santé',
    'nav.safety': 'Sécurité',
    'nav.download': 'Télécharger l\'App',
    
    // Hero Section
    'hero.title.part1': 'Votre Compagnon',
    'hero.title.part2': 'Nutritionnel Personnel',
    'hero.title.part3': 'pour un Vieillissement Sain',
    'hero.subtitle': 'Nutrition Senior est une application complète de santé et de bien-être conçue spécifiquement pour les adultes de 50 ans et plus. Suivez la nutrition, gérez les médicaments, surveillez les métriques de santé et suivez des protocoles de jeûne sûrs - le tout dans une application accessible.',
    'hero.download': '📱 Télécharger sur l\'App Store',
    'hero.explore': 'Explorer les Fonctionnalités',
    
    // Features Section
    'features.title': 'Gestion Complète de la Santé',
    'features.subtitle': 'Tout ce dont vous avez besoin pour maintenir votre santé et votre indépendance en vieillissant',
    'features.nutrition.title': 'Suivi Nutritionnel Intelligent',
    'features.nutrition.photo': 'Enregistrement de repas basé sur la photo',
    'features.nutrition.barcode': 'Scanner de code-barres pour les aliments emballés',
    'features.nutrition.voice': 'Saisie vocale pour l\'enregistrement mains libres',
    'features.nutrition.analysis': 'Analyse nutritionnelle personnalisée',
    'features.nutrition.recommendations': 'Recommandations diététiques spécifiques aux seniors',
    
    'features.fasting.title': 'Protocoles de Jeûne Sûrs',
    'features.fasting.options': 'Options de jeûne multiples (12:12, 14:10, 16:8)',
    'features.fasting.tracking': 'Suivi des progrès en temps réel',
    'features.fasting.emergency': 'Contournement d\'urgence en un tap',
    'features.fasting.integration': 'Intégration avec les horaires de médicaments',
    'features.fasting.safety': 'Surveillance de la sécurité sanitaire',
    
    'features.medication.title': 'Gestion des Médicaments',
    'features.medication.visual': 'Identification visuelle des pilules',
    'features.medication.reminders': 'Rappels de médicaments intelligents',
    'features.medication.schedule': 'Horaires de dosage flexibles',
    'features.medication.interactions': 'Avertissements d\'interactions médicamenteuses',
    'features.medication.export': 'Export pour les fournisseurs de soins de santé',
    
    'features.health.title': 'Surveillance de la Santé',
    'features.health.blood': 'Suivi de la tension artérielle',
    'features.health.heart': 'Surveillance du rythme cardiaque',
    'features.health.weight': 'Gestion du poids',
    'features.health.sugar': 'Suivi de la glycémie',
    'features.health.trends': 'Analyse des tendances de santé',
    
    'features.appointments.title': 'Gestion des Rendez-vous',
    'features.appointments.schedule': 'Planifier des rendez-vous médicaux',
    'features.appointments.reminders': 'Rappels de rendez-vous intelligents',
    'features.appointments.notes': 'Notes de préparation avant visite',
    'features.appointments.export': 'Exporter les données de santé pour les visites',
    'features.appointments.coordination': 'Coordination des soins de santé',
    
    // Safety Section
    'safety.title': 'La Sécurité d\'Abord, Toujours',
    'safety.subtitle': 'Conçu spécifiquement pour les seniors avec des fonctionnalités de sécurité et des protocoles d\'urgence',
    'safety.emergency.title': 'Contournement d\'Urgence',
    'safety.emergency.desc': 'Contournement d\'urgence en un tap pour les protocoles de jeûne lorsque vous avez besoin de nutrition ou de médicaments immédiats',
    'safety.healthcare.title': 'Intégration des Soins de Santé',
    'safety.healthcare.desc': 'Exportez toutes vos données de santé pour les partager avec les médecins et les fournisseurs de soins de santé pour une meilleure coordination des soins',
    'safety.privacy.title': 'Protection de la Vie Privée',
    'safety.privacy.desc': 'Vos données de santé restent sur votre appareil. Chiffrées, sécurisées et jamais partagées avec des tiers sans votre consentement',
    
    // Language Section
    'language.title': 'Disponible en Plusieurs Langues',
    'language.subtitle': 'Conçu pour servir des communautés diverses avec un support linguistique complet',
    'language.english': 'English',
    'language.hebrew': 'עברית',
    'language.french': 'Français',
    'language.spanish': 'Español',
    
    // Download Section
    'download.title': 'Prêt à Commencer Votre Voyage de Santé?',
    'download.subtitle': 'Téléchargez Nutrition Senior aujourd\'hui et prenez le contrôle de votre santé avec confiance',
    'download.button': 'Bientôt disponible',
    'download.age': 'Tranche d\'âge conçue pour',
    'download.rating': 'Note moyenne des utilisateurs',
    'download.users': 'Utilisateurs satisfaits',
    
    // Footer
    'footer.description': 'Votre compagnon de santé complet conçu spécifiquement pour les seniors, soutenant un vieillissement sain grâce à un suivi nutritionnel et de bien-être personnalisé.',
    'footer.features.title': 'Fonctionnalités',
    'footer.features.nutrition': 'Suivi Nutritionnel',
    'footer.features.fasting': 'Protocoles de Jeûne',
    'footer.features.health': 'Surveillance de la Santé',
    'footer.features.medication': 'Gestion des Médicaments',
    'footer.features.appointments': 'Planification de Rendez-vous',
    'footer.support.title': 'Support',
    'footer.support.help': 'Centre d\'Aide',
    'footer.support.tutorials': 'Tutoriels Vidéo',
    'footer.support.contact': 'Contacter le Support',
    'footer.support.privacy': 'Politique de Confidentialité',
    'footer.support.terms': 'Conditions de Service',
    'footer.connect.title': 'Se Connecter',
    'footer.copyright': '© 2024 Application Nutrition Senior. Tous droits réservés. Conçu pour un vieillissement sain avec sécurité et accessibilité à l\'esprit.',

    // Health Tracking Section
    'health.section.title': 'Suivi Santé Complet',
    'health.section.subtitle': 'Surveillez tous vos indicateurs de santé essentiels en un seul endroit avec des interfaces adaptées aux seniors',
    'health.metric.blood_pressure.title': 'Surveillance de la Tension Artérielle',
    'health.metric.blood_pressure.desc': 'Suivez les valeurs systoliques et diastoliques avec analyse des tendances et alertes pour valeurs anormales',
    'health.metric.heart_rate.title': 'Suivi de la Fréquence Cardiaque',
    'health.metric.heart_rate.desc': 'Surveillez la fréquence cardiaque au repos et à l’effort avec des zones cibles personnalisées',
    'health.metric.weight.title': 'Gestion du Poids',
    'health.metric.weight.desc': 'Suivez les variations de poids avec définition d’objectifs et visualisation des progrès',
    'health.metric.blood_sugar.title': 'Surveillance de la Glycémie',
    'health.metric.blood_sugar.desc': 'Enregistrez les valeurs de glycémie avec corrélation aux repas et analyse des tendances',
    'health.summary.title': 'Résumé Santé du Jour',
    'health.summary.blood_pressure': 'Tension Artérielle',
    'health.summary.heart_rate': 'Fréquence Cardiaque',
    'health.summary.weight': 'Poids',
    'health.summary.blood_sugar': 'Glycémie',
    'health.summary.healthy': 'Toutes les valeurs sont dans les plages saines',
  },
  
  es: {
    // Navigation
    'nav.features': 'Características',
    'nav.health': 'Seguimiento de Salud',
    'nav.safety': 'Seguridad',
    'nav.download': 'Descargar App',
    
    // Hero Section
    'hero.title.part1': 'Tu Compañero',
    'hero.title.part2': 'Nutricional Personal',
    'hero.title.part3': 'para un Envejecimiento Saludable',
    'hero.subtitle': 'Nutrición Senior es una aplicación integral de salud y bienestar diseñada específicamente para adultos de 50 años y más. Rastrea la nutrición, gestiona medicamentos, monitorea métricas de salud y sigue protocolos de ayuno seguros - todo en una aplicación accesible.',
    'hero.download': '📱 Descargar en App Store',
    'hero.explore': 'Explorar Características',
    
    // Features Section
    'features.title': 'Gestión Integral de la Salud',
    'features.subtitle': 'Todo lo que necesitas para mantener tu salud e independencia mientras envejeces',
    'features.nutrition.title': 'Seguimiento Nutricional Inteligente',
    'features.nutrition.photo': 'Registro de comidas basado en fotos',
    'features.nutrition.barcode': 'Escáner de código de barras para alimentos empaquetados',
    'features.nutrition.voice': 'Entrada de voz para grabación manos libres',
    'features.nutrition.analysis': 'Análisis nutricional personalizado',
    'features.nutrition.recommendations': 'Recomendaciones dietéticas específicas para adultos mayores',
    
    'features.fasting.title': 'Protocolos de Ayuno Seguros',
    'features.fasting.options': 'Múltiples opciones de ayuno (12:12, 14:10, 16:8)',
    'features.fasting.tracking': 'Seguimiento de progreso en tiempo real',
    'features.fasting.emergency': 'Anulación de emergencia con un toque',
    'features.fasting.integration': 'Integración con horarios de medicamentos',
    'features.fasting.safety': 'Monitoreo de seguridad de salud',
    
    'features.medication.title': 'Gestión de Medicamentos',
    'features.medication.visual': 'Identificación visual de píldoras',
    'features.medication.reminders': 'Recordatorios inteligentes de medicamentos',
    'features.medication.schedule': 'Horarios de dosificación flexibles',
    'features.medication.interactions': 'Advertencias de interacciones medicamentosas',
    'features.medication.export': 'Exportar para proveedores de atención médica',
    
    'features.health.title': 'Monitoreo de Salud',
    'features.health.blood': 'Seguimiento de presión arterial',
    'features.health.heart': 'Monitoreo de frecuencia cardíaca',
    'features.health.weight': 'Gestión de peso',
    'features.health.sugar': 'Seguimiento de azúcar en sangre',
    'features.health.trends': 'Análisis de tendencias de salud',
    
    'features.appointments.title': 'Gestión de Citas',
    'features.appointments.schedule': 'Programar citas médicas',
    'features.appointments.reminders': 'Recordatorios inteligentes de citas',
    'features.appointments.notes': 'Notas de preparación previa a la visita',
    'features.appointments.export': 'Exportar datos de salud para visitas',
    'features.appointments.coordination': 'Coordinación de atención médica',
    
    // Safety Section
    'safety.title': 'Seguridad Primero, Siempre',
    'safety.subtitle': 'Diseñado específicamente para adultos mayores con características de seguridad y protocolos de emergencia',
    'safety.emergency.title': 'Anulación de Emergencia',
    'safety.emergency.desc': 'Anulación de emergencia con un toque para protocolos de ayuno cuando necesitas nutrición o medicamentos inmediatos',
    'safety.healthcare.title': 'Integración de Atención Médica',
    'safety.healthcare.desc': 'Exporta todos tus datos de salud para compartir con médicos y proveedores de atención médica para una mejor coordinación de cuidados',
    'safety.privacy.title': 'Protección de Privacidad',
    'safety.privacy.desc': 'Tus datos de salud permanecen en tu dispositivo. Encriptados, seguros y nunca compartidos con terceros sin tu consentimiento',
    
    // Language Section
    'language.title': 'Disponible en Múltiples Idiomas',
    'language.subtitle': 'Diseñado para servir a comunidades diversas con soporte lingüístico completo',
    'language.english': 'English',
    'language.hebrew': 'עברית',
    'language.french': 'Français',
    'language.spanish': 'Español',
    
    // Download Section
    'download.title': '¿Listo para Comenzar tu Viaje de Salud?',
    'download.subtitle': 'Descarga Nutrición Senior hoy y toma el control de tu salud con confianza',
    'download.button': 'Próximamente',
    'download.age': 'Rango de edad diseñado para',
    'download.rating': 'Calificación promedio de usuarios',
    'download.users': 'Usuarios felices',
    
    // Footer
    'footer.description': 'Tu compañero de salud integral diseñado específicamente para adultos mayores, apoyando el envejecimiento saludable a través del seguimiento nutricional y de bienestar personalizado.',
    'footer.features.title': 'Características',
    'footer.features.nutrition': 'Seguimiento Nutricional',
    'footer.features.fasting': 'Protocolos de Ayuno',
    'footer.features.health': 'Monitoreo de Salud',
    'footer.features.medication': 'Gestión de Medicamentos',
    'footer.features.appointments': 'Programación de Citas',
    'footer.support.title': 'Soporte',
    'footer.support.help': 'Centro de Ayuda',
    'footer.support.tutorials': 'Tutoriales en Video',
    'footer.support.contact': 'Contactar Soporte',
    'footer.support.privacy': 'Política de Privacidad',
    'footer.support.terms': 'Términos de Servicio',
    'footer.connect.title': 'Conectar',
    'footer.copyright': '© 2024 Aplicación Nutrición Senior. Todos los derechos reservados. Diseñado para envejecimiento saludable con seguridad y accesibilidad en mente.',

    // Health Tracking Section
    'health.section.title': 'Seguimiento Integral de la Salud',
    'health.section.subtitle': 'Monitorea todas tus métricas vitales de salud en un solo lugar con interfaces amigables para personas mayores',
    'health.metric.blood_pressure.title': 'Monitoreo de la Presión Arterial',
    'health.metric.blood_pressure.desc': 'Registra valores sistólicos y diastólicos con análisis de tendencias y alertas para valores anormales',
    'health.metric.heart_rate.title': 'Seguimiento de la Frecuencia Cardíaca',
    'health.metric.heart_rate.desc': 'Monitorea la frecuencia cardíaca en reposo y en actividad con zonas objetivo personalizadas',
    'health.metric.weight.title': 'Gestión de Peso',
    'health.metric.weight.desc': 'Registra cambios de peso con establecimiento de metas y visualización de progreso',
    'health.metric.blood_sugar.title': 'Monitoreo de Azúcar en Sangre',
    'health.metric.blood_sugar.desc': 'Registra lecturas de glucosa con correlación de comidas y análisis de tendencias',
    'health.summary.title': 'Resumen de Salud de Hoy',
    'health.summary.blood_pressure': 'Presión Arterial',
    'health.summary.heart_rate': 'Frecuencia Cardíaca',
    'health.summary.weight': 'Peso',
    'health.summary.blood_sugar': 'Azúcar en Sangre',
    'health.summary.healthy': 'Todos los valores dentro de rangos saludables',
  },
};

export const LanguageProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [language, setLanguage] = useState<Language>('en');

  useEffect(() => {
    // Load saved language from localStorage
    const savedLanguage = localStorage.getItem('language') as Language;
    if (savedLanguage && ['en', 'he', 'fr', 'es'].includes(savedLanguage)) {
      setLanguage(savedLanguage);
    }
  }, []);

  const handleSetLanguage = (lang: Language) => {
    setLanguage(lang);
    localStorage.setItem('language', lang);
    
    // Update HTML lang attribute
    document.documentElement.lang = lang;
    
    // Update HTML dir attribute for RTL languages
    if (lang === 'he') {
      document.documentElement.dir = 'rtl';
    } else {
      document.documentElement.dir = 'ltr';
    }
  };

  const t = (key: string): string => {
    return translations[language][key] || key;
  };

  return (
    <LanguageContext.Provider value={{ language, setLanguage: handleSetLanguage, t }}>
      {children}
    </LanguageContext.Provider>
  );
};

export const useLanguage = () => {
  const context = useContext(LanguageContext);
  if (context === undefined) {
    throw new Error('useLanguage must be used within a LanguageProvider');
  }
  return context;
}; 