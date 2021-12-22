//
//  Extension + UIViewController.swift
//  Slash Roll
//
//  Created by Voxar on 19.12.21.
//

import UIKit


extension UIViewController {

    func showAlert(title: String, message: String) {
        let alertViewController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertViewController.addAction(alertAction)

        self.present(alertViewController, animated: true, completion: nil)
    }
}
