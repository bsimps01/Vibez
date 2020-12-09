//
//  LoginViewController.swift
//  Vibez
//
//  Created by Benjamin Simpson on 12/5/20.
//

import Foundation
import UIKit
import AuthenticationServices
import CryptoKit

class LoginViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    
    let logoImageView = UIImageView()
    let loginButton = UIButton()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .black
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func logoPlacement(){
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "VibezLogo")
    }
    
    
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
}
