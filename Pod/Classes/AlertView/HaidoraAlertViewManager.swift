//
//  HaidoraAlertViewManager.swift
//  Pods
//
//  Created by Dailingchi on 15/6/11.
//
//

import Foundation
import UIKit

public typealias HDClickBlock = (AnyObject, Int) -> Void

/**
*  如果要自定义弹出框,弹出框需要实现该协议
*/
@objc public protocol HDAlertDelegate {
    
    func alertWithMessage(message: String)
    func alertWithTitle(title: String, message: String)
    func alertWithTitle(title: String, message: String, cancelTitle: String, okTitle: String?)
    func alertWithTitle(title: String, message: String, clickAction: HDClickBlock?, cancelTitle: String, otherButtonTitles: [String]?)
    func alertWithError(error: NSError)
}

@objc public class HDAlertViewManager {
    
    public var alertDelegate: HDAlertDelegate
    
    public class func shareInstance() -> HDAlertViewManager {
        struct HDAlertViewManagerSingleton {
            static var predicate: dispatch_once_t = 0
            static var instance: HDAlertViewManager? = nil;
        }
        
        dispatch_once(&HDAlertViewManagerSingleton.predicate, {
            HDAlertViewManagerSingleton.instance = HDAlertViewManager(alertDelegate: HDAlertView())
        })
        return HDAlertViewManagerSingleton.instance!
    }
    
    init(alertDelegate: HDAlertDelegate) {
        self.alertDelegate = alertDelegate;
    }
}

public extension HDAlertViewManager {
    
    public class func alertWithMessage(message: String) {
        HDAlertViewManager.shareInstance().alertDelegate.alertWithMessage(message)
    }
    
    public class func alertWithTitle(title: String, message: String) {
        HDAlertViewManager.shareInstance().alertDelegate.alertWithTitle(title, message: message)
    }
    
    public class func alertWithTitle(title: String, message: String, cancelTitle: String, okTitle: String?) {
        HDAlertViewManager.shareInstance().alertDelegate.alertWithTitle(title, message: message, cancelTitle: cancelTitle, okTitle: okTitle)
    }
    
    /**
    兼容Objective-C版本
    
    :param: title
    :param: message
    :param: clickAction
    :param: cancelTitle
    :param: moreButtonTitles 多个参数用数组代替
    */
    public class func alertWithTitle(title: String, message: String, clickAction: HDClickBlock?, cancelTitle: String, moreButtonTitles: [String]?) {
        HDAlertViewManager.shareInstance().alertDelegate.alertWithTitle(title, message: message, clickAction: clickAction, cancelTitle: cancelTitle, otherButtonTitles: moreButtonTitles)
    }
    
    public class func alertWithTitle(title: String, message: String, clickAction: HDClickBlock?, cancelTitle: String, _ moreButtonTitles: String... ) {
        var buttonTitles = [String]()
        for buttonTitle in moreButtonTitles {
            buttonTitles.append(buttonTitle)
        }
        HDAlertViewManager.shareInstance().alertDelegate.alertWithTitle(title, message: message, clickAction: clickAction, cancelTitle: cancelTitle, otherButtonTitles: buttonTitles)
    }
    
    public class func alertWithError(error: NSError) {
        HDAlertViewManager.shareInstance().alertDelegate.alertWithError(error)
    }
}

//MAKR:
//MAKR:NSError

public extension NSError {

    /**
    弹出错误描述
    
    :param: title   错误提示标题
    :param: message 错误提示内容
    
    :returns:
    */
    public convenience init(title: String?, message: String?) {
        self.init(domain: "HDAlertViewManagerDomain", code: -1, userInfo: nil)
        self.title = title;
        self.message = message;
    }
}

internal extension NSError {

    private struct AssociatedKeys {
        static var kHD_NSError_title = "kHD_NSError_title"
        static var kHD_NSError_message = "kHD_NSError_message"
    }
    
    internal var title: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.kHD_NSError_title) as? String
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.kHD_NSError_title, newValue, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
        }
    }
    
    internal var message: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.kHD_NSError_message) as? String
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.kHD_NSError_message, newValue, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
        }
    }
}

//MAKR:
//MAKR:UIAlertView

extension UIAlertView: UIAlertViewDelegate {
    
    /**
    兼容Objective-C版本
    
    :param: title
    :param: message
    :param: clickAction
    :param: cancelButtonTitle
    :param: moreButtonTitles  多个参数用数组代替
    
    :returns:
    */
    public convenience init(title: String, message: String, clickAction: HDClickBlock?, cancelButtonTitle: String?, moreButtonTitles: [String]?) {
        self.init(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle)
        if let click = clickAction {
            self.delegate = self
            self.clickAction = click
        }
        if let moreButtonTitles = moreButtonTitles {
            for buttonTitle in moreButtonTitles {
                self.addButtonWithTitle(buttonTitle)
            }
        }
    }
    
    public convenience init(title: String, message: String, clickAction: HDClickBlock?, cancelButtonTitle: String?, _ moreButtonTitles: String...) {
        self.init(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle)
        if let click = clickAction {
            self.delegate = self
            self.clickAction = click
        }
        for buttonTitle in moreButtonTitles {
            self.addButtonWithTitle(buttonTitle)
        }
    }
    
    //MAKR: UIAlertViewDelegate
    public func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.clickAction?(alertView, buttonIndex)
    }
}

private extension UIAlertView {
    
    private struct AssociatedKeys {
        static var kHD_UIAlertView_clickAction = "kHD_UIAlertView_clickAction"
    }
    
    private class ClosureWrapper: NSObject, NSCopying {
        
        var closure: HDClickBlock?
        
        convenience init(closure: HDClickBlock?) {
            self.init()
            self.closure = closure
        }
        
        @objc func copyWithZone(zone: NSZone) -> AnyObject {
            var wrapper: ClosureWrapper = ClosureWrapper()
            wrapper.closure = closure
            return wrapper
        }
    }
    
    private var clickAction: HDClickBlock? {
        get {
            if let closure = objc_getAssociatedObject(self, &AssociatedKeys.kHD_UIAlertView_clickAction) as? ClosureWrapper {
                return closure.closure;
            }
            else {
                return nil;
            }
        }
        set(newValue) {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.kHD_UIAlertView_clickAction, ClosureWrapper(closure: newValue), UInt(OBJC_ASSOCIATION_COPY_NONATOMIC))
            }
        }
    }
}
