//
//  OnboardingViewController.swift
//  NetBanking
//
//  Created by JiTHiN on 08/11/24.
//
import UIKit

protocol OnboardingViewControllerDelegate: AnyObject{
    func didFinishOnBoarding()
}

class OnboardingViewController: UIViewController {
    
    weak var delegate : OnboardingViewControllerDelegate?

    let pageViewController: UIPageViewController
    var pages = [UIViewController]()
    var currentVC: UIViewController
    let closeButton = UIButton(type: .system)
    let nextButton = UIButton(type: .system)
    let prevButton = UIButton(type: .system)
    let finishButton = UIButton(type: .system)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        let page1 = OnboardingImageViewController(imageName: "delorean", titleText: "Netbanking is faster easier to use, and has a brand new look and feel that will make you feel like you're driving a time machine.")
        let page2 = OnboardingImageViewController(imageName: "world", titleText: "Move your money around the world with ease and securely.")
        let page3 = OnboardingImageViewController(imageName: "thumbs", titleText: "Learn more at www.NetBanking.com")
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        currentVC = pages.first!
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        style()
        layout()
        
    }
    private func setUp() {
        view.backgroundColor = .systemPurple
        
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        pageViewController.dataSource = self
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: pageViewController.view.topAnchor),
            view.leadingAnchor.constraint(equalTo: pageViewController.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: pageViewController.view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: pageViewController.view.bottomAnchor),
        ])
        
        pageViewController.setViewControllers([pages.first!], direction: .forward, animated: false, completion: nil)
        currentVC = pages.first!
    }
    private func style() {
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Close", for: [])
        closeButton
            .addTarget(
                self,
                action: #selector(closeButtonTapped),
                for: .primaryActionTriggered
            )
       
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Next >", for: [])
        nextButton
            .addTarget(
                self,
                action: #selector (nextButtonTapped),
                for: .primaryActionTriggered
            )
        
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        prevButton.setTitle("< Prev", for: [])
        prevButton
            .addTarget(
                self,
                action: #selector (prevButtonTapped),
                for: .primaryActionTriggered
            )
        prevButton.isHidden = true
        
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        finishButton.setTitle("Finish", for: [])
        finishButton
            .addTarget(
                self,
                action: #selector (finishButtonTapped),
                for: .primaryActionTriggered
            )
        finishButton.isHidden = true
        
        view.addSubview(closeButton)
        view.addSubview(prevButton)
        view.addSubview(nextButton)
        view.addSubview(finishButton)

        
    }
    private func layout() {
        
        //CloseButton
        NSLayoutConstraint.activate(
[
            closeButton.leadingAnchor
                .constraint(
                    equalToSystemSpacingAfter: view.leadingAnchor,
                    multiplier: 2),
            closeButton.topAnchor
                .constraint(
                    equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor,
                    multiplier: 2),
            
            prevButton.leadingAnchor
                .constraint(
                    equalToSystemSpacingAfter: view.leadingAnchor,
                    multiplier: 2),
            view.safeAreaLayoutGuide.bottomAnchor
                .constraint(
                    equalToSystemSpacingBelow: prevButton.bottomAnchor,
                    multiplier: 4),
            
            view.safeAreaLayoutGuide.trailingAnchor
                .constraint(
                    equalToSystemSpacingAfter: nextButton.trailingAnchor,
                    multiplier: 2),
            view.safeAreaLayoutGuide.bottomAnchor
                .constraint(
                    equalToSystemSpacingBelow: nextButton.bottomAnchor,
                    multiplier: 4),
            
            view.safeAreaLayoutGuide.trailingAnchor
                .constraint(
                    equalToSystemSpacingAfter: finishButton.trailingAnchor,
                    multiplier: 2),
            finishButton.topAnchor
                .constraint(
                    equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor,
                    multiplier: 2
                )
])
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return getPreviousViewController(from: viewController)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return getNextViewController(from: viewController)
    }

    private func getPreviousViewController(from viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index - 1 >= 0 else { return nil }
        currentVC = pages[index - 1]
        return pages[index - 1]
    }

    private func getNextViewController(from viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index + 1 < pages.count else { return nil }
        currentVC = pages[index + 1]
        return pages[index + 1]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return pages.firstIndex(of: self.currentVC) ?? 0
    }
    func pageViewController(_pageViewController : UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]){
        let vc = pendingViewControllers.first
        nextButton.isHidden = vc == pages.last
        finishButton.isHidden = !nextButton.isHidden
        prevButton.isHidden = vc == pages.first
    }
}

//MARK: - Actions

extension OnboardingViewController {
    @objc func closeButtonTapped() {
        delegate?.didFinishOnBoarding()
    }
    @objc func prevButtonTapped() {
        guard let prevVc = getPreviousViewController(from: currentVC) else { return}
        pageViewController.setViewControllers([prevVc], direction: .reverse, animated: true)
        nextButton.isHidden = false
        finishButton.isHidden = true
        if prevVc == pages[0] {
            prevButton.isHidden = true
        }
        
    }
    @objc func nextButtonTapped() {
        guard let nextVc = getNextViewController(from: currentVC) else { return}
        pageViewController.setViewControllers([nextVc], direction: .forward, animated: true)
        prevButton.isHidden = false
        if nextVc == pages[pages.count - 1] {
            nextButton.isHidden = true
            finishButton.isHidden = false
        }
        
    }
    @objc func finishButtonTapped() {
        delegate?.didFinishOnBoarding()
    }
}
