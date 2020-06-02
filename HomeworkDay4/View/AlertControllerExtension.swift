//
//  AlertControllerExtension.swift
//  HomeworkDay4
//
//  Created by Fumiaki Kobayashi on 2020/05/28.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func apiAlert(title: String?, message: String?, preferredStyle: UIAlertController.Style, retryHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let retryAction = UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: retryHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(retryAction)
        alert.addAction(cancelAction)
        return alert
    }
}
