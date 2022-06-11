//
//  Alert.swift
//  DemoApp
//
//

import UIKit

func showAlert(title: String, message: String) {
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: .alert)
    let action = UIAlertAction(title: "Ok", style: .default)
    alert.addAction(action)
    if let vc = _appDelegator.window?.rootViewController {
        DispatchQueue.main.async {
            vc.present(alert,
                       animated: true)
        }
    }
}
