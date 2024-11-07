//
//  ViewController.swift
//  NetBanking
//
//  Created by JiTHiN on 07/11/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    let loginView = LoginView()
    let signingUpButton = UIButton(type: .system)
    let errorMessageLabel = UILabel()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    var userName: String? {
        loginView.usernameTextField.text
    }
    var password: String? {
        loginView.passwordTextField.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
    
    
}


extension LoginViewController {
    func style() {
        loginView.translatesAutoresizingMaskIntoConstraints = false
        
        signingUpButton.translatesAutoresizingMaskIntoConstraints = false
        signingUpButton.setTitle("Sign In", for: [])
        signingUpButton.configuration = .filled()
        signingUpButton.configuration?.imagePadding = 8
        signingUpButton.addTarget(self, action: #selector(signinTapped), for: .primaryActionTriggered)
        
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.textColor = .red
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.isHidden = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.text = "NetBanking"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textColor = .black
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = .systemFont(ofSize: 12, weight: .light)
        subtitleLabel.text = "Your premium source for all kinds of banking needs!"

    }
    
    func layout() {
        
        view.addSubview(loginView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(signingUpButton)
        view.addSubview(errorMessageLabel)
        
        NSLayoutConstraint.activate([
                loginView.centerYAnchor
                    .constraint(equalTo: view.centerYAnchor),
                loginView.leadingAnchor
                    .constraint(equalToSystemSpacingAfter: view.leadingAnchor,
                                multiplier: 1),
                view.trailingAnchor
                    .constraint(equalToSystemSpacingAfter: loginView.trailingAnchor,
                                multiplier: 1)
                ])
        

        NSLayoutConstraint.activate([
            signingUpButton.topAnchor
                .constraint(
                    equalToSystemSpacingBelow: loginView.bottomAnchor,
                    multiplier: 2
                ),
            signingUpButton.leadingAnchor
                .constraint(equalTo: loginView.leadingAnchor),
            signingUpButton.trailingAnchor
                .constraint(equalTo: loginView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            errorMessageLabel.topAnchor
                .constraint(
                    equalToSystemSpacingBelow: signingUpButton.bottomAnchor,
                    multiplier: 2
                ),
            errorMessageLabel.leadingAnchor
                .constraint(equalTo: loginView.leadingAnchor),
            errorMessageLabel.trailingAnchor
                .constraint(equalTo: loginView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor
                .constraint(
                    equalToSystemSpacingBelow: view.topAnchor,
                    multiplier: 30
                ),
            titleLabel.leadingAnchor
                .constraint(equalTo: loginView.leadingAnchor),
            titleLabel.trailingAnchor
                .constraint(equalTo: loginView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor
                .constraint(
                    equalToSystemSpacingBelow: titleLabel.bottomAnchor,
                    multiplier: 1
                ),
            subtitleLabel.leadingAnchor
                .constraint(equalTo: loginView.leadingAnchor),
            subtitleLabel.trailingAnchor
                .constraint(equalTo: loginView.trailingAnchor)
        ])
        
    }
}

extension LoginViewController {
    @objc func signinTapped() {
        errorMessageLabel.isHidden = true
        login()
    }
    private func login() {
        guard let userName = userName, let password = password else{
            assertionFailure("User name or password is nil")
            return
        }
        if userName.isEmpty || password.isEmpty {
            showErrorMessage("Username / Password cannot be empty")
            return
        }
        if userName == "Admin" && password == "Admin" {
            signingUpButton.configuration?.showsActivityIndicator = true
        }else {
            showErrorMessage("Invalid Username / Password")
        }
    }
    private func showErrorMessage(_ message: String) {
        errorMessageLabel.text = message
        errorMessageLabel.isHidden = false
    }
}
