//
//  ViewController.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 1/5/16.
//  Copyright © 2016 Moch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let value = "value"
        UserDefaults["some"] = value
        
        button.addControlEvents(.TouchDown) { (sender: UIButton!) -> () in
            debugPrint("TouchDown")
        }
        
        button.addControlEvents(.TouchUpInside) { (sender: UIButton!) -> () in
            debugPrint("TouchUpInside")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }


}


