//
//  MainTabBarController.swift
// CustomTabBar
//

//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private let tabbarView = TabBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let tabBarSize = tabBar.bounds.size
        let offset: CGFloat
        let hasNotch = view.safeAreaInsets.bottom > 0
        
        if hasNotch {
            offset = CSp.large.HAdapted
        } else {
            offset = 0
        }
        
        tabbarView.bounds.size.width = tabBarSize.width - offset
        tabbarView.bounds.size.height = tabBarSize.height - view.safeAreaInsets.bottom
        
        tabbarView.center = CGPoint(x: tabBar.center.x, y: tabbarView.bounds.height / 2)
        
        if hasNotch {
            tabbarView.layer.cornerRadius = tabbarView.bounds.height / 2
        }
    }
    
}


private extension MainTabBarController {
    func setup() {
        
        viewControllers = TabBarButton.allCases.map { generateViewController($0)
        }
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.addSubview(tabbarView)
        tabbarView.tabBarController = self
    }
    
    private func generateViewController(_ type: TabBarButton) -> UIViewController {
        var vc: UIViewController
        switch type {
        case .task:
            vc = FusionTaskViewController()
        case .project:
            vc = UIViewController()
            vc.view.backgroundColor = .red
        case .organization:
            vc = UIViewController()
            vc.view.backgroundColor = .green
        }
        return vc
    }
}

extension MainTabBarController: TabBarControllerProtocol {}
