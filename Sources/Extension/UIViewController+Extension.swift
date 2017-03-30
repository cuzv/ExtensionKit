//
//  UIViewController+Extension.swift
//  Copyright (c) 2015-2016 Moch Xiao (http://mochxiao.com).
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
    fileprivate static var tag: String = "com.mochxiao.uialertaction.tag"
    fileprivate static var imagePickerCompletionHandlerWrapper = "com.mochxiao.uiimagepickercontroller.imagePickerCompletionHandlerWrapper"
}

// MARK: - Present UIAlertController

public extension UIAlertAction {
    /// Default value is -1.
    public fileprivate(set) var tag: Int {
        get {
            if let value = associatedObject(forKey: &AssociationKey.tag) as? Int {
                return value
            }
            return -1
        }
        set { associate(retainObject: newValue, forKey: &AssociationKey.tag) }
    }
}

public extension UIViewController {
    /// Present error.
    public func presentError(_ error: NSError) {
        if let message = error.userInfo[NSLocalizedDescriptionKey] as? String {
            presentAlert(message: message)
        } else if let message = error.userInfo[NSLocalizedFailureReasonErrorKey] as? String {
            presentAlert(message: message)
        } else {
            presentAlert(message: error.localizedDescription)
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
            for (index, title) in otherTitles.enumerated() {
                let action = UIAlertAction(title: title, style: .default, handler: othersHandler)
                action.tag = index
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
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actionHandler)
            action.tag = index
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
        imagePicker.view.tintColor = UIApplication.shared.keyWindow?.tintColor
        imagePicker.imagePickerCompletionHandlerWrapper = ClosureDecorator(completionHandler)
        present(imagePicker, animated: true, completion: nil)
    }
}

extension UIViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
        picker.imagePickerCompletionHandlerWrapper.invoke((picker, nil))
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        backgroundThreadAsync { () -> Void in
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                let newImage = image.orientation(to: .up)
                if let imageData = newImage.compress(toByte: 100 * 1024) {
                    let resultImage = UIImage(data: imageData, scale: UIScreen.main.scale)
                    mainThreadAsync {
                        picker.presentingViewController?.dismiss(animated: true, completion: nil)
                        picker.imagePickerCompletionHandlerWrapper.invoke((picker, resultImage))
                    }
                    return
                }
            }
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
        picker.imagePickerCompletionHandlerWrapper.invoke((picker, image))
    }
}

// MARK: - Navigation

public extension UIViewController {
    public func show(_ viewController: UIViewController) {
        navigationController?.show(viewController, sender: self)
    }
    
    public func backToPrevious(animated: Bool = true) {
        if let presentingViewController = presentingViewController {
            presentingViewController.dismiss(animated: animated, completion: nil)
        } else {
            _ = navigationController?.popViewController(animated: animated)
        }
    }
    
    public func backToRoot(animated: Bool = true) {
        if let presentingViewController = presentingViewController {
            presentingViewController.dismiss(animated: animated, completion: nil)
        } else {
            _ = navigationController?.popToRootViewController(animated: animated)
        }
    }
    
    public func present(_ viewControllerToPresent: UIViewController, completion: @escaping (() -> ())) {
        present(viewControllerToPresent, animated: true, completion: completion)
    }

    public func present(_ viewControllerToPresent: UIViewController) {
        present(viewControllerToPresent, animated: true, completion: nil)
    }
    
    public func presentTranslucent(_ viewController: UIViewController, modalTransitionStyle: UIModalTransitionStyle = .coverVertical, animated flag: Bool = true, completion: (() -> ())? = nil) {
        viewController.modalPresentationStyle = .custom
        viewController.modalTransitionStyle = UIDevice.iOS8x ? modalTransitionStyle : .crossDissolve
        // Very important
        view.window?.rootViewController?.modalPresentationStyle = UIDevice.iOS8x ? .fullScreen : .currentContext
        present(viewController, animated: flag, completion: completion)
    }
    
    public func dismiss(completion: (() -> Void)? = nil) {
        presentingViewController?.dismiss(animated: true, completion: completion)
    }
    
    public func dismissToTop(animated: Bool = true, completion: (() -> Void)? = nil) {
        var presentedViewController = self
        while let presentingViewController = presentedViewController.presentingViewController {
            presentedViewController = presentingViewController
        }
        presentedViewController.dismiss(animated: animated, completion: completion)
    }
    
    public func addChild(_ viewController: UIViewController) {
        viewController.willMove(toParentViewController: self)
        addChildViewController(viewController)
        viewController.view.frame = view.frame
        view.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }
}

public extension UIViewController {
    public func showRightBarButtonItem(withImage image: UIImage?, actionHandler: ((UIBarButtonItem) -> ())?) {
        navigationItem.rightBarButtonItem = UIBarButtonItem.make(image: image, actionHandler: actionHandler)
    }
    
    public func showRightBarButtonItem(withTitle title: String, actionHandler: ((UIBarButtonItem) -> ())?) {
        navigationItem.rightBarButtonItem = UIBarButtonItem.make(title: title, actionHandler: actionHandler)
    }
    
    public func showRightBarButtonItem(withSystemItem item: UIBarButtonSystemItem, actionHandler: ((UIBarButtonItem) -> ())?) {
        navigationItem.rightBarButtonItem = UIBarButtonItem.make(systemItem: item, actionHandler: actionHandler)
    }
    
    public func showLeftBarButtonItem(withImage image: UIImage?, actionHandler: ((UIBarButtonItem) -> ())?) {
        navigationItem.leftBarButtonItem = UIBarButtonItem.make(image: image, actionHandler: actionHandler)
    }
    
    public func showLeftBarButtonItem(withTitle title: String, actionHandler: ((UIBarButtonItem) -> ())?) {
        navigationItem.leftBarButtonItem = UIBarButtonItem.make(title: title, actionHandler: actionHandler)
    }
    
    public func showLeftBarButtonItem(withSystemItem item: UIBarButtonSystemItem, actionHandler: ((UIBarButtonItem) -> ())?) {
        navigationItem.leftBarButtonItem = UIBarButtonItem.make(systemItem: item, actionHandler: actionHandler)
    }
}
