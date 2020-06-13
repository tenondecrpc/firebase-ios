//
//  ViewController.swift
//  firebase-ios
//
//  Created by Cristian Paniagua on 06/13/20.
//  Copyright © 2020 Cristian Paniagua. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Analytics events
        Analytics.logEvent("app_init", parameters: ["screen":"auth_screen"])
    }


}

