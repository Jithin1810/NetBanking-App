//
//  ViewController.swift
//  NetBanking
//
//  Created by JiTHiN on 07/11/24.
//

import UIKit

protocol loginViewControllerDelegate: AnyObject{
    func didLogin()
    
}

class LoginViewController: UIViewController {
    
    weak var delegate : loginViewControllerDelegate?
    
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
    
    //animation
    var leadingEdgeOnScreen : CGFloat = 16
    var leadingEdgeOffScreen : CGFloat = -1000
    
    var titleLeadingAnchor: NSLayoutConstraint?
    var subtitleLeadingAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidLoad()
        signingUpButton.configuration?.showsActivityIndicator = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
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
        titleLabel.font = .systemFont(ofSize: 35, weight: .bold)
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textColor = .black
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .light)
        subtitleLabel.text = "Your premium source for all kinds of banking needs!"

    }
    
    func layout() {
        
        view.addSubview(loginView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(signingUpButton)
        view.addSubview(errorMessageLabel)
        
        //Login View Constraints
        NSLayoutConstraint.activate([
                loginView.centerYAnchor
                    .constraint(equalTo: view.centerYAnchor),
                loginView.leadingAnchor
                    .constraint(equalToSystemSpacingAfter: view.leadingAnchor,
                                multiplier: 2),
                view.trailingAnchor
                    .constraint(equalToSystemSpacingAfter: loginView.trailingAnchor,
                                multiplier: 2)
                ])
        
        //SigningButton Constraints
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
        signingUpButton.layer.cornerRadius = 10
        
        
        //ErrorMessageLabel Constraints
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
        
        //TitleLabel Constraints
        NSLayoutConstraint.activate(
[
            subtitleLabel.topAnchor
                .constraint(
                    equalToSystemSpacingBelow: titleLabel.bottomAnchor,
                    multiplier: 1
                ),
            titleLabel.trailingAnchor
                .constraint(equalTo: loginView.trailingAnchor)
        ])
        titleLeadingAnchor = titleLabel.leadingAnchor
            .constraint(equalTo: view.leadingAnchor, constant: leadingEdgeOffScreen)
        titleLeadingAnchor?.isActive = true
        
        //SubtitleLabel Constraints
        NSLayoutConstraint.activate(
[
            loginView.topAnchor
                .constraint(
                    equalToSystemSpacingBelow: subtitleLabel.bottomAnchor,
                    multiplier: 5
                ),
            view.trailingAnchor
                .constraint(
                    equalToSystemSpacingAfter: subtitleLabel.trailingAnchor,
                    multiplier: 3
                )
        ])
        subtitleLeadingAnchor = subtitleLabel.leadingAnchor
            .constraint(
                equalTo: view.leadingAnchor,
                constant: leadingEdgeOffScreen
            )
        subtitleLeadingAnchor?.isActive = true
        
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
//        if userName.isEmpty || password.isEmpty {
//            showErrorMessage("Username / Password cannot be empty")
//            return
//        }
        if userName == "" && password == "" {
            signingUpButton.configuration?.showsActivityIndicator = true
            Thread.sleep(forTimeInterval: 0.5)
            delegate?.didLogin()
        }else {
            showErrorMessage("Invalid Username / Password")
        }
    }
    private func showErrorMessage(_ message: String) {
        errorMessageLabel.text = message
        errorMessageLabel.isHidden = false
        shakeButton()
    }
}
// MARK: - Animations
extension LoginViewController {
    private func animate() {
        let animator1 = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.titleLeadingAnchor?.constant = self.leadingEdgeOnScreen
            self.subtitleLeadingAnchor?.constant = self.leadingEdgeOnScreen
            self.view.layoutIfNeeded()
        }
        animator1.startAnimation()
    }
    private func shakeButton() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, 0]
        animation.keyTimes = [0, 0.16, 0.5, 0.83, 1]
        animation.duration = 0.4

        animation.isAdditive = true
        signingUpButton.layer.add(animation, forKey: "shake")
    }
}
