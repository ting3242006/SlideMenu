//
//  ViewController.swift
//  SlideMenu
//
//  Created by Ting on 2023/9/12.
//

import UIKit

enum menuStatus {
    case opened
    case closed
}

class ContainerViewController: UIViewController {
    
    let homeVC = HomeViewController()
    let menuVC = MenuViewController()
    var navVC: UINavigationController?
    // Launch app 的時候還不用生成 InfoVC
    lazy var infoVC = InfoViewController()
    var menuStatus: menuStatus = .closed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        addChildVCs()
    }
    
    func addChildVCs() {
        // Menu
        menuVC.menuDelegate = self
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        
        // Home
        homeVC.homeDelegate = self
        let navVC = UINavigationController(rootViewController: homeVC)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        self.navVC = navVC
    }
}

extension ContainerViewController: HomeViewControllerDelegate {
    
    func didTapMenuButton() {
        toggleMenu(completion: nil)
    }
    
    func toggleMenu(completion: (() -> Void)?) {
        switch menuStatus {
            
        case .closed:
            // open it
            UIView.animate(withDuration: 0.5, delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = self.homeVC.view.frame.size.width - 100
            } completion: { [weak self] done in
                if done {
                    self?.menuStatus = .opened
                }
            }
            
        case .opened:
            // close it
            UIView.animate(withDuration: 0.5, delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = 0
            } completion: { [weak self] done in
                if done {
                    self?.menuStatus = .closed
                    // Present VC
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
        }
    }
}

extension ContainerViewController: MenuViewControllerDelegate {
    
    func didSelect(menuItem: MenuViewController.MenuOptions) {
        toggleMenu(completion: nil)
        switch menuItem {
        case .home:
            self.resetToHome()
        case .info:
            self.addInfoVC()
        case .appRating:
            break
        case .shareApp:
            break
        case .settings:
            break
        }
    }
    
    func addInfoVC() {
        // Add info child
        let vc = infoVC
        homeVC.addChild(vc)
        homeVC.view.addSubview(vc.view)
        vc.view.frame = homeVC.view.bounds
        vc.didMove(toParent: homeVC)
        homeVC.title = vc.title
    }
    
    func resetToHome() {
        infoVC.view.removeFromSuperview()
        infoVC.didMove(toParent: nil)
        homeVC.title = "Home"
    }
}
