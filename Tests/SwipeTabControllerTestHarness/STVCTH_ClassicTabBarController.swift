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
        /* ############################################################## */
        /**
         This sets the gradient background to the view.
         
         - parameter inView: The view that will have the background.
         */
        func _setBackground(for inView: UIView) {
            let backgroundGradientView = UIImageView(image: UIImage(named: "BackgroundGradient"))
            backgroundGradientView.contentMode = .scaleToFill
            inView.insertSubview(backgroundGradientView, at: 0)
            backgroundGradientView.translatesAutoresizingMaskIntoConstraints = false
            backgroundGradientView.topAnchor.constraint(equalTo: inView.topAnchor).isActive = true
            backgroundGradientView.leadingAnchor.constraint(equalTo: inView.leadingAnchor).isActive = true
            backgroundGradientView.trailingAnchor.constraint(equalTo: inView.trailingAnchor).isActive = true
            backgroundGradientView.bottomAnchor.constraint(equalTo: inView.bottomAnchor).isActive = true
        }
        
        /* ############################################################## */
        /**
         This recursively sets the background for a view (and all its subviews) to clear.
         
         - parameter inView: The view being cleared.
         */
        func _setClearBackground(_ inView: UIView) {
            inView.backgroundColor = .clear
            inView.subviews.forEach { _setClearBackground($0) }
        }

        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .dark
        
        let normalColor = UIColor(named: "AccentColor")
        let selectedColor = UIColor.systemGray.withAlphaComponent(0.5)
        
        let normalTextAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: normalColor as Any,
                                                                   NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .footnote)]
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: selectedColor as Any,
                                                                     NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .footnote)]
        
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
            guard let view = $0.view else { return }
            _setBackground(for: view)
        }
        
        if let mainView = self.moreNavigationController.view,
           let moreRootVC = moreNavigationController.topViewController,
           let view = moreRootVC.view {
            _setBackground(for: mainView)
            _setClearBackground(view)
            UITableViewCell.appearance(whenContainedInInstancesOf: [type(of: moreRootVC)]).backgroundColor = .clear
        }
    }
    
    /* ################################################################## */
    /**
     Called when the view has appeared.
     We use this to remove the useless "Edit" button in the "More" view.
     
     - parameter inIsAnimated: True, if the appearance was animated.
     */
    override func viewDidAppear(_ inIsAnimated: Bool) {
        super.viewDidAppear(inIsAnimated)
        if let moreList = self.moreNavigationController.topViewController {
            moreList.navigationItem.rightBarButtonItem = nil
        }
    }
}

/* ###################################################################################################################################### */
// MARK: Callbacks
/* ###################################################################################################################################### */
extension STVCTH_ClassicTabBarController {
    /* ################################################################## */
    /**
     This is called to bring in the "End of the Line" view controller.
     */
    @IBAction func nextButtonHit() {
        guard let newController = self.storyboard?.instantiateViewController(withIdentifier: STVCTH_LastNav_ViewController.storyboardID) as? STVCTH_LastNav_ViewController else { return }
        self.selectedViewController?.navigationController?.pushViewController(newController, animated: true)
    }
}
