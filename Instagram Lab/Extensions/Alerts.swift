//
//  Alerts.swift
//  Instagram Lab
//
//  Created by Tsering Lama on 3/8/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import UIKit
import StatusAlert

extension UIViewController {
    
    public func showStatusAlert(withImage image: UIImage?, title: String?, message: String?) {
        let preferredPosition: StatusAlert.VerticalPosition = .center
        let isPickable: Bool = true
        let statusAlert = StatusAlert()
        statusAlert.image = image
        statusAlert.title = title
        statusAlert.message = message
        statusAlert.canBePickedOrDismissed = isPickable
        statusAlert.accessibilityAnnouncement = {
            if let title = title {
                if let message = message {
                    return [title, ", ", message].joined()
                }
                return title
            } else if let message = message {
                return message
            }
            return nil
        }()
        statusAlert.show(withVerticalPosition: preferredPosition)
    }
}
