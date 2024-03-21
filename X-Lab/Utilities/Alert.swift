//
//  Alert.swift
//  Cinemax
//
//  Created by IPS-161 on 31/01/24.
//

import UIKit

class Alert {
    static let shared = Alert()
    private init() {}

    // Function to display an alert with "OK" button
    func alertOk(title: String, message: String, presentingViewController: UIViewController, completion: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok.Button".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), style: .default) { _ in
            completion(true)
        }
        alertController.addAction(okAction)
        presentingViewController.present(alertController, animated: true, completion: nil)
    }

    
    // Function to display an alert with "Yes" and "No" buttons
    func alertYesNo(title: String, message: String, presentingViewController: UIViewController, yesHandler: ((UIAlertAction) -> Void)?, noHandler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // "Yes" button
        let yesAction = UIAlertAction(title: "Yes.Button".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), style: .default, handler: yesHandler)
        alertController.addAction(yesAction)
        
        // "No" button
        let noAction = UIAlertAction(title: "No.Button".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), style: .default, handler: noHandler)
        alertController.addAction(noAction)
        
        presentingViewController.present(alertController, animated: true, completion: nil)
    }
}



