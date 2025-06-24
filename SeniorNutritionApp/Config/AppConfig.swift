import Foundation

struct AppConfig {
    struct Support {
        static let email = "support@seniornutrition.app"
        static let location = "123 Health St, Wellness City, CA 90210"
        static let hours = "Mon-Fri, 9 AM - 5 PM PST"
    }

    struct Emergency {
        /// Country-specific emergency numbers mapping
        static let countryEmergencyNumbers: [String: EmergencyNumberInfo] = [
            "US": EmergencyNumberInfo(number: "911", name: "Emergency Services"),
            "CA": EmergencyNumberInfo(number: "911", name: "Emergency Services"),
            "GB": EmergencyNumberInfo(number: "999", name: "Emergency Services"),
            "AU": EmergencyNumberInfo(number: "000", name: "Emergency Services"),
            "NZ": EmergencyNumberInfo(number: "111", name: "Emergency Services"),
            "DE": EmergencyNumberInfo(number: "112", name: "Notruf"),
            "FR": EmergencyNumberInfo(number: "112", name: "Services d'urgence"),
            "ES": EmergencyNumberInfo(number: "112", name: "Servicios de emergencia"),
            "IT": EmergencyNumberInfo(number: "112", name: "Servizi di emergenza"),
            "IL": EmergencyNumberInfo(number: "101", name: "שירותי חירום"), // Israel - Medical emergency
            "IN": EmergencyNumberInfo(number: "108", name: "Emergency Services"),
            "JP": EmergencyNumberInfo(number: "119", name: "緊急サービス"),
            "CN": EmergencyNumberInfo(number: "120", name: "急救服务"),
            "KR": EmergencyNumberInfo(number: "119", name: "응급 서비스"),
            "BR": EmergencyNumberInfo(number: "192", name: "Serviços de emergência"),
            "MX": EmergencyNumberInfo(number: "911", name: "Servicios de emergencia"),
            "RU": EmergencyNumberInfo(number: "103", name: "Службы экстренного реагирования"),
            "ZA": EmergencyNumberInfo(number: "10177", name: "Emergency Services"),
            "NG": EmergencyNumberInfo(number: "199", name: "Emergency Services"),
            "EG": EmergencyNumberInfo(number: "123", name: "خدمات الطوارئ"),
            "SA": EmergencyNumberInfo(number: "997", name: "خدمات الطوارئ"),
            "AE": EmergencyNumberInfo(number: "999", name: "خدمات الطوارئ"),
            // European Union countries (most use 112)
            "AT": EmergencyNumberInfo(number: "112", name: "Notruf"),
            "BE": EmergencyNumberInfo(number: "112", name: "Services d'urgence"),
            "BG": EmergencyNumberInfo(number: "112", name: "Спешни услуги"),
            "HR": EmergencyNumberInfo(number: "112", name: "Hitne službe"),
            "CY": EmergencyNumberInfo(number: "112", name: "Emergency Services"),
            "CZ": EmergencyNumberInfo(number: "112", name: "Pohotovostní služby"),
            "DK": EmergencyNumberInfo(number: "112", name: "Nødtjenester"),
            "EE": EmergencyNumberInfo(number: "112", name: "Hädaabi teenused"),
            "FI": EmergencyNumberInfo(number: "112", name: "Hätäpalvelut"),
            "GR": EmergencyNumberInfo(number: "112", name: "Υπηρεσίες έκτακτης ανάγκης"),
            "HU": EmergencyNumberInfo(number: "112", name: "Sürgősségi szolgálatok"),
            "IE": EmergencyNumberInfo(number: "112", name: "Emergency Services"),
            "LV": EmergencyNumberInfo(number: "112", name: "Neatliekamās palīdzības dienesti"),
            "LT": EmergencyNumberInfo(number: "112", name: "Skubios pagalbos tarnybos"),
            "LU": EmergencyNumberInfo(number: "112", name: "Services d'urgence"),
            "MT": EmergencyNumberInfo(number: "112", name: "Emergency Services"),
            "NL": EmergencyNumberInfo(number: "112", name: "Hulpdiensten"),
            "PL": EmergencyNumberInfo(number: "112", name: "Służby ratunkowe"),
            "PT": EmergencyNumberInfo(number: "112", name: "Serviços de emergência"),
            "RO": EmergencyNumberInfo(number: "112", name: "Servicii de urgență"),
            "SK": EmergencyNumberInfo(number: "112", name: "Pohotovostné služby"),
            "SI": EmergencyNumberInfo(number: "112", name: "Nujne službe"),
            "SE": EmergencyNumberInfo(number: "112", name: "Räddningstjänst"),
            "NO": EmergencyNumberInfo(number: "112", name: "Nødtjenester"),
            "CH": EmergencyNumberInfo(number: "112", name: "Services d'urgence"),
        ]
        
        /// Get the emergency number info for the current country/region
        static var currentEmergencyInfo: EmergencyNumberInfo {
            let countryCode = Locale.current.regionCode ?? "US"
            return countryEmergencyNumbers[countryCode] ?? EmergencyNumberInfo(number: "911", name: "Emergency Services")
        }
        
        /// Get the emergency number for the current country/region
        static var emergencyNumber: String {
            return currentEmergencyInfo.number
        }
        
        /// Get the emergency service name for the current country/region
        static var emergencyServiceName: String {
            return currentEmergencyInfo.name
        }
        
        /// Legacy property for backward compatibility
        @available(*, deprecated, message: "Use emergencyNumber instead")
        static let legacyEmergencyNumber = "911"
        
        static let emergencyMessage = NSLocalizedString("If you are experiencing a medical emergency, please call emergency services immediately.", comment: "")
    }

    struct AppInfo {
        static let version = "1.0.0"
        static let build = "1"
    }
}

/// Structure to hold emergency number information
struct EmergencyNumberInfo {
    let number: String
    let name: String
    
    init(number: String, name: String) {
        self.number = number
        self.name = name
    }
}
