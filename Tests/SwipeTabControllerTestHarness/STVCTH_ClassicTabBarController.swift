/*
 © Copyright 2025, Little Green Viper Software Development LLC
 LICENSE:
 
 MIT License
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
 modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit

/* ###################################################################################################################################### */
// MARK: - Class for The Last In A Row of Navigation Controllers -
/* ###################################################################################################################################### */
/**
 This class will add an extra "All the way back" button to the navbar.
 */
class STVCTH_ClassicTabBarController: UITabBarController {
    /* ################################################################## */
    /**
     For instantiating us.
     */
    static let storyboardID = "STVCTH_ClassicTabBarController"
}

/* ###################################################################################################################################### */
// MARK: Base Class Overrides
/* ###################################################################################################################################### */
extension STVCTH_ClassicTabBarController {
    /* ################################################################## */
    /**
     Called when the view hierachy has been loaded
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .dark
        guard let view = self.view else { return }
        
        self.setBackground(for: view)

        let normalColor = UIColor(named: "AccentColor")
        let selectedColor = UIColor.systemGray.withAlphaComponent(0.5)
        
        let normalTextAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: normalColor as Any]
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: selectedColor as Any]

        let appearance = UITabBarAppearance()
        appearance.stackedLayoutAppearance.normal.iconColor = normalColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalTextAttributes
        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedTextAttributes
        appearance.inlineLayoutAppearance.normal.iconColor = normalColor
        appearance.inlineLayoutAppearance.normal.titleTextAttributes = normalTextAttributes
        appearance.inlineLayoutAppearance.selected.iconColor = selectedColor
        appearance.inlineLayoutAppearance.selected.titleTextAttributes = selectedTextAttributes
        appearance.compactInlineLayoutAppearance.normal.iconColor = normalColor
        appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = normalTextAttributes
        appearance.compactInlineLayoutAppearance.selected.iconColor = selectedColor
        appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = selectedTextAttributes
        appearance.backgroundColor = .clear

        tabBar.standardAppearance = appearance
        tabBar.backgroundColor = .clear
        tabBar.barTintColor = .clear

        self.viewControllers?.forEach {
            guard let viewController = ($0 as? UINavigationController)?.viewControllers.first,
                  let view = viewController.view
            else { return }
            let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left.2"), style: .plain, target: self, action: #selector(backButtonHit))
            viewController.view?.backgroundColor = .clear
            viewController.navigationItem.leftBarButtonItem = backButton
            viewController.navigationController?.overrideUserInterfaceStyle = .light
            self.setBackground(for: view)
        }
    }
    
    /* ################################################################## */
    /**
     */
    func setBackground(for inView: UIView) {
        let backgroundGradientView = UIImageView(image: UIImage(named: "BackgroundGradient"))
        backgroundGradientView.contentMode = .scaleToFill
        inView.insertSubview(backgroundGradientView, at: 0)
        backgroundGradientView.translatesAutoresizingMaskIntoConstraints = false
        backgroundGradientView.topAnchor.constraint(equalTo: inView.topAnchor).isActive = true
        backgroundGradientView.leadingAnchor.constraint(equalTo: inView.leadingAnchor).isActive = true
        backgroundGradientView.trailingAnchor.constraint(equalTo: inView.trailingAnchor).isActive = true
        backgroundGradientView.bottomAnchor.constraint(equalTo: inView.bottomAnchor).isActive = true
    }
    
    /* ################################################################## */
    /**
     */
    override func viewWillAppear(_ inIsAnimated: Bool) {
        super.viewWillAppear(inIsAnimated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    /* ################################################################## */
    /**
     */
    override func viewWillDisappear(_ inIsAnimated: Bool) {
        super.viewWillDisappear(inIsAnimated)
        self.navigationController?.isNavigationBarHidden = false
    }
}

/* ###################################################################################################################################### */
// MARK: Callbacks
/* ###################################################################################################################################### */
extension STVCTH_ClassicTabBarController {
    /* ################################################################## */
    /**
     */
    @objc func backButtonHit() {
        self.navigationController?.popViewController(animated: true)
    }
}
