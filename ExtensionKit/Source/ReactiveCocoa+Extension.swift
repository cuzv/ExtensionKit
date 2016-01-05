//
//  ReactiveCocoa+Extension.swift
//  MicroShop
//
//  Created by Moch Xiao on 12/24/15.
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
import ReactiveCocoa
import Redes

// MARK: - SignalProducer

public extension SignalProducer {
    public func ignoreError() -> SignalProducer<Value, NoError> {
        return flatMapError({ _ in SignalProducer<Value, NoError>.empty })
    }
    
    public func observeOnUIScheduler() -> SignalProducer<Value, Error> {
        return observeOn(UIScheduler())
    }
    
    public func skipOnce() -> SignalProducer<Value, Error> {
        return skip(1)
    }
}

public func merge<T, E>(signals: [SignalProducer<T, E>]) -> SignalProducer<T, E> {
    return SignalProducer<SignalProducer<T, E>, E>(values: signals).flatten(.Merge)
}

// MARK: - Timer

public class CountDownTimerWrapper {
    private let startTime: NSDate
    private let interval: NSTimeInterval
    private let duration: NSTimeInterval
    private var next: ((NSTimeInterval) -> ())? = nil
    private var completion: (() -> ())? = nil
    
    private var disposable: Disposable?
    
    public init(
        startTime: NSDate = NSDate(),
        interval: NSTimeInterval = 1,
        duration: NSTimeInterval = 60,
        next: ((NSTimeInterval) -> ())? = nil,
        completion: (() -> ())? = nil)
    {
        self.startTime = startTime
        self.interval = interval
        self.duration = duration
        self.next = next
        self.completion = completion
    }
    
    private func dispose() {
        self.disposable?.dispose()
    }
    
    public func start() {
        self.disposable = {
            timer(self.interval, onScheduler: QueueScheduler.mainQueueScheduler)
                .on(disposed: { self.completion?() }, next: {
                    let overTimeInterval = $0.timeIntervalSinceDate(self.startTime)
                    let leftTimeInterval = fabs(ceil(self.duration - overTimeInterval))
                    self.next?(leftTimeInterval)
                    if leftTimeInterval <= 0 {
                        self.dispose()
                    }
                }).start()
            }()
    }
    
    deinit {
        debugPrint("CountDownTimerWrapper: \(__FUNCTION__)")
    }
}

public func countDownTimerAction(
    startTime: NSDate = NSDate(),
    interval: NSTimeInterval = 1,
    duration: NSTimeInterval = 60,
    next: ((NSTimeInterval) -> ())? = nil,
    completion: (() -> ())? = nil)
{
    CountDownTimerWrapper(
        startTime: startTime,
        interval: interval,
        duration: duration,
        next: next,
        completion: completion
    ).start()
}

// MARK: - MutableProperty
//  https://github.com/ColinEberhardt/ReactiveTwitterSearch/blob/master/ReactiveTwitterSearch/Util/UIKitExtensions.swift

private struct AssociationKey {
    private static var hidden: String  = "rac_hidden"
    private static var alpha: String   = "rac_alpha"
    private static var text: String    = "rac_text"
    private static var image: String   = "rac_image"
    private static var enabled: String = "rac_enabled"
}

/// Lazily creates a gettable associated property via the given factory.
private func lazyAssociatedProperty<T: AnyObject>(
    host: AnyObject,
    key: UnsafePointer<Void>,
    factory: ()->T) -> T
{
    return objc_getAssociatedObject(host, key) as? T ?? {
        let associatedProperty = factory()
        objc_setAssociatedObject(host, key, associatedProperty, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        return associatedProperty
    }()
}

private func lazyMutableProperty<T>(
    host: AnyObject,
    key: UnsafePointer<Void>,
    setter: T -> (),
    getter: () -> T) -> MutableProperty<T>
{
    return lazyAssociatedProperty(host, key: key) {
        let property = MutableProperty<T>(getter())
        property.producer
            .startWithNext {
                newValue in
                setter(newValue)
        }
        
        return property
    }
}

public extension UIView {
    public var rac_alpha: MutableProperty<CGFloat> {
        return lazyMutableProperty(
            self,
            key: &AssociationKey.alpha,
            setter: { self.alpha = $0 },
            getter: { self.alpha  }
        )
    }
    
    public var rac_hidden: MutableProperty<Bool> {
        return lazyMutableProperty(
            self,
            key: &AssociationKey.hidden,
            setter: { self.hidden = $0 },
            getter: { self.hidden  }
        )
    }
}

public extension UILabel {
    public var rac_text: MutableProperty<String> {
        return lazyMutableProperty(
            self,
            key: &AssociationKey.text,
            setter: { self.text = $0 },
            getter: { self.text ?? "" }
        )
    }
}

public extension UITextField {
    public func rac_textSignalProducer() -> SignalProducer<String, NoError> {
        return self.rac_textSignal().toSignalProducer()
            .map { $0 as! String }
            .ignoreError()
    }
    
    public var rac_text: MutableProperty<String> {
        return lazyAssociatedProperty(self, key: &AssociationKey.text) {
            
            self.addTarget(self, action: "changed", forControlEvents: UIControlEvents.EditingChanged)
            
            let property = MutableProperty<String>(self.text ?? "")
            property.producer
                .startWithNext {
                    newValue in
                    self.text = newValue
            }
            return property
        }
    }
    
    internal func changed() {
        rac_text.value = self.text ?? ""
    }
}

public extension UIImageView {
    public var rac_image: MutableProperty<UIImage?> {
        return lazyMutableProperty(
            self,
            key: &AssociationKey.image,
            setter: { self.image = $0 },
            getter: { self.image }
        )
    }
}

public extension UIButton {
    public var rac_enabled: MutableProperty<Bool> {
        return lazyMutableProperty(
            self,
            key: &AssociationKey.enabled,
            setter: { self.enabled = $0 },
            getter: { self.enabled }
        )
    }
}

public extension SignalProducer {
    public func rac_values(initialValue: Value) -> MutableProperty<Value> {
        let property = MutableProperty<Value>(initialValue)
        
        self.startWithNext { (value) -> () in
            property.value = value
        }
        
        return property
    }
    
    public func rac_errors(initialValue: Error) -> MutableProperty<Error> {
        let property = MutableProperty<Error>(initialValue)
        
        self.startWithFailed { (error) -> () in
            property.value = error
        }
        
        return property
    }
}

extension Signal {
    public func rac_next(initialValue: Value) -> MutableProperty<Value> {
        let property = MutableProperty<Value>(initialValue)

        self.observeNext { (value) -> () in
            property.value = value
        }
        
        return property
    }
    
    public func rac_errors(initialValue: Error) -> MutableProperty<Error> {
        let property = MutableProperty<Error>(initialValue)
        
        self.observeFailed { (error) -> () in
            property.value = error
        }
        
        return property
    }
}

extension Action {
    public func rac_errors(initialValue: Error) -> MutableProperty<Error> {
        return self.errors.rac_next(initialValue)
    }
    
    public func rac_values(initialValue: Output) -> MutableProperty<Output> {
        return self.values.rac_next(initialValue)
    }
}

// MARK: - CocoaAction

public extension UIControl {
    public func addTarget(target: CocoaAction, forControlEvents events: UIControlEvents = .TouchUpInside) {
        addTarget(target, action: CocoaAction.selector, forControlEvents: events)
    }
}

// MARK: - Redes

private extension Redes.Request {
    var asyncProducer: SignalProducer <AnyObject, NSError>  {
        return SignalProducer { observer, disposable in
            self.asyncResponseJSON({
                switch $0 {
                case let .Success(_, value):
                    observer.sendNext(value)
                    observer.sendCompleted()
                case let .Failure(_, error):
                    observer.sendFailed(error)
                }
            })
            disposable.addDisposable({
                self.cancel()
            })
        }
    }
    
    var producer: SignalProducer <AnyObject, NSError>  {
        return SignalProducer { observer, disposable in
            self.responseJSON {
                switch $0 {
                case let .Success(_, value):
                    observer.sendNext(value)
                    observer.sendCompleted()
                case let .Failure(_, error):
                    observer.sendFailed(error)
                }
            }
            disposable.addDisposable({
                self.cancel()
            })
        }
    }
}

public extension Requestable where Self: Responseable {
    public var asyncProducer: SignalProducer <AnyObject, NSError>  {
        return Redes.request(self).asyncProducer
    }
    
    public var producer: SignalProducer <AnyObject, NSError>  {
        return Redes.request(self).producer
    }
}
