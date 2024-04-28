//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Dosh on 14.04.2024.
//

import UIKit

final class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private lazy var pages: [UIViewController] = {
        let page1 = OnboardingViewController(backgrouadName: "onboarding1", labelText:  NSLocalizedString("onboarding.page1.label", comment: "Текст онбординга"))
       
        let page2 = OnboardingViewController(backgrouadName: "onboarding2", labelText:  NSLocalizedString("onboarding.page2.label", comment: "Текст онбординга"))
    
        return [page1, page2]
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypGray
        
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("onboarding.button", comment: "Кнопка перехода к основному приложению"), for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypBlack.toLight()
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textColor = .ypWhite.toLight()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
                
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        view.addSubview(pageControl)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 60),
            pageControl.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
                return nil
            }
            
            let previousIndex = viewControllerIndex - 1
            
            guard previousIndex >= 0 else {
                return nil
            }
            
            return pages[previousIndex]
        }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return nil
        }
        
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
    
    func transitionToMainApp() {
        UserDefaultsManager.shared.setOnboarded()
        let mainAppViewController = (UIApplication.shared.delegate as? AppDelegate)?.createMainAppViewController()
        UIApplication.shared.windows.first?.rootViewController = mainAppViewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

    
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let currentVC = pages[sender.currentPage]
        let currentIndex = pages.firstIndex(of: currentVC) ?? 0
        let direction: UIPageViewController.NavigationDirection = sender.currentPage > currentIndex ? .forward : .reverse
        
        setViewControllers([currentVC], direction: direction, animated: true)
    }
    
    @objc private func buttonAction(sender: UIButton) {
        transitionToMainApp()
    }
}
