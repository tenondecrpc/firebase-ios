//
//  HomeViewController.swift
//  firebase-ios
//
//  Created by Cristian Paniagua on 06/13/20.
//  Copyright © 2020 Cristian Paniagua. All rights reserved.
//

import UIKit
import FirebaseAuth

enum ProviderType: String {
    case basic
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
        emailLabel.text = email
        providerLabel.text = provider.rawValue
        
    }
    

    @IBAction func logoutButtonAction(_ sender: Any) {
        switch provider {
        case .basic:
            do {
                try Auth.auth().signOut()
                self.navigationController?.popViewController(animated: true)
            } catch  {
                
            }
        }
    }
}
