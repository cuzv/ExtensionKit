//
//  ViewController.swift
//  ExtensionKit
//
//  Created by Moch Xiao on 1/5/16.
//  Copyright © 2016 Moch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let value = "value"
        UserDefaults["some"] = value
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
