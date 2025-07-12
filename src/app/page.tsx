import Image from "next/image";

export default function Home() {
  return (
    <div className="min-h-screen bg-white">
      {/* Navigation */}
      <nav className="bg-white shadow-sm fixed w-full top-0 z-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16">
            <div className="flex items-center">
              <div className="flex items-center space-x-3">
                <Image 
                  src="/images/app-icon.png" 
                  alt="Senior Nutrition App Icon" 
                  width={40}
                  height={40}
                  className="rounded-lg shadow-sm"
                />
                <h1 className="text-xl font-bold text-gray-900">Senior Nutrition</h1>
              </div>
            </div>
            <div className="hidden md:flex items-center space-x-8">
              <a href="#features" className="text-gray-700 hover:text-blue-600 transition-colors">Features</a>
              <a href="#health" className="text-gray-700 hover:text-blue-600 transition-colors">Health Tracking</a>
              <a href="#safety" className="text-gray-700 hover:text-blue-600 transition-colors">Safety</a>
              <a href="#download" className="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition-colors">Download App</a>
            </div>
          </div>
        </div>
      </nav>

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
              Your Personal
              <span className="text-blue-600"> Nutrition Companion</span>
              <br />for Healthy Aging
            </h1>
            <p className="text-xl text-gray-600 mb-8 max-w-3xl mx-auto">
              Senior Nutrition is a comprehensive health and wellness app designed specifically for adults aged 50 and above. 
              Track nutrition, manage medications, monitor health metrics, and follow safe fasting protocols - all in one accessible app.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center mb-12">
              <a href="#download" className="bg-blue-600 text-white px-8 py-4 rounded-lg font-medium hover:bg-blue-700 transition-colors text-lg">
                📱 Download on App Store
              </a>
              <a href="#features" className="border border-gray-300 text-gray-700 px-8 py-4 rounded-lg font-medium hover:bg-gray-50 transition-colors text-lg">
                Explore Features
              </a>
            </div>
            
            {/* App Preview */}
            <div className="max-w-4xl mx-auto">
              <div className="bg-gray-900 rounded-2xl p-8 shadow-2xl">
                <div className="grid md:grid-cols-3 gap-6">
                  <div className="bg-white rounded-xl p-6 text-center">
                    <div className="text-4xl mb-4">🍽️</div>
                    <h3 className="font-semibold text-gray-900 mb-2">Nutrition Tracking</h3>
                    <p className="text-sm text-gray-600">Smart meal logging with nutritional analysis</p>
                  </div>
                  <div className="bg-white rounded-xl p-6 text-center">
                    <div className="text-4xl mb-4">⏱️</div>
                    <h3 className="font-semibold text-gray-900 mb-2">Safe Fasting</h3>
                    <p className="text-sm text-gray-600">Senior-friendly intermittent fasting protocols</p>
                  </div>
                  <div className="bg-white rounded-xl p-6 text-center">
                    <div className="text-4xl mb-4">💊</div>
                    <h3 className="font-semibold text-gray-900 mb-2">Medication Management</h3>
                    <p className="text-sm text-gray-600">Visual pill identification and smart reminders</p>
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
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Comprehensive Health Management</h2>
            <p className="text-xl text-gray-600">Everything you need to maintain your health and independence as you age</p>
          </div>
          
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            {/* Nutrition Tracking */}
            <div className="bg-green-50 p-8 rounded-2xl">
              <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mb-6">
                <span className="text-2xl">🍽️</span>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-4">Smart Nutrition Tracking</h3>
              <ul className="text-gray-600 space-y-2">
                <li>• Photo-based meal logging</li>
                <li>• Barcode scanner for packaged foods</li>
                <li>• Voice input for hands-free recording</li>
                <li>• Personalized nutritional analysis</li>
                <li>• Senior-specific dietary recommendations</li>
              </ul>
            </div>

            {/* Fasting Timer */}
            <div className="bg-orange-50 p-8 rounded-2xl">
              <div className="w-16 h-16 bg-orange-100 rounded-full flex items-center justify-center mb-6">
                <span className="text-2xl">⏱️</span>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-4">Safe Fasting Protocols</h3>
              <ul className="text-gray-600 space-y-2">
                <li>• Multiple fasting options (12:12, 14:10, 16:8)</li>
                <li>• Real-time progress tracking</li>
                <li>• Emergency override with one tap</li>
                <li>• Integration with medication schedules</li>
                <li>• Health safety indicators</li>
              </ul>
            </div>

            {/* Health Monitoring */}
            <div className="bg-red-50 p-8 rounded-2xl">
              <div className="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mb-6">
                <span className="text-2xl">❤️</span>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-4">Vital Health Monitoring</h3>
              <ul className="text-gray-600 space-y-2">
                <li>• Blood pressure tracking</li>
                <li>• Blood sugar monitoring</li>
                <li>• Heart rate recording</li>
                <li>• Weight management</li>
                <li>• Visual trends and analytics</li>
              </ul>
            </div>

            {/* Medication Management */}
            <div className="bg-purple-50 p-8 rounded-2xl">
              <div className="w-16 h-16 bg-purple-100 rounded-full flex items-center justify-center mb-6">
                <span className="text-2xl">💊</span>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-4">Medication Management</h3>
              <ul className="text-gray-600 space-y-2">
                <li>• 3D pill shape and color identification</li>
                <li>• Smart scheduling with fasting alerts</li>
                <li>• Refill reminders</li>
                <li>• Food and timing requirements</li>
                <li>• Medication history tracking</li>
              </ul>
            </div>

            {/* Appointment Tracking */}
            <div className="bg-blue-50 p-8 rounded-2xl">
              <div className="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center mb-6">
                <span className="text-2xl">📅</span>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-4">Appointment Management</h3>
              <ul className="text-gray-600 space-y-2">
                <li>• Easy medical appointment scheduling</li>
                <li>• Customizable advance reminders</li>
                <li>• Provider and location storage</li>
                <li>• Calendar integration</li>
                <li>• Caregiver sharing options</li>
              </ul>
            </div>

            {/* Accessibility */}
            <div className="bg-indigo-50 p-8 rounded-2xl">
              <div className="w-16 h-16 bg-indigo-100 rounded-full flex items-center justify-center mb-6">
                <span className="text-2xl">♿</span>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-4">Enhanced Accessibility</h3>
              <ul className="text-gray-600 space-y-2">
                <li>• Adjustable text sizes</li>
                <li>• Voice assistance throughout</li>
                <li>• Multi-language support</li>
                <li>• Simple, uncluttered interface</li>
                <li>• Large, touch-friendly buttons</li>
              </ul>
            </div>
          </div>
        </div>
      </section>

      {/* Health Tracking Deep Dive */}
      <section id="health" className="py-20 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid lg:grid-cols-2 gap-12 items-center">
            <div>
              <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-6">
                Complete Health Monitoring
              </h2>
              <p className="text-lg text-gray-600 mb-8">
                Track all your vital health metrics with easy data entry, visual trends, and exportable reports 
                perfect for sharing with your healthcare providers.
              </p>
              
              <div className="space-y-6">
                <div className="flex items-start space-x-4">
                  <div className="w-8 h-8 bg-red-100 rounded-full flex items-center justify-center flex-shrink-0">
                    <span className="text-red-600 text-sm">❤️</span>
                  </div>
                  <div>
                    <h3 className="font-semibold text-gray-900">Blood Pressure & Heart Rate</h3>
                    <p className="text-gray-600">Track systolic/diastolic readings and heart rate with customizable target ranges</p>
                  </div>
                </div>
                
                <div className="flex items-start space-x-4">
                  <div className="w-8 h-8 bg-purple-100 rounded-full flex items-center justify-center flex-shrink-0">
                    <span className="text-purple-600 text-sm">🩸</span>
                  </div>
                  <div>
                    <h3 className="font-semibold text-gray-900">Blood Sugar Monitoring</h3>
                    <p className="text-gray-600">Monitor glucose levels with diabetes management features and trend analysis</p>
                  </div>
                </div>
                
                <div className="flex items-start space-x-4">
                  <div className="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center flex-shrink-0">
                    <span className="text-blue-600 text-sm">⚖️</span>
                  </div>
                  <div>
                    <h3 className="font-semibold text-gray-900">Weight & BMI Tracking</h3>
                    <p className="text-gray-600">Monitor weight changes with automatic BMI calculation and trend visualization</p>
                  </div>
                </div>
              </div>
            </div>
            
            <div className="bg-white rounded-2xl p-8 shadow-lg">
              <h3 className="text-xl font-bold text-gray-900 mb-6">Health Dashboard Preview</h3>
              <div className="space-y-4">
                <div className="flex justify-between items-center p-4 bg-red-50 rounded-lg">
                  <div className="flex items-center space-x-3">
                    <span className="text-red-600">❤️</span>
                    <span className="font-medium">Blood Pressure</span>
                  </div>
                  <span className="font-bold text-red-600">120/80 mmHg</span>
                </div>
                
                <div className="flex justify-between items-center p-4 bg-orange-50 rounded-lg">
                  <div className="flex items-center space-x-3">
                    <span className="text-orange-600">📊</span>
                    <span className="font-medium">Heart Rate</span>
                  </div>
                  <span className="font-bold text-orange-600">72 BPM</span>
                </div>
                
                <div className="flex justify-between items-center p-4 bg-blue-50 rounded-lg">
                  <div className="flex items-center space-x-3">
                    <span className="text-blue-600">⚖️</span>
                    <span className="font-medium">Weight</span>
                  </div>
                  <span className="font-bold text-blue-600">75.2 kg</span>
                </div>
                
                <div className="flex justify-between items-center p-4 bg-purple-50 rounded-lg">
                  <div className="flex items-center space-x-3">
                    <span className="text-purple-600">🩸</span>
                    <span className="font-medium">Blood Sugar</span>
                  </div>
                  <span className="font-bold text-purple-600">95 mg/dL</span>
                </div>
              </div>
              
              <div className="mt-6 p-4 bg-green-50 rounded-lg">
                <p className="text-sm text-green-700 font-medium">✅ All readings within healthy ranges</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Safety & Senior Focus */}
      <section id="safety" className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Safety First, Always</h2>
            <p className="text-xl text-gray-600">Designed specifically for seniors with safety features and emergency protocols</p>
          </div>
          
          <div className="grid md:grid-cols-3 gap-8">
            <div className="text-center p-6">
              <div className="w-20 h-20 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-6">
                <span className="text-3xl">🛡️</span>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-4">Emergency Override</h3>
              <p className="text-gray-600">One-tap emergency override for fasting protocols when you need immediate nutrition or medication</p>
            </div>
            
            <div className="text-center p-6">
              <div className="w-20 h-20 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-6">
                <span className="text-3xl">👨‍⚕️</span>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-4">Healthcare Integration</h3>
              <p className="text-gray-600">Export all your health data to share with doctors and healthcare providers for better care coordination</p>
            </div>
            
            <div className="text-center p-6">
              <div className="w-20 h-20 bg-purple-100 rounded-full flex items-center justify-center mx-auto mb-6">
                <span className="text-3xl">🔒</span>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-4">Privacy Protection</h3>
              <p className="text-gray-600">Your health data stays on your device. Encrypted, secure, and never shared with third parties without your consent</p>
            </div>
          </div>
        </div>
      </section>

      {/* Language Support */}
      <section className="py-20 bg-gradient-to-r from-blue-50 to-indigo-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-6">Available in Multiple Languages</h2>
          <p className="text-xl text-gray-600 mb-12">Designed to serve diverse communities with full language support</p>
          
          <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
            <div className="bg-white p-6 rounded-xl shadow-sm">
              <div className="text-3xl mb-3">🇺🇸</div>
              <h3 className="font-semibold">English</h3>
            </div>
            <div className="bg-white p-6 rounded-xl shadow-sm">
              <div className="text-3xl mb-3">🇮🇱</div>
              <h3 className="font-semibold">עברית</h3>
            </div>
            <div className="bg-white p-6 rounded-xl shadow-sm">
              <div className="text-3xl mb-3">🇫🇷</div>
              <h3 className="font-semibold">Français</h3>
            </div>
            <div className="bg-white p-6 rounded-xl shadow-sm">
              <div className="text-3xl mb-3">🇪🇸</div>
              <h3 className="font-semibold">Español</h3>
            </div>
          </div>
        </div>
      </section>

      {/* Download Section */}
      <section id="download" className="py-20 bg-gray-900 text-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl md:text-4xl font-bold mb-6">Ready to Start Your Health Journey?</h2>
          <p className="text-xl text-gray-300 mb-12">
            Download Senior Nutrition today and take control of your health with confidence
          </p>
          
          <div className="flex flex-col sm:flex-row gap-6 justify-center mb-12">
            <a 
              href="https://apps.apple.com/app/senior-nutrition" 
              className="bg-white text-gray-900 px-8 py-4 rounded-lg font-medium hover:bg-gray-100 transition-colors text-lg flex items-center justify-center space-x-3"
            >
              <span className="text-2xl">📱</span>
              <span>Download on the App Store</span>
            </a>
          </div>
          
          <div className="grid md:grid-cols-3 gap-8 text-center">
            <div>
              <div className="text-3xl font-bold text-blue-400 mb-2">50+</div>
              <p className="text-gray-300">Age range designed for</p>
            </div>
            <div>
              <div className="text-3xl font-bold text-green-400 mb-2">4.8★</div>
              <p className="text-gray-300">Average user rating</p>
            </div>
            <div>
              <div className="text-3xl font-bold text-purple-400 mb-2">10K+</div>
              <p className="text-gray-300">Happy users</p>
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
                Your comprehensive health companion designed specifically for seniors, supporting healthy aging through personalized nutrition and wellness tracking.
              </p>
            </div>
            
            <div>
              <h3 className="text-lg font-semibold text-gray-900 mb-4">Features</h3>
              <ul className="space-y-2 text-gray-600">
                <li>Nutrition Tracking</li>
                <li>Fasting Protocols</li>
                <li>Health Monitoring</li>
                <li>Medication Management</li>
                <li>Appointment Scheduling</li>
              </ul>
            </div>
            
            <div>
              <h3 className="text-lg font-semibold text-gray-900 mb-4">Support</h3>
              <ul className="space-y-2 text-gray-600">
                <li>Help Center</li>
                <li>Video Tutorials</li>
                <li>Contact Support</li>
                <li>Privacy Policy</li>
                <li>Terms of Service</li>
              </ul>
            </div>
            
            <div>
              <h3 className="text-lg font-semibold text-gray-900 mb-4">Connect</h3>
              <ul className="space-y-2 text-gray-600">
                <li>support@seniornutrition.com</li>
                <li>+1 (800) 123-4567</li>
                <li>App Store Reviews</li>
                <li>Healthcare Providers</li>
              </ul>
            </div>
          </div>
          
          <div className="border-t border-gray-200 mt-8 pt-8 text-center text-gray-600">
            <p>&copy; 2024 Senior Nutrition App. All rights reserved. Designed for healthy aging with safety and accessibility in mind.</p>
          </div>
        </div>
      </footer>
    </div>
  );
} 