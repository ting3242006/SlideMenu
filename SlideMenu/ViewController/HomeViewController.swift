//
//  HomeViewController.swift
//  SlideMenu
//
//  Created by Ting on 2023/9/12.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func didTapMenuButton()
}

class HomeViewController: UIViewController {
    
    weak var homeDelegate: HomeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "list.dash"),
            style: .done,
            target: self,
            action: #selector(didTapMenuButton))
    }
    
    @objc func didTapMenuButton() {
        homeDelegate?.didTapMenuButton()
    }


}
