//
//  ViewController.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 1/5/16.
//  Copyright © 2016 Moch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var subview: UIView!
    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let value = "value"
//        UserDefaults["some"] = value
//        
//        button.addControlEvents(.TouchDown) { (sender: UIButton!) -> () in
//            debugPrint("TouchDown")
//        }
//        
//        button.addControlEvents(.TouchUpInside) { (sender: UIButton!) -> () in
//            debugPrint("TouchUpInside")
//        }
        
        view.tapAction { (view, ges: UIGestureRecognizer?) -> () in
            debugPrint(view)
            debugPrint(ges)
        }
        
        
        subview.doubleTapAction { (view: UIView!) -> () in
            debugPrint("双击：\(view)")
        }
        subview.tapAction { (view: UIView!) -> () in
            debugPrint("单击：\(view)")
        }
        

        
//        subview.doubleTapAction { (view, rec) -> () in
//            debugPrint("双击：\(view)")
//        }
//        
//        subview.tapAction { (view, rec) -> () in
//            debugPrint("单击：\(view)")
//        }
        
        
        
        showRightBarButtonItemWithTitle("TapME") { (bar: UIBarButtonItem, _) -> () in
            debugPrint(bar)
        }
    }
    
    override func touchesEstimatedPropertiesUpdated(touches: Set<NSObject>) {
        debugPrint("\(__FILE__):\(__LINE__):\(self.dynamicType):\(__FUNCTION__)")
    }


}


