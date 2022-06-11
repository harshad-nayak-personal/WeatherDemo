import UIKit
import Foundation
import AdSupport

/*---------------------------------------------------
 Facebook
 ---------------------------------------------------*/
// MARK: - General
let _application: UIApplication = UIApplication.shared
let _appDelegator: AppDelegate = _application.delegate as! AppDelegate
let _userDefaults = UserDefaults.standard
let _defaultCenter = NotificationCenter.default
let _keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
let _apiKey = "141811b9ce334c0fe7f0ce32c70b7ee0"

// MARK: - UI
let _screen = UIScreen.main
let _frame = UIScreen.main.bounds
let _width = _screen.bounds.width
let _height = _screen.bounds.height
let _bottomSafeAreaHeight: CGFloat = _appDelegator.window!.safeAreaInsets.bottom
let _topSafeAreaHeight: CGFloat = _appDelegator.window!.safeAreaInsets.top
let _statusbarHeight: CGFloat = _topSafeAreaHeight
let _navigationHeight: CGFloat = 44 + _topSafeAreaHeight
let _widthRation = _width / 414
let _heightRation = _height / 896
let _hasNotch: Bool = _appDelegator.window!.safeAreaInsets.bottom > 0

let kAppLanguage = "AppLanguage"

var currentLanguage: Language {
    let languageRawValue = _userDefaults.integer(forKey: kAppLanguage)
    return Language(rawValue: languageRawValue)!
}

func setCurrentLanguage(rawValue: Int) {
    _userDefaults.set(rawValue, forKey: kAppLanguage)
    _userDefaults.synchronize()
//    let window = UIWindow()
//    let weatherVC = WeatherVC()
//    window.rootViewController = weatherVC
//    _appDelegator.window = window
//    window.makeKeyAndVisible()
}

/*---------------------------------------------------
 Custom print
 ---------------------------------------------------*/
func kprint(_ items: Any...) {
    #if DEBUG
        for item in items {
            print(item)
        }
    #endif
}

//enum AppLanguage {
//    case english
//    case hindi
//
//    init(){
//        if let code = Locale.current.languageCode {
//            if code == "fr" {
//                self = .french
//            } else {
//                self = .english
//            }
//        } else {
//            self = .english
//        }
//    }
//}
