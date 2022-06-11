import UIKit
import AVKit
import PhotosUI

typealias PermissionStatus = (_ status: Int, _ isGranted: Bool)-> ()

class PermissionManager {
    
    static var shared = PermissionManager()
    
    var popupWindow: UIWindow?
    var popupViewController: UIViewController?
    var cameraPermission: AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }
    var photoPermission: PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
    let locationManager = CLLocationManager()
    var locationPermissionStatus: CLAuthorizationStatus {
      return CLLocationManager.authorizationStatus()
    }
    
    private init() {}
}

// MARK: - UI method(s)
extension PermissionManager {
    
    func showPopup(title: String, message: String) {
        DispatchQueue.main.async {
            guard let windowScene = _application.connectedScenes.filter({ $0.activationState == .foregroundInactive }).first as? UIWindowScene else { return }
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let actionSettings = UIAlertAction(title: "Settings", style: .default) {[weak self] (_) in
                guard let weakSelf = self else { return }
                if let url = URL(string: UIApplication.openSettingsURLString), _application.canOpenURL(url) {
                    _application.open(url, options: [:], completionHandler: nil)
                }
                weakSelf.popupWindow?.resignKey()
                weakSelf.popupWindow = nil
                weakSelf.popupViewController = nil
            }
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) {[weak self] (_) in
                guard let weakSelf = self else { return }
                weakSelf.popupWindow?.resignKey()
                weakSelf.popupWindow = nil
                weakSelf.popupViewController = nil
            }
            alert.addAction(actionSettings)
            alert.addAction(actionCancel)
            self.popupWindow = UIWindow(windowScene: windowScene)
            self.popupViewController = UIViewController()
            self.popupViewController?.view.backgroundColor = .clear
            self.popupWindow?.rootViewController = self.popupViewController
            self.popupWindow?.makeKeyAndVisible()
            self.popupWindow?.backgroundColor = .clear
            self.popupViewController?.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Permsission requests
extension PermissionManager {
    
    func requestForLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
}
