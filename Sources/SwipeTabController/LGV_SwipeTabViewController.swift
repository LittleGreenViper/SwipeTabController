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
 
 \Version: 1.0.4
 */

import UIKit

/* ###################################################################################################################################### */
// MARK: - Protocol for View Controllers -
/* ###################################################################################################################################### */
/**
 Any view controller that we add to our tab controller, should conform to this protocol.
 */
public protocol LGV_SwipeTabViewControllerType: UIViewController, AnyObject {
    /* ################################################################## */
    /**
     This references the "owning" `LGV_SwipeTabViewController` instance. It is required, and should usually be implemented as a weak reference.
     */
    var mySwipeTabViewController: LGV_SwipeTabViewController? { get set }
    
    /* ################################################################## */
    /**
     An accessor for the tab item. This may return nil, but the tab controller won't add your view controller, if it does not have it.
     */
    var myTabItem: UITabBarItem? { get }
    
    /* ################################################################## */
    /**
     Returns the 0-based index of this controller, in its wrapper.
     */
    var index: Int { get }
    
    /* ################################################################## */
    /**
     An accessor for the "owner's" navigation controller.
     */
    var myMainNavigationController: UINavigationController? { get }
}

/* ###################################################################################################################################### */
// MARK: Default Implementation
/* ###################################################################################################################################### */
public extension LGV_SwipeTabViewControllerType {
    /* ################################################################## */
    /**
     Default fetches any preexisting tab bar item.
     */
    var myTabItem: UITabBarItem? {
        guard let item = self.tabBarItem,
              nil != item.image || !(item.title ?? "").isEmpty
        else { return nil }
        
        return item
    }
    
    /* ################################################################## */
    /**
     Returns the 0-based index of this controller, in its wrapper. -1, if not found.
     */
    var index: Int { self.mySwipeTabViewController?.index(of: self) ?? -1 }

    /* ################################################################## */
    /**
     This is the navigation controller for the main "owner" instance. This allows us to have continuity with the container.
     */
    var myMainNavigationController: UINavigationController? { self.mySwipeTabViewController?.navigationController }
}

/* ###################################################################################################################################### */
// MARK: - Custom Segue Placeholder Class -
/* ###################################################################################################################################### */
/**
 This gives us a class to use for custom segues.
 */
open class SwipeTabSegue: UIStoryboardSegue { }

/* ###################################################################################################################################### */
// MARK: - Baseline View Controller Class -
/* ###################################################################################################################################### */
/**
 This is a class that conforms to the `LGV_SwipeTabViewControllerType` protocol, and is also a basic `UIViewController`.
 */
open class LGV_SwipeTab_Base_ViewController: UIViewController, LGV_SwipeTabViewControllerType {
    /* ################################################################## */
    /**
     This is the "owning" "Tab" controller for this instance.
     This is set by the main container, as the class is instantiated and loaded.
     */
    public weak var mySwipeTabViewController: LGV_SwipeTabViewController?
}

/* ###################################################################################################################################### */
// MARK: Base Class Overrides
/* ###################################################################################################################################### */
extension LGV_SwipeTab_Base_ViewController {
    /* ################################################################## */
    /**
     We might use our container's navigation controller, if we didn't specify one, ourselves.
     */
    override open var navigationController: UINavigationController? { super.navigationController ?? self.myMainNavigationController }
}

@IBDesignable
/* ###################################################################################################################################### */
// MARK: - Main View Controller Class -
/* ###################################################################################################################################### */
/**
 This implements an instance of a `UIPageViewController`, as well as a `UIToolbar` instance. The toolbar acts in the same manner as a `UITabBar`,
 and is displayed either below (default), or above the page view controller.
 
 The page view controller provides the "swipe" action, and the toolbar provides the "tab bar" action.
 
 This results in behavior like Android. In Android, you can swipe between tabs, as well as select them directly.
 
 You can have the "tab bar" displayed above the page, as in Android, or below (default), as in iOS.
 
 This is a lot more limited than a real `UITabBarController`, but it should be useful for most implementations. You do have access to both the
 page view controller, and the toolbar, if you want to do more customization.
 
 It will allow you to propagate a navigation controller, applied to the container, into internal views. That's always an annoying issue with `UITabBarController`.
 You need to remember that the tab controller is hosting the navigation bar; not your embedded controller.
 */
open class LGV_SwipeTabViewController: UIViewController {
    /* ################################################################################################################################## */
    // MARK: Private Button Class for Toolbar Items
    /* ################################################################################################################################## */
    /**
     This is a button class that displays both the image and text, in a vertical or horizontal orientation.
     */
    private class _BarItem: UIBarButtonItem {
        /* ############################################################## */
        /**
         The spacing between the image and the text
         */
        private static let _kImageTextSpacingInDisplayUnits: CGFloat = 4.0
        
        /* ############################################################## */
        /**
         Default initializer.
         
         - parameters:
            - inImage: The image to display above the text.
            - inText: The text to display, under the image.
            - inTag: The tag to be applied to the button (used to match to a view controller).
            - inTarget: The callback target object.
            - inAction: The function, within the target object (must be ObjC).
            - inIsHorizontal: If true (default is false), the orientation is horizontal.
         */
        init(image inImage: UIImage?,
             text inText: String?,
             tag inTag: Int,
             target inTarget: AnyObject,
             action inAction: Selector,
             isHorizontal inIsHorizontal: Bool = false
        ) {
            super.init()

            var config = UIButton.Configuration.plain()
            config.title = inText
            config.image = inImage
            config.titleAlignment = inIsHorizontal ? .leading : .center
            config.imagePlacement = inIsHorizontal ? .leading : .top
            config.imagePadding = Self._kImageTextSpacingInDisplayUnits

            let button = UIButton(configuration: config)
            button.tag = inTag
            button.addTarget(inTarget, action: inAction, for: .touchUpInside)

            button.sizeToFit()
            self.customView = button
        }

        /* ############################################################## */
        /**
         Unsupported coder init. We just kick the can upstairs.
         - parameter inCoder: The coder object that we're supposed to use (but don't).
         */
        required init?(coder inCoder: NSCoder) { super.init(coder: inCoder) }
    }
    
    /* ################################################################## */
    /**
     This is the page view controller that will allow swiped tabs.
     */
    private weak var _pageViewController: UIPageViewController?
    
    /* ################################################################## */
    /**
     This is the toolbar, at the top or bottom.
     */
    private weak var _toolbar: UIToolbar?
    
    /* ################################################################## */
    /**
     This holds references to instantiated view controllers.
     */
    private var _referencedViewControllers: [any LGV_SwipeTabViewControllerType] = []
    
    /* ################################################################## */
    /**
     This is true (default is false), if we want the "Tab Bar" to show up on top of the screen (as opposed to the default bottom).
     > NOTE: This shouldn't be changed after the view is loaded.
     */
    @IBInspectable public var toolbarOnTop: Bool = false
    
    /* ################################################################## */
    /**
     This is true (default is false), if we want the "Tab Bar" items to show the text on the right of each item (as opposed to the default bottom).
     > NOTE: This shouldn't be changed after the view is loaded.
     */
    @IBInspectable public var textOnRight: Bool = false
    
    /* ################################################################## */
    /**
     The zero-based selected controller. Default is 0.
     */
    @IBInspectable public var selectedViewControllerIndex: Int = 0 {
        didSet {
            self.view?.setNeedsLayout()
            self.navigationItem.title = self._referencedViewControllers[self.selectedViewControllerIndex].navigationItem.title
            self.navigationItem.leftBarButtonItems = self._referencedViewControllers[self.selectedViewControllerIndex].navigationItem.leftBarButtonItems
            self.navigationItem.rightBarButtonItems = self._referencedViewControllers[self.selectedViewControllerIndex].navigationItem.rightBarButtonItems
        }
    }
    
    /* ################################################################## */
    /**
     This needs to be populated, if you want to add view controllers programmatically, but using the storyboard.
     This returns a runtime-generated list of storyboard IDs of classes that we will instantiate for each of our tabbed controllers.
     > NOTE: It's very important that this property be set BEFORE calling `super.viewDidLoad()`.
     */
    public var viewControllerIDs: [String] = []
    
    /* ################################################################## */
    /**
     This needs to be overridden, if you want to add view controllers programmatically, without using the storyboard.
     This returns a concrete array of instantiated and loaded view controller instances.
     If we are also generating via IDs (storyboard), these will be appended to the existing list, in the order prescribed, here.
     > NOTE: Declared here as "open," so it can be overridden.
     */
    open var generatedViewControllers: [any LGV_SwipeTabViewControllerType] { [] }
}

/* ###################################################################################################################################### */
// MARK: Private Computed Properties
/* ###################################################################################################################################### */
private extension LGV_SwipeTabViewController {
    /* ################################################################## */
    /**
     This uses an internal (App Store Safe) way of querying the view controller, for segues.
     In order to generate this list, you need to define segues (Custom, Modal, or Show will be fine -the segue is never executed).
     It extracts the ID from each segue, which *has to match* the storyboard ID of the view controller instance destination.
     > NOTE: This is an internal key-value property reference, and Apple may change it in the future (highly unlikely). It is not a private API.
     */
    var _referencedInterfaceBuilderViewControllerIDs: [String] {
        (self.value(forKey: "storyboardSegueTemplates") as? [NSObject] ?? []).compactMap { $0.value(forKey: "identifier") as? String }
    }
    
    /* ################################################################## */
    /**
     This holds the storyboard IDs of the view controllers we are referencing.
     This is a combination of ones defined by custom segues, and by programmatic reference.
     > NOTE: The order is based on a simple alphabetic string sort, so the storyboard IDs should be defined, with the order of the view controllers in mind.
     */
    var _referencedViewControllerIDs: [String] {
        let ret = self._referencedInterfaceBuilderViewControllerIDs + self.viewControllerIDs
        return ret.sorted()
    }
}

/* ###################################################################################################################################### */
// MARK: Private Instance Methods
/* ###################################################################################################################################### */
private extension LGV_SwipeTabViewController {
    /* ################################################################## */
    /**
     This instantiates and stores the view controllers we are referencing.
     */
    func _loadViewControllers() {
        self._referencedViewControllers = []
        #if DEBUG
            print("View Controller IDs: \(self._referencedViewControllerIDs)")
        #endif
        for id in self._referencedViewControllerIDs {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: id) as? UIViewController,
                  let myVC = vc as? LGV_SwipeTabViewControllerType,
                  nil != myVC.tabBarItem
            else { continue }
            #if DEBUG
                print("Instantiating: \(id)")
            #endif
            myVC.mySwipeTabViewController = self
            self._referencedViewControllers.append(myVC)
        }
        
        for vc in self.generatedViewControllers where !self._referencedViewControllers.contains(where: { $0 === vc }) && nil != vc.myTabItem {
            #if DEBUG
                print("Adding Pre-Instantiated View Controller: \(vc)")
            #endif
            vc.mySwipeTabViewController = self
            self._referencedViewControllers.append(vc)
        }
    }
    
    /* ################################################################## */
    /**
     This sets up the toolbar, to show the various tabitems.
     */
    func _loadToolbarItems() {
        self.toolbar?.items = []
        guard !self._referencedViewControllers.isEmpty else { return }
        var toolbarItems = [UIBarButtonItem]()
        toolbarItems.append(UIBarButtonItem.flexibleSpace())
        for viewController in self._referencedViewControllers {
            guard let tabItem = viewController.myTabItem else { continue }
            
            let barItem = _BarItem(image: tabItem.image, text: tabItem.title, tag: viewController.index, target: self, action: #selector(_toolbarItemHit), isHorizontal: self.textOnRight)

            barItem.accessibilityLabel = tabItem.accessibilityLabel
            barItem.accessibilityHint = tabItem.accessibilityHint
            barItem.accessibilityIdentifier = tabItem.accessibilityIdentifier

            toolbarItems.append(barItem)
            toolbarItems.append(UIBarButtonItem.flexibleSpace())
        }
        
        self.toolbar?.setItems(toolbarItems, animated: false)
    }
    
    /* ################################################################## */
    /**
     This sets up the arrangement of the views (top and bottom).
     */
    private func _setUpStructure() {
        guard let view = self.view,
              let toolbar = self._toolbar,
              let pageViewController = self._pageViewController
        else { return }
        
        if self.toolbarOnTop {
            toolbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            pageViewController.view.topAnchor.constraint(equalTo: toolbar.bottomAnchor).isActive = true
            pageViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            pageViewController.view.bottomAnchor.constraint(equalTo: toolbar.topAnchor).isActive = true
            pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        }
        
        self.styleToolbar()
        self._loadToolbarItems()
    }

    /* ################################################################## */
    /**
     Called when a toolbar item is hit.
     - parameter inItem: The toolbar item that was hit.
     */
    @objc private func _toolbarItemHit(_ inItem: UIButton) {
        self.selectViewController(at: inItem.tag)
    }
}

/* ###################################################################################################################################### */
// MARK: Internal Instance Methods
/* ###################################################################################################################################### */
internal extension LGV_SwipeTabViewController {
    /* ################################################################## */
    /**
     This looks up the index of the given view controller instance.
     
     - parameter inController: The instance we're looking for.
     - returns: The 0-based index, or -1, if not found.
     */
    func index(of inController: LGV_SwipeTabViewControllerType) -> Int {
        self._referencedViewControllers.firstIndex(where: { $0 === inController }) ?? -1
    }
}

/* ###################################################################################################################################### */
// MARK: Public Computed Properties
/* ###################################################################################################################################### */
public extension LGV_SwipeTabViewController {
    /* ################################################################## */
    /**
     This is the page view controller that will allow swiped tabs.
     */
    weak var pageViewController: UIPageViewController? { self._pageViewController }
    
    /* ################################################################## */
    /**
     This is the toolbar, at the top or bottom.
     */
    weak var toolbar: UIToolbar? { self._toolbar }
    
    /* ################################################################## */
    /**
     Accessor for the referenced view controllers.
     */
    var referencedViewControllers: [any LGV_SwipeTabViewControllerType] { self._referencedViewControllers }
}

/* ###################################################################################################################################### */
// MARK: Base Class Overrides
/* ###################################################################################################################################### */
extension LGV_SwipeTabViewController {
    /* ################################################################## */
    /**
     Called when the view hierarchy has been set up.
     */
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self._loadViewControllers()
        
        guard !self._referencedViewControllers.isEmpty,
              let view = self.view
        else { return }
        
        let toolbar = UIToolbar()
        self._toolbar = toolbar
        
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        self._pageViewController = pageViewController
        
        view.addSubview(toolbar)
        view.addSubview(pageViewController.view)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        toolbar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pageViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pageViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

        self._setUpStructure()
        
        self.addChild(pageViewController)
        pageViewController.didMove(toParent: self)

        pageViewController.setViewControllers(
            [self._referencedViewControllers[self.selectedViewControllerIndex]],
            direction: .forward,
            animated: false,
            completion: nil
        )
        
        // This just forces the navitem to update.
        let currentIndex = self.selectedViewControllerIndex
        self.selectedViewControllerIndex = currentIndex
    }
    
    /* ################################################################## */
    /**
     Called, when the layout will be changed.
     */
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        for item in self._toolbar?.items ?? [] {
            guard let customView = item.customView as? UIControl else { continue }
            
            item.isEnabled = customView.tag != self.selectedViewControllerIndex
            customView.isEnabled = item.isEnabled
        }
    }
}

/* ###################################################################################################################################### */
// MARK: Public Instance Methods
/* ###################################################################################################################################### */
public extension LGV_SwipeTabViewController {
    /* ################################################################## */
    /**
     Override this, to provide your own toolbar styling.
     Default, is a completely transparent toolbar.
     */
    func styleToolbar() {
        let appearance = UIToolbarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.backgroundImage = nil
        self._toolbar?.standardAppearance = appearance
        self._toolbar?.scrollEdgeAppearance = appearance
    }
    
    /* ################################################################## */
    /**
     Called to select a specific view controller.
     */
    func selectViewController(at inIndex: Int) {
        guard (0..<self._referencedViewControllers.count).contains(inIndex),
              inIndex != self.selectedViewControllerIndex
        else { return }

        #if DEBUG
            print("Select View Controller \(inIndex).")
        #endif
        
        let direction: UIPageViewController.NavigationDirection = inIndex > self.selectedViewControllerIndex ? .forward : .reverse
        self._pageViewController?.setViewControllers( [self._referencedViewControllers[inIndex]], direction: direction, animated: true, completion: nil)
        self.selectedViewControllerIndex = inIndex
    }
}

/* ###################################################################################################################################### */
// MARK: UIPageViewControllerDataSource Conformance
/* ###################################################################################################################################### */
extension LGV_SwipeTabViewController: UIPageViewControllerDataSource {
    /* ################################################################## */
    /**
     Called to provide a new view controller, when swiping.
     
     - parameter inController: The page view controller (ignored).
     - parameter inNextViewController: The view controller for the timer that will be AFTER ours
     */
    public func pageViewController(_ inController: UIPageViewController, viewControllerBefore inNextViewController: UIViewController) -> UIViewController? {
        guard let nextController = inNextViewController as? LGV_SwipeTabViewControllerType,
              (1..<self._referencedViewControllers.count).contains(nextController.index)
        else { return nil }
        return self._referencedViewControllers[nextController.index - 1]
    }
    
    /* ################################################################## */
    /**
     Called to provide a new view controller, when swiping.
     
     - parameter inController: The page view controller (ignored).
     - parameter inPrevViewController: The view controller for the timer that will be BEFORE ours
    */
    public func pageViewController(_ inController: UIPageViewController, viewControllerAfter inPrevViewController: UIViewController) -> UIViewController? {
        guard let prevController = inPrevViewController as? LGV_SwipeTabViewControllerType,
              (0..<(self._referencedViewControllers.count - 1)).contains(prevController.index)
        else { return nil }
        return self._referencedViewControllers[prevController.index + 1]
    }
}

/* ###################################################################################################################################### */
// MARK: UIPageViewControllerDelegate Conformance
/* ###################################################################################################################################### */
extension LGV_SwipeTabViewController: UIPageViewControllerDelegate {
    /* ################################################################## */
    /**
     Called when a swipe has completed.
     
     - parameter inController: The page view controller (ignored).
     - parameter didFinishAnimating: True, if the animation completed (ignored).
     - parameter previousViewControllers: The previous view controllers (ignored).
     - parameter inCompleted: True, if the transition completed (ignored).
    */
    public func pageViewController(_ inController: UIPageViewController, didFinishAnimating: Bool, previousViewControllers: [UIViewController], transitionCompleted inCompleted: Bool) {
        guard let newController = inController.viewControllers?.first as? LGV_SwipeTab_Base_ViewController else { return }
        self.selectedViewControllerIndex = newController.index
    }
}
