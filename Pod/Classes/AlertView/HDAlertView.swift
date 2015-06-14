//
//  HDAlertView.swift
//  Pods
//
//  Created by Dailingchi on 15/6/12.
//
//

import Foundation
import UIKit

class HDAlertView: HDAlertDelegate {
    
    @objc func localizedString(key: String) -> String {
        return NSLocalizedString(key, tableName: "HaidoraCommonWrapperSwift", bundle: NSBundle(forClass: self.dynamicType), value: "", comment: "")
    }
    
    @objc func alertWithMessage(message: String) {
        self.alertWithTitle(self.localizedString("title"),message: message)
    }
    
    @objc func alertWithTitle(title: String, message: String) {
        self.alertWithTitle(title, message: message, cancelTitle: self.localizedString("cancel"), okTitle: nil)
    }
    
    @objc func alertWithTitle(title: String, message: String, cancelTitle: String, okTitle: String?) {
        var buttons = [String]()
        if let title = okTitle {
            buttons.append(title)
        }
        self.alertWithTitle(title, message: message, clickAction: nil, cancelTitle: cancelTitle, otherButtonTitles: buttons)
    }
    
    @objc func alertWithTitle(title: String, message: String, clickAction: HDClickBlock?, cancelTitle: String, otherButtonTitles: [String]?) {
        var alertView = UIAlertView(title: title, message: message, clickAction: clickAction, cancelButtonTitle: cancelTitle)
        if let buttonTitles = otherButtonTitles {
            for buttonTitle in buttonTitles {
                alertView .addButtonWithTitle(buttonTitle)
            }
        }
        alertView.show()
    }
    
    @objc func alertWithError(error: NSError) {
        if error.title != nil && error.message != nil {
            self.alertWithTitle(error.title!, message: error.message!)
        }
        else {
            self.alertWithTitle(error.domain, message: error.description)
        }
    }
}
