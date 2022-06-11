import Foundation
import UIKit
import CoreTelephony

// MARK: - Localization
extension String {
    
    static func localizedString(key: String) -> String {
        return NSLocalizedString(key,
                                 tableName: currentLanguage.tableName,
                                 bundle: Bundle.main,
                                 value: "",
                                 comment: "")
    }
}
