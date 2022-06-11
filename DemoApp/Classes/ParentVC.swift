//
//  ParentVC.swift
//  DemoApp
//
//

import UIKit

class ParentVC: UIViewController {
    
    // UI Components
    private let hud: UIActivityIndicatorView = {
        let hud = UIActivityIndicatorView()
        hud.translatesAutoresizingMaskIntoConstraints = false
        hud.color = UIColor.gray
        hud.hidesWhenStopped = true
        return hud
    }()
    
    private var isHudDisplay = false

    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Hud method(s)
extension ParentVC {
    
    internal func showHud(shouldDeactiveInteraction: Bool = false) {
        guard !isHudDisplay else { return }
        isHudDisplay = true
        view.isUserInteractionEnabled = !shouldDeactiveInteraction
        hud.startAnimating()
        hud.alpha = 0
        view.addSubview(hud)
        hud.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hud.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.hud.alpha = 1
            self.view.layoutIfNeeded()
        },
                       completion: nil)
    }
    
    internal func hideHud() {
        guard isHudDisplay else { return }
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25,
                       delay: 0.25,
                       options: .curveEaseInOut,
                       animations: {
            self.hud.alpha = 0
            self.view.layoutIfNeeded()
        },
                       completion: { _ in
            self.view.isUserInteractionEnabled = true
            self.hud.stopAnimating()
            self.hud.removeFromSuperview()
        })
    }
}
