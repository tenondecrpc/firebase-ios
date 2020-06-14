//
//  HomeViewController.swift
//  firebase-ios
//
//  Created by Cristian Paniagua on 06/13/20.
//  Copyright © 2020 Cristian Paniagua. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

enum ProviderType: String {
    case basic
    case google
}

class HomeViewController: UIViewController {
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var providerLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    private let email: String
    private let provider: ProviderType
    
    init(email: String, provider: ProviderType) {
        self.email = email
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Home"
        
        navigationItem.setHidesBackButton(true, animated: false)
        
        emailLabel.text = email
        providerLabel.text = provider.rawValue
        
        // Save data
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "email")
        defaults.set(provider.rawValue, forKey: "provider")
        defaults.synchronize()
    }
    

    @IBAction func logoutButtonAction(_ sender: Any) {
        // Remove data
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "provider")
        defaults.synchronize()
        
        switch provider {
        case .basic:
            self.firebaseLogOut()
        case .google:
            GIDSignIn.sharedInstance()?.signOut()
            self.firebaseLogOut()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    private func firebaseLogOut() {
        do {
            try Auth.auth().signOut()
        } catch  {
            
        }
    }
}
