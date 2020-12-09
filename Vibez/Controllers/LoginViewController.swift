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
    let apiClient = APIClient(configuration: URLSessionConfiguration.default)
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .black
        logoPlacement()
        loginButtonConfiguration()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func logoPlacement(){
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "VibezLogo")
        
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
    }
    
    func loginButtonConfiguration(){
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.layer.cornerRadius = 15
        loginButton.setTitle("Log In", for: .normal)
        loginButton.backgroundColor = .systemBlue
        
        loginButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 25).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    
    @objc func buttonPressed(){
        verifyUserAuthentication()
    }
    
    func verifyUserAuthentication(){
            let urlRequest = apiClient.getSpotifyAccessCodeURL()
            print(urlRequest)
            let scheme = "auth"
            let session = ASWebAuthenticationSession(url: urlRequest, callbackURLScheme: scheme) { (callbackURL, error) in
                guard error == nil, let callbackURL = callbackURL else { return }
                
                let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
                guard let requestAccessCode = queryItems?.first(where: { $0.name == "code" })?.value else { return }
                print(" Code \(requestAccessCode)")
                self.apiClient.call(request: .verifyAccessToken(code: requestAccessCode, completion: { (token) in
                    switch token {
                    case .failure(let error):
                        print(error)
                    case .success(let token):
                        UserDefaults.standard.set(token.accessToken, forKey: "token")
                        UserDefaults.standard.set(token.refreshToken, forKey: "refresh_token")
                    }
                }))
            }
            session.presentationContextProvider = self
            session.start()
        }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
}
