# Senior Nutrition App 🍎

A comprehensive iOS app designed to support seniors (ages 50–120) in managing their nutrition, medication, and daily wellness. Built with SwiftUI, the app prioritizes accessibility, ease of use, and multilingual support (including RTL languages), and compliance with Apple's App Store guidelines.

---

## 🎯 Current Project Status

### ✅ Completed Features & Achievements

#### 🏗️ **Core Infrastructure**
- **SwiftUI Architecture**: Modern, reactive UI framework implementation
- **Core Data Integration**: Persistent data storage with CloudKit sync capabilities
- **Modular Architecture**: Well-organized codebase with separate managers, models, and views
- **Premium Features System**: In-app purchase integration with StoreKit
- **Comprehensive Settings**: User preferences, notifications, and customization options

#### 🌍 **Multilingual Support & Localization**
- **Complete RTL Support**: Full right-to-left language implementation for Hebrew
- **4 Languages Supported**: English, Hebrew, French, Spanish
- **Dynamic Localization**: Real-time language switching without app restart
- **Culturally Adapted UI**: Layout adjustments for different text directions and lengths
- **Localized Date/Time**: Proper formatting for each language and region
- **Translation Management**: Automated tools for maintaining translations across languages

#### 🔐 **Premium Features System**
- **Barcode Scanner**: Quick food addition via product barcode scanning
- **Advanced Analytics**: Detailed nutritional analysis and trends
- **Export Functionality**: Data export capabilities for health records
- **Enhanced Reminders**: Advanced notification scheduling and customization
- **Premium UI Components**: Enhanced visual elements and animations

#### 💊 **Medication Management**
- **3D Pill Visualization**: Interactive 3D pill shapes and colors for easy identification
- **Smart Reminders**: Customizable medication alerts with lead time options
- **Fasting Integration**: Automatic coordination with fasting schedules
- **Medication Tracking**: Complete history and adherence monitoring
- **Print Functionality**: Printable medication schedules and reports

#### ⏰ **Fasting Timer System**
- **Multiple Protocols**: 12:12, 14:10, 16:8, 18:6, 20:4, and custom fasting windows
- **Real-time Tracking**: Visual progress indicators and countdown timers
- **Emergency Override**: One-tap access to break fasting when needed
- **Smart Integration**: Coordination with medication schedules and meal planning
- **Progress Analytics**: Historical fasting data and success tracking

#### 🍽️ **Comprehensive Meal Tracking**
- **Extensive Food Database**: 1000+ food items across multiple cuisines
- **Portion Control**: Intuitive slider-based portion sizing
- **Nutritional Analysis**: Detailed macro and micronutrient breakdown
- **Meal Planning**: Advanced meal scheduling and reminders
- **Recipe Builder**: Custom recipe creation with nutritional calculations
- **Common Meals**: Quick access to frequently eaten meals

#### 🏥 **Health Monitoring**
- **Vital Signs Tracking**: Blood pressure, heart rate, weight monitoring
- **Blood Sugar Management**: Customizable target ranges and trend analysis
- **Visual Analytics**: Charts and graphs for health metric trends
- **Appointment Management**: Calendar integration for medical appointments

#### 🔔 **Advanced Notification System**
- **Customizable Alerts**: Gentle, regular, and urgent notification styles
- **Smart Scheduling**: Intelligent timing based on user patterns
- **Multiple Reminder Types**: Medication, meal, fasting, water, and health tips
- **Voice Notifications**: Audio alerts with customizable voices
- **Granular Control**: Individual on/off switches for each notification type

#### 🎙️ **Voice & Accessibility Features**
- **Voice Settings**: System voice selection with gender and rate preferences
- **Voice Commands**: Hands-free operation for key functions
- **Text-to-Speech**: Voice readout for all app content
- **Large Text Support**: Adjustable text sizes throughout the app
- **High Contrast Mode**: Enhanced visibility options
- **VoiceOver Compatibility**: Full accessibility support

#### 📚 **Comprehensive Help System**
- **In-App Guidance**: Detailed help for every feature
- **Step-by-Step Tutorials**: Visual guides with voice narration
- **Context-Sensitive Help**: Relevant help content based on current screen
- **Video Tutorials**: Interactive demonstrations of key features
- **FAQ Section**: Common questions and troubleshooting
- **Accessibility Help**: Specific guidance for accessibility features

#### 🌐 **Web Presence & Support**
- **Professional Support Page**: GitHub Pages hosted support site
- **Marketing Landing Page**: Professional app promotion page
- **Comprehensive Documentation**: Detailed setup and usage guides
- **Multi-platform Support**: Web-based resources for user assistance

#### 🔧 **Technical Achievements**
- **Performance Optimization**: Efficient data handling and UI rendering
- **Memory Management**: Proper resource cleanup and optimization
- **Error Handling**: Comprehensive error management and user feedback
- **Data Privacy**: Local storage with optional cloud sync
- **App Store Compliance**: Full adherence to Apple's guidelines
- **Testing Infrastructure**: Unit tests and UI tests implementation

#### 🎨 **User Experience & Design**
- **Senior-Friendly Design**: Large buttons, clear navigation, simplified workflows
- **Intuitive Interface**: Logical flow and easy-to-understand interactions
- **Consistent Branding**: Cohesive visual identity throughout the app
- **Responsive Layout**: Adaptive design for different screen sizes
- **Dark Mode Support**: Full dark mode implementation
- **Custom Animations**: Smooth transitions and engaging interactions

---

## 🚀 Features Overview

### 💎 Premium Features
- **Barcode Scanner**: Quickly add foods by scanning product barcodes
- **Advanced Analytics**: Detailed nutritional trends and insights
- **Export Capabilities**: Health data export for medical consultations
- **Enhanced Reminders**: Advanced notification scheduling
- **Premium UI Elements**: Enhanced visual components and animations

### 🆓 Standard Features
- **Medication Management**: Complete medication tracking with 3D pill identification
- **Fasting Timer**: Multiple protocols with real-time tracking
- **Meal Tracking**: Comprehensive food logging with nutritional analysis
- **Health Monitoring**: Vital signs tracking and trend analysis
- **Water Tracking**: Hydration monitoring with smart reminders
- **Appointment Management**: Calendar integration for medical appointments
- **Voice Assistance**: Full voice control and text-to-speech
- **Multilingual Support**: 4 languages with RTL support
- **Accessibility Features**: Senior-friendly design with customizable text sizes

---

## 📱 Technical Specifications

### Requirements
- **iOS**: 15.0 or later
- **Xcode**: 14.0 or later
- **Swift**: 5.7+
- **Frameworks**: SwiftUI, Core Data, CloudKit, StoreKit, AVFoundation

### Architecture
- **Pattern**: MVVM with SwiftUI
- **Data Layer**: Core Data with CloudKit sync
- **Networking**: URLSession for API calls
- **Storage**: Local Core Data with optional cloud backup
- **Localization**: String catalogs with automated translation tools

---

## 🛠️ Installation & Setup

### For Developers
1. **Clone the repository**:
   ```bash
   git clone https://github.com/esamuel/SeniorNutritionApp.git
   cd SeniorNutritionApp
   ```

2. **Open in Xcode**:
   ```bash
   open SeniorNutritionApp.xcodeproj
   ```

3. **Configure Signing**:
   - Select your development team
   - Update bundle identifier if needed
   - Configure CloudKit container (optional)

4. **Build and Run**:
   - Select target device or simulator
   - Build and run (⌘+R)

### For Testing
- **TestFlight**: Beta testing available
- **Simulator**: Full functionality available in iOS Simulator
- **Physical Device**: Recommended for testing hardware features

---

## 🌐 Multilingual Support

### Supported Languages
- 🇺🇸 **English** (Default)
- 🇮🇱 **Hebrew** (RTL Support)
- 🇫🇷 **French**
- 🇪🇸 **Spanish**

### Localization Features
- **Dynamic Language Switching**: Change language without app restart
- **RTL Layout Support**: Proper right-to-left text flow for Hebrew
- **Cultural Adaptations**: Date formats, number formats, and cultural preferences
- **Automated Translation Tools**: Scripts for maintaining translation consistency

---

## ♿ Accessibility & Senior-Friendly Design

### Accessibility Features
- **Large Text Support**: Adjustable text sizes throughout the app
- **High Contrast Mode**: Enhanced visibility options
- **VoiceOver Compatibility**: Full screen reader support
- **Voice Control**: Hands-free operation capabilities
- **Haptic Feedback**: Tactile responses for actions

### Senior-Friendly Design Principles
- **Large Touch Targets**: Easy-to-tap buttons and controls
- **Clear Visual Hierarchy**: Logical information organization
- **Consistent Navigation**: Predictable user interface patterns
- **Simple Workflows**: Streamlined task completion
- **Comprehensive Help**: Detailed guidance for every feature

---

## 📊 App Store Compliance

### Recent Guideline Corrections ✅
The app has been updated to address all App Store Review Board guidelines:

#### 1.4.1 Safety: Physical Harm ✅
- **Comprehensive Medical Disclaimers**: Implemented throughout the app with clear "consult healthcare provider" messaging
- **Health Data Disclaimer View**: Dedicated disclaimer screen (`HealthDataDisclaimerView.swift`) shown before health features
- **Emergency Guidance**: Clear instructions to contact emergency services for medical emergencies
- **No Medical Advice Claims**: App explicitly states it's for tracking and educational purposes only

#### 2.1.0 Performance: App Completeness ✅
- **Full Feature Implementation**: All advertised features are fully functional
- **No Placeholder Content**: Complete meal database, medication management, and health tracking
- **Production-Ready**: Comprehensive testing and quality assurance completed
- **Sample Data Handling**: Proper sample data implementation for demonstration purposes only

#### 2.3.0 Performance: Accurate Metadata ✅
- **Matching Descriptions**: App Store description accurately reflects all implemented functionality
- **Feature Alignment**: Marketing materials match actual app capabilities
- **Comprehensive Documentation**: README and marketing page detail exact app features
- **Honest Representation**: No misleading claims about app capabilities

#### 2.5.1 Performance: Software Requirements ✅
- **iOS Version Support**: Deployment target set to iOS 18.4 with proper compatibility checks
- **API Usage Compliance**: Proper `@available` checks throughout codebase for iOS version compatibility
- **Framework Integration**: Correct implementation of SwiftUI, Core Data, CloudKit, and StoreKit
- **Hardware Requirements**: Proper device capability declarations in Info.plist

### Privacy & Security
- **Local Data Storage**: Data stored locally by default
- **Optional Cloud Sync**: User-controlled CloudKit integration
- **No Data Sharing**: No third-party data sharing without consent
- **Privacy Policy**: Comprehensive privacy documentation

### App Store Guidelines
- **No Medical Advice**: App provides tracking and reminders only
- **User Permissions**: Proper permission requests for all features
- **In-App Purchases**: Compliant premium feature implementation
- **Accessibility Standards**: Full compliance with accessibility guidelines

---

## 🔄 Recent Development Progress

### Latest Achievements
- ✅ **Localization System**: Complete 4-language support with RTL
- ✅ **Premium Features**: Full in-app purchase integration
- ✅ **3D Pill System**: Interactive medication visualization
- ✅ **Advanced Fasting**: Multiple protocols with smart integration
- ✅ **Comprehensive Help**: In-app guidance system
- ✅ **Voice Integration**: Full voice control and feedback
- ✅ **Web Presence**: Support and marketing pages
- ✅ **Performance Optimization**: Enhanced app responsiveness
- ✅ **UI/UX Improvements**: Senior-friendly design refinements
- ✅ **Full-Screen Video Player**: Enhanced video tutorial experience with expandable player
- ✅ **Profile Weight Synchronization**: Real-time weight updates from Health view to Profile
- ✅ **Auto-BMI Calculation**: Dynamic BMI recalculation when weight changes
- ✅ **Save Profile Button**: Large, prominent save button with confirmation messages in profile setup
- ✅ **Type-Safe View Architecture**: Resolved complex expression compilation issues

### Recent Technical Improvements (Latest Session)

#### 🎬 **Enhanced Video Tutorial System**
- **Full-Screen Video Player**: Added expandable video player with device full-length display
- **Video Controls**: Full-screen button with smooth animations and proper close functionality
- **User Experience**: Touch-friendly controls with large tap targets for seniors
- **Background Handling**: Proper video pause/play when entering/exiting full-screen mode

#### ⚖️ **Health Data Synchronization**
- **Real-Time Weight Updates**: Weight changes in Health view instantly reflect in Profile data
- **Automatic BMI Recalculation**: BMI updates dynamically when new weight is added
- **Multi-Storage Sync**: Synchronizes weight across Core Data, UserProfile, and legacy storage
- **Notification System**: Cross-app refresh notifications for immediate UI updates
- **Data Persistence**: Proper UserDefaults integration with automatic saving

#### 🎨 **Profile Setup Enhancements**
- **Prominent Save Button**: Large, visually appealing "Save Profile" button at bottom of form
- **Confirmation Messages**: Clear messaging about data usage and security
- **Visual Design**: Gradient backgrounds, shadows, and professional styling
- **User Guidance**: Explanatory text about how profile data will be used

#### 🔧 **Code Architecture Improvements**
- **Modular View Architecture**: Broke down complex views into manageable computed properties
- **Type Safety**: Resolved Swift compiler type-checking issues with complex expressions
- **Performance Optimization**: Separated heavy calculations from view rendering
- **Debugging Infrastructure**: Added comprehensive logging for weight update flow
- **Clean Code**: Improved maintainability and readability of profile views

#### 🔄 **Data Flow Optimization**
- **Reactive Updates**: Enhanced @Published property observers for immediate UI refresh
- **Cross-View Communication**: Notification-based architecture for real-time updates
- **State Management**: Improved state synchronization between Health and Profile views
- **Error Handling**: Robust error handling with user-friendly feedback

### Current Focus Areas
- 🔧 **Bug Fixes**: Addressing remaining issues
- 📱 **App Store Preparation**: Final compliance checks
- 🧪 **Testing**: Comprehensive quality assurance
- 📚 **Documentation**: User guides and developer docs
- 🚀 **Release Preparation**: App Store submission readiness

---

## 🎯 Future Roadmap

### Planned Features
- **Apple Watch Integration**: Companion watchOS app
- **Siri Shortcuts**: Voice command integration
- **Medication Interaction Checker**: Safety feature implementation
- **Social Features**: Family sharing and caregiver access
- **Advanced Analytics**: AI-powered health insights

### Technical Improvements
- **Performance Optimization**: Further speed enhancements
- **Offline Capabilities**: Enhanced offline functionality
- **Data Export**: Additional export formats
- **Integration APIs**: Third-party health platform connections

---

## 📞 Support & Resources

### User Support
- **Support Page**: [GitHub Pages Support Site](https://esamuel.github.io/senior-nutrition-support)
- **In-App Help**: Comprehensive guidance system
- **Video Tutorials**: Step-by-step feature demonstrations
- **FAQ Section**: Common questions and solutions

### Developer Resources
- **Documentation**: Comprehensive code documentation
- **Contributing Guidelines**: Open source contribution guide
- **Issue Tracking**: GitHub Issues for bug reports
- **Discussion Forum**: Community support and feedback

---

## 🤝 Contributing

We welcome contributions from the community! Please see our contributing guidelines for more information.

### How to Contribute
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

### Areas for Contribution
- **Translations**: Additional language support
- **Accessibility**: Enhanced accessibility features
- **Testing**: Test coverage improvements
- **Documentation**: User and developer documentation
- **Features**: New functionality implementation

---

## 📄 License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

---

## 📧 Contact

For questions, feedback, or support:
- **Email**: [support@seniornutritionapp.com](mailto:support@seniornutritionapp.com)
- **GitHub**: [Issues](https://github.com/esamuel/SeniorNutritionApp/issues)
- **Support Page**: [Senior Nutrition Support](https://esamuel.github.io/senior-nutrition-support)

---

*Built with ❤️ for seniors and their families* 