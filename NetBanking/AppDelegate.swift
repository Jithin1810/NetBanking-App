//
//  AppDelegate.swift
//  NetBanking
//
//  Created by JiTHiN on 07/11/24.
//

import UIKit

let appColour : UIColor = .systemTeal

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    let loginViewController = LoginViewController()
    let onboardingViewController = OnboardingViewController()
    let mainViewController = MainViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
        loginViewController.delegate = self
        onboardingViewController.delegate = self
        
        let vc = mainViewController
        vc.setStatusBar()
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().backgroundColor = appColour
        
        window?.rootViewController = loginViewController
        
        registerForNotifications()
        
        return true
    }
    private func registerForNotifications(){
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(didLogout),
                name:.logout,
                object: nil
            )
    }

}

extension AppDelegate : loginViewControllerDelegate{
    func didLogin() {
        if LocalState.hasOnboarded{
            setRootViewController(mainViewController)
        }else{
            setRootViewController(onboardingViewController)
        }
    }
    @objc func didLogout() {
        setRootViewController(loginViewController)
    }
    
}

extension AppDelegate : OnboardingViewControllerDelegate{
    func didFinishOnBoarding() {
        LocalState.hasOnboarded = true
        setRootViewController(mainViewController)
    }
}


extension AppDelegate{
    func setRootViewController(_ vc : UIViewController, animated : Bool = true){
        guard animated, let window = self.window else{
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return
        }
        window.rootViewController = vc
        window.makeKeyAndVisible()
        UIView
            .transition(
                with: window,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: nil,
                completion: nil
            )
    }
    
}
