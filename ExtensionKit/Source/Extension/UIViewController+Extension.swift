//
//  UIViewController+Extension.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 11/10/15.
//  Copyright © 2015 Moch Xiao (https://github.com/cuzv).
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

// MARK: - AssociationKey

private struct AssociationKey {
    private static var alertActionIndex: String = "alertActionIndex"
    private static var imagePickerCompletionHandlerWrapper = "imagePickerCompletionHandlerWrapper"
    private static var barButtonItemActionHandlerWrapper: String = "barButtonItemActionHandlerWrapper"
}

// MARK: - Present UIAlertController

public extension UIAlertAction {
    private var alertActionIndex: Int! {
        get { return associatedObjectForKey(&AssociationKey.alertActionIndex) as? Int }
        set { associateRetainObject(newValue, forKey: &AssociationKey.alertActionIndex) }
    }
    
    public var index: Int! {
        return self.alertActionIndex
    }
}

public extension UIViewController {
    /// Present error.
    public func presentError(error: NSError) {
        if let message = error.userInfo[NSLocalizedFailureReasonErrorKey] as? String {
            presentAlert(message: message)
        }
    }
    
    /// Present message.
    public func presentAlert(
        title title: String = "",
        message: String,
        cancelTitle: String = "好",
        cancelHandler: ((UIAlertAction) -> ())? = nil,
        otherTitles: [String]? = nil,
        othersHandler: ((UIAlertAction) -> ())? = nil)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .Cancel, handler: cancelHandler)
        alertController.addAction(cancelAction)
        
        if let otherTitles = otherTitles {
            for otherTitle in otherTitles {
                let action = UIAlertAction(title: otherTitle, style: .Default, handler: othersHandler)
                action.alertActionIndex = otherTitles.indexOf(otherTitle)
                alertController.addAction(action)
            }
        }
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    /// Present ActionSheet.
    public func presentActionSheet(
        title title: String = "",
        message: String,
        cancelTitle: String = "取消",
        cancelHandler: ((UIAlertAction) -> ())? = nil,
        actionTitles: [String],
        actionHandler: ((UIAlertAction) -> ())? = nil)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        for actionTitle in actionTitles {
            let action = UIAlertAction(title: actionTitle, style: .Default, handler: actionHandler)
            action.alertActionIndex = actionTitles.indexOf(actionTitle)
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .Cancel, handler: cancelHandler)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
}

/// The convience version of `presentAlert(title:message:cancelTitle:cancelHandler:)`.
/// Use this func carefully, it maybe iterate many times.
public func doPresentAlert(
    title title: String = "",
    message: String,
    cancelTitle: String = "好",
    cancelHandler: ((UIAlertAction) -> ())? = nil)
{
    findLastPresentedViewController()?.presentAlert(
        title: title,
        message: message,
        cancelTitle: cancelTitle,
        cancelHandler: cancelHandler
    )
}

/// The convience version of `presentError:`.
/// Use this func carefully, it maybe iterate many times.
public func doPresentError(error: NSError) {
    findLastPresentedViewController()?.presentError(error)
}

/// The convience version of `presentActionSheet(title:message:cancelTitle:cancelHandler:actionTitles:actionHandler:)`.
/// Use this func carefully, it maybe iterate many times.
public func doPresentActionSheet(
    title title: String = "",
    message: String,
    cancelTitle: String = "取消",
    cancelHandler: ((UIAlertAction) -> ())? = nil,
    actionTitles:[String],
    actionHandler:((UIAlertAction) -> ())? = nil)
{
    findLastPresentedViewController()?.presentActionSheet(
        title: title,
        message: message,
        cancelTitle: cancelTitle,
        cancelHandler: cancelHandler,
        actionTitles: actionTitles,
        actionHandler: actionHandler
    )
}

// MARK: - Find last time presented view controller

/// Returns the most recently presented UIViewController (visible).
/// http://stackoverflow.com/questions/24825123/get-the-current-view-controller-from-the-app-delegate
public func findLastPresentedViewController() -> UIViewController? {
    guard let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController else { return nil }
    
    if let navigationController = rootViewController as? UINavigationController {
        // If the root view is a navigation controller, we can just return the visible ViewController.
        return navigationController.visibleViewController
    } else {
        // Otherwise, we must get the root UIViewController and iterate through presented views.
        var currentController: UIViewController = rootViewController
        // Each ViewController keeps track of the view it has presented, so we
        // can move from the head to the tail, which will always be the current view.
        while(nil != currentController.presentedViewController) {
            currentController = currentController.presentedViewController!
        }
        
        return currentController
    }
}

// MARK: - Present UIImagePickerController

private extension UIImagePickerController {
    private var imagePickerCompletionHandlerWrapper: ClosureWrapper<UIImagePickerController, UIImage> {
        get { return associatedObjectForKey(&AssociationKey.imagePickerCompletionHandlerWrapper) as! ClosureWrapper<UIImagePickerController, UIImage> }
        set { associateRetainObject(newValue, forKey: &AssociationKey.imagePickerCompletionHandlerWrapper) }
    }
}

public extension UIViewController {
    /// Present UIImagePickerController.
    public func presentImagePicker(sourceType sourceType: UIImagePickerControllerSourceType = .PhotoLibrary, completionHandler: ((UIImagePickerController, UIImage?) -> ())) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.videoQuality = .TypeLow
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        imagePicker.imagePickerCompletionHandlerWrapper = ClosureWrapper(closure: completionHandler, holder: imagePicker)
        presentViewController(imagePicker, animated: true, completion: nil)
    }
}

extension UIViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.imagePickerCompletionHandlerWrapper.invoke(nil)
        picker.dismissAnimated(completion: nil)
    }
    
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        BackendThreadAsyncAction { () -> Void in
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                let newImage = image.orientationTo(.Up)
                if let imageData = newImage.compressAsPossible() {
                    let resultImage = UIImage(data: imageData, scale: UIScreen.scale)
                    UIThreadAsyncAction({ () -> Void in
                        picker.imagePickerCompletionHandlerWrapper.invoke(resultImage)
                        picker.dismissAnimated(completion: nil)
                    })
                    return
                }
            }
            UIThreadAsyncAction({ () -> Void in})
        }
    }
    
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.imagePickerCompletionHandlerWrapper.invoke(image)
        picker.dismissAnimated(completion: nil)
    }
}

// MARK: - Navigation

public extension UIViewController {
    public func showViewController(viewController: UIViewController) {
        navigationController?.showViewController(viewController, sender: self)
    }
    
    public func backToPreviousViewController(animated: Bool = true) {
        if let presentingViewController = presentingViewController {
            presentingViewController.dismissViewControllerAnimated(animated, completion: nil)
        } else {
            navigationController?.popViewControllerAnimated(animated)
        }
    }
    
    public func backToRootViewController(animated: Bool = true) {
        if let presentingViewController = presentingViewController {
            presentingViewController.dismissViewControllerAnimated(animated, completion: nil)
        } else {
            navigationController?.popToRootViewControllerAnimated(animated)
        }
    }
    
    public func presentTranslucentViewController(viewController: UIViewController, modalTransitionStyle: UIModalTransitionStyle = .CoverVertical, animated flag: Bool = true, completion: (() -> Void)? = nil) {
        viewController.modalPresentationStyle = .Custom
        viewController.modalTransitionStyle = UIDevice.iOS8Plus ? modalTransitionStyle : .CrossDissolve
        // Very important
        view.window?.rootViewController?.modalPresentationStyle = UIDevice.iOS8Plus ? .FullScreen : .CurrentContext
        presentViewController(viewController, animated: flag, completion: completion)
    }
    
    public func dismissAnimated(animated: Bool = true, completion: (() -> Void)? = nil) {
        presentingViewController?.dismissViewControllerAnimated(animated, completion: completion)
    }
    
    public func addSubViewController(viewController: UIViewController) {
        viewController.willMoveToParentViewController(self)
        self.addChildViewController(viewController)
        viewController.view.frame = self.view.frame
        self.view.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
    }
}

// MARK: - UINavigationBar hidden & visible

extension UIViewController: UIGestureRecognizerDelegate {
    /// Set UINavigationBar hidden with `interactivePopGestureRecognizer` enabled.
    public func setNavigationBarInvisible() {
        // Hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)
        // Enable slide-back
        navigationController?.interactivePopGestureRecognizer?.enabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    /// Revert `setNavigationBarInvisible` effect.
    public func setNavigationBarVisible() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// MARK: - UIBarButtonItem

public extension UIBarButtonItem {
    private var barButtonItemActionHandlerWrapper: ClosureWrapper<UIBarButtonItem, Any>! {
        get { return associatedObjectForKey(&AssociationKey.barButtonItemActionHandlerWrapper) as? ClosureWrapper<UIBarButtonItem, Any> }
        set { associateRetainObject(newValue, forKey: &AssociationKey.barButtonItemActionHandlerWrapper) }
    }
    
    public class func barButtonItemWithTitle(title: String?, actionHandler: ((UIBarButtonItem, Any?) -> ())?) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(title: title, style: .Plain, target: self, action: "performActionHandler:")
        
        if let actionHandler = actionHandler {
            barButtonItem.barButtonItemActionHandlerWrapper = ClosureWrapper(closure: actionHandler, holder: barButtonItem)
        }
        
        return barButtonItem
    }
    
    public class func barButtonItemWithImage(image: UIImage?, actionHandler: ((UIBarButtonItem, Any?) -> ())?) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(image: image, style: .Plain, target: self, action: "performActionHandler:")
        
        if let actionHandler = actionHandler {
            barButtonItem.barButtonItemActionHandlerWrapper = ClosureWrapper(closure: actionHandler, holder: barButtonItem)
        }
        
        return barButtonItem
    }
    
    /// Helper func
    internal class func performActionHandler(sender: UIBarButtonItem) {
        sender.barButtonItemActionHandlerWrapper.invoke()
    }
}

public extension UIViewController {
    public func showRightBarButtonItemWithImage(image: UIImage?, actionHandler: ((UIBarButtonItem, Any?) -> ())?) {
        navigationItem.rightBarButtonItem = UIBarButtonItem.barButtonItemWithImage(image, actionHandler: actionHandler)
    }
    
    public func showRightBarButtonItemWithTitle(title: String?, actionHandler: ((UIBarButtonItem, Any?) -> ())?) {
        navigationItem.rightBarButtonItem = UIBarButtonItem.barButtonItemWithTitle(title, actionHandler: actionHandler)
    }
    
    public func showLeftBarButtonItemWithImage(image: UIImage?, actionHandler: ((UIBarButtonItem, Any?) -> ())?) {
        navigationItem.leftBarButtonItem = UIBarButtonItem.barButtonItemWithImage(image, actionHandler: actionHandler)
    }
    
    public func showLeftBarButtonItemWithTitle(title: String?, actionHandler: ((UIBarButtonItem, Any?) -> ())?) {
        navigationItem.leftBarButtonItem = UIBarButtonItem.barButtonItemWithTitle(title, actionHandler: actionHandler)
    }
}