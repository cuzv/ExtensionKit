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
    fileprivate static var alertActionIndex: String = "alertActionIndex"
    fileprivate static var imagePickerCompletionHandlerWrapper = "imagePickerCompletionHandlerWrapper"
    fileprivate static var barButtonItemActionHandlerWrapper: String = "barButtonItemActionHandlerWrapper"
}

// MARK: - Present UIAlertController

public extension UIAlertAction {
    fileprivate var alertActionIndex: Int? {
        get { return associatedObject(forKey: &AssociationKey.alertActionIndex) as? Int }
        set { associate(retainObject: newValue as AnyObject!, forKey: &AssociationKey.alertActionIndex) }
    }
    
    public var index: Int? {
        return alertActionIndex
    }
}

public extension UIViewController {
    /// Present error.
    public func presentError(_ error: NSError) {
        if let message = error.userInfo[NSLocalizedDescriptionKey] as? String {
            presentAlert(message: message)
        } else if let message = error.userInfo[NSLocalizedFailureReasonErrorKey] as? String {
            presentAlert(message: message)
        }
    }
    
    /// Present message.
    public func presentAlert(
        title: String = "",
        message: String,
        cancelTitle: String = "好",
        cancelHandler: ((UIAlertAction) -> ())? = nil,
        otherTitles: [String]? = nil,
        othersHandler: ((UIAlertAction) -> ())? = nil)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler)
        alertController.addAction(cancelAction)
        
        if let otherTitles = otherTitles {
            for otherTitle in otherTitles {
                let action = UIAlertAction(title: otherTitle, style: .default, handler: othersHandler)
                action.alertActionIndex = otherTitles.index(of: otherTitle)
                alertController.addAction(action)
            }
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    /// Present ActionSheet.
    public func presentActionSheet(
        title: String = "",
        message: String,
        cancelTitle: String = "取消",
        cancelHandler: ((UIAlertAction) -> ())? = nil,
        actionTitles: [String],
        actionHandler: ((UIAlertAction) -> ())? = nil)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for actionTitle in actionTitles {
            let action = UIAlertAction(title: actionTitle, style: .default, handler: actionHandler)
            action.alertActionIndex = actionTitles.index(of: actionTitle)
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

/// The convience version of `presentAlert(title:message:cancelTitle:cancelHandler:)`.
/// Use this func carefully, it maybe iterate many times.
public func doPresentAlert(
    title: String = "",
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

public func doPresentAlert(
    title: String = "",
    message: String,
    cancelTitle: String = "好",
    cancelHandler: ((UIAlertAction) -> ())? = nil,
    actionTitles: [String],
    actionHandler: ((UIAlertAction) -> ())? = nil)
{
    findLastPresentedViewController()?.presentAlert(
        title: title,
        message: message,
        cancelTitle: cancelTitle,
        cancelHandler: cancelHandler,
        otherTitles: actionTitles,
        othersHandler: actionHandler
    )
}

/// The convience version of `presentError:`.
/// Use this func carefully, it maybe iterate many times.
public func doPresentError(_ error: NSError) {
    findLastPresentedViewController()?.presentError(error)
}

/// The convience version of `presentActionSheet(title:message:cancelTitle:cancelHandler:actionTitles:actionHandler:)`.
/// Use this func carefully, it maybe iterate many times.
public func doPresentActionSheet(
    title: String = "",
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
    func findTopLevelViewController(_ viewController: UIViewController) -> UIViewController? {
        if let vc = viewController.presentedViewController {
            return findTopLevelViewController(vc)
        } else if let vc = viewController as? UISplitViewController  {
            if let vc = vc.viewControllers.last {
                return findTopLevelViewController(vc)
            }
            return vc
        } else if let vc = viewController as? UINavigationController {
            if let vc = vc.topViewController {
                return findTopLevelViewController(vc)
            }
            return vc
        } else if let vc = viewController as? UITabBarController {
            if let vc = vc.selectedViewController {
                return findTopLevelViewController(vc)
            }
            return vc
        } else {
            return viewController
        }
    }

    if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
        return findTopLevelViewController(rootViewController)
    }

    return nil
}

// MARK: - Present UIImagePickerController

private extension UIImagePickerController {
    var imagePickerCompletionHandlerWrapper: ClosureDecorator<(UIImagePickerController, UIImage?)> {
        get { return associatedObject(forKey: &AssociationKey.imagePickerCompletionHandlerWrapper) as! ClosureDecorator<(UIImagePickerController, UIImage?)> }
        set { associate(retainObject: newValue, forKey: &AssociationKey.imagePickerCompletionHandlerWrapper) }
    }
}

public extension UIViewController {
    /// Present UIImagePickerController.
    public func presentImagePicker(sourceType: UIImagePickerControllerSourceType = .photoLibrary, completionHandler: @escaping ((UIImagePickerController, UIImage?) -> ())) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.videoQuality = .typeLow
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        imagePicker.imagePickerCompletionHandlerWrapper = ClosureDecorator(completionHandler)
        present(imagePicker, animated: true, completion: nil)
    }
}

extension UIViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss()
        picker.imagePickerCompletionHandlerWrapper.invoke((picker, nil))
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        BackgroundThreadAsyncAction { () -> Void in
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                let newImage = image.orientationTo(.up)
                if let imageData = newImage.compressAsPossible() {
                    let resultImage = UIImage(data: imageData, scale: UIScreen.scale_var)
                    UIThreadAsyncAction({ () -> Void in
                        picker.dismiss()
                        picker.imagePickerCompletionHandlerWrapper.invoke((picker, resultImage))
                    })
                    return
                }
            }
            UIThreadAsyncAction({ () -> Void in})
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismiss()
        picker.imagePickerCompletionHandlerWrapper.invoke((picker, image))
    }
}

// MARK: - Navigation

public extension UIViewController {
    public func showViewController(_ viewController: UIViewController) {
        navigationController?.show(viewController, sender: self)
    }
    
    public func backToPreviousViewController(animated: Bool = true) {
        if let presentingViewController = presentingViewController {
            presentingViewController.dismiss(animated: animated, completion: nil)
        } else {
            _ = navigationController?.popViewController(animated: animated)
        }
    }
    
    public func backToRootViewController(animated: Bool = true) {
        if let presentingViewController = presentingViewController {
            presentingViewController.dismiss(animated: animated, completion: nil)
        } else {
            _ = navigationController?.popToRootViewController(animated: animated)
        }
    }
    
    public func presentViewController(_ viewControllerToPresent: UIViewController) {
        present(viewControllerToPresent, animated: true, completion: nil)
    }
    
    public func presentTranslucentViewController(_ viewController: UIViewController, modalTransitionStyle: UIModalTransitionStyle = .coverVertical, animated flag: Bool = true, completion: (() -> Void)? = nil) {
        viewController.modalPresentationStyle = .custom
        viewController.modalTransitionStyle = UIDevice.iOS8Plus ? modalTransitionStyle : .crossDissolve
        // Very important
        view.window?.rootViewController?.modalPresentationStyle = UIDevice.iOS8Plus ? .fullScreen : .currentContext
        present(viewController, animated: flag, completion: completion)
    }
    
    public func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        presentingViewController?.dismiss(animated: animated, completion: completion)
    }
    
    public func dismissToTop(animated: Bool = true, completion: (() -> Void)? = nil) {
        var presentedViewController = self
        while let presentingViewController = presentedViewController.presentingViewController {
            presentedViewController = presentingViewController
        }
        presentedViewController.dismiss(animated: animated, completion: completion)
    }
    
    public func addSubViewController(_ viewController: UIViewController) {
        viewController.willMove(toParentViewController: self)
        addChildViewController(viewController)
        viewController.view.frame = view.frame
        view.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }
}

// MARK: - UIBarButtonItem

public extension UIBarButtonItem {
    fileprivate var barButtonItemActionHandlerWrapper: ClosureDecorator<(UIBarButtonItem, Any?)>! {
        get { return associatedObject(forKey: &AssociationKey.barButtonItemActionHandlerWrapper) as? ClosureDecorator<(UIBarButtonItem, Any?)> }
        set { associate(retainObject: newValue, forKey: &AssociationKey.barButtonItemActionHandlerWrapper) }
    }
    
    public class func barButtonItemWith(title: String, actionHandler: ((UIBarButtonItem, Any?) -> ())?) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(UIBarButtonItem.performActionHandler(_:)))
        
        if let actionHandler = actionHandler {
            barButtonItem.barButtonItemActionHandlerWrapper = ClosureDecorator(actionHandler)
        }
        
        return barButtonItem
    }
    
    public class func barButtonItemWith(image: UIImage?, actionHandler: ((UIBarButtonItem, Any?) -> ())?) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(image: image?.originalImage, style: .plain, target: self, action: #selector(UIBarButtonItem.performActionHandler(_:)))
        
        if let actionHandler = actionHandler {
            barButtonItem.barButtonItemActionHandlerWrapper = ClosureDecorator(actionHandler)
        }

        return barButtonItem
    }
    
    public class func barButtonItemWith(systemItem item: UIBarButtonSystemItem, actionHandler: ((UIBarButtonItem, Any?) -> ())?) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: item, target: self, action: #selector(UIBarButtonItem.performActionHandler(_:)))
        if let actionHandler = actionHandler {
            barButtonItem.barButtonItemActionHandlerWrapper = ClosureDecorator(actionHandler)
        }
        
        return barButtonItem
    }
    
    /// Helper func
    internal class func performActionHandler(_ sender: UIBarButtonItem) {
        sender.barButtonItemActionHandlerWrapper.invoke((sender, nil))
    }
}

public extension UIViewController {
    public func showRightBarButtonItem(withImage image: UIImage?, actionHandler: ((UIBarButtonItem, Any?) -> ())?) {
        navigationItem.rightBarButtonItem = UIBarButtonItem.barButtonItemWith(image: image, actionHandler: actionHandler)
    }
    
    public func showRightBarButtonItem(withTitle title: String, actionHandler: ((UIBarButtonItem, Any?) -> ())?) {
        navigationItem.rightBarButtonItem = UIBarButtonItem.barButtonItemWith(title: title, actionHandler: actionHandler)
    }
    
    public func showRightBarButtonItem(withSystemItem item: UIBarButtonSystemItem, actionHandler: ((UIBarButtonItem, Any?) -> ())?) {
        navigationItem.rightBarButtonItem = UIBarButtonItem.barButtonItemWith(systemItem: item, actionHandler: actionHandler)
    }
    
    public func showLeftBarButtonItem(withImage image: UIImage?, actionHandler: ((UIBarButtonItem, Any?) -> ())?) {
        navigationItem.leftBarButtonItem = UIBarButtonItem.barButtonItemWith(image: image, actionHandler: actionHandler)
    }
    
    public func showLeftBarButtonItem(withTitle title: String, actionHandler: ((UIBarButtonItem, Any?) -> ())?) {
        navigationItem.leftBarButtonItem = UIBarButtonItem.barButtonItemWith(title: title, actionHandler: actionHandler)
    }
    
    public func showLeftBarButtonItem(withSystemItem item: UIBarButtonSystemItem, actionHandler: ((UIBarButtonItem, Any?) -> ())?) {
        navigationItem.leftBarButtonItem = UIBarButtonItem.barButtonItemWith(systemItem: item, actionHandler: actionHandler)
    }
}
