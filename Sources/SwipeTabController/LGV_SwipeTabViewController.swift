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

#if canImport(UIKit)
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
     This references the "owning" `LGV_SwipeTabViewController` instance. It should usually be implemented as a weak reference.
     */
    var mySwipeTabViewController: LGV_SwipeTabViewController? { get set }
    
    /* ################################################################## */
    /**
     An accessor for the tab item. This may return nil, but the view controller won't add it, if it does not have it.
     */
    var myTabItem: UITabBarItem? { get }
    
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
    var myTabItem: UITabBarItem? { self.tabBarItem }
    
    /* ################################################################## */
    /**
     This is the navigation controller for the main "owner" instance. This allows us to have continuity with the container.
     */
    var myMainNavigationController: UINavigationController? { self.mySwipeTabViewController?.navigationController }
}

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
     We might use our container's navigation controller, if we didn't specify one.
     */
    override public var navigationController: UINavigationController? { super.navigationController ?? self.myMainNavigationController }
}

@IBDesignable
/* ###################################################################################################################################### */
// MARK: - Main View Controller Class -
/* ###################################################################################################################################### */
/**
 This implements an instance of a `UIPageViewController`, as well as a `UIToolbar` instance. The toolbar acts in the same manner as a `UITabBar`,
 and is displayed either below (default), or above the page view controller.
 */
open class LGV_SwipeTabViewController: UIViewController {
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
     */
    @IBInspectable public var toolbarOnTop: Bool = false
}

/* ###################################################################################################################################### */
// MARK: Private Computed Properties
/* ###################################################################################################################################### */
extension LGV_SwipeTabViewController {
    /* ################################################################## */
    /**
     This uses an internal (App Store Safe) way of querying the view controller, for segues.
     In order to generate this list, you need to define segues (custom or show will be fine -the segue is never executed).
     It extracts the ID from each segue, which *has to match* the storyboard ID of the view controller instance destination.
     > NOTE: This is an internal key-value property reference, and Apple may change it in the future (highly unlikely). It is not a private API.
     */
    private var _referencedInterfaceBuilderViewControllerIDs: [String] {
        (self.value(forKey: "storyboardSegueTemplates") as? [NSObject] ?? []).compactMap { $0.value(forKey: "identifier") as? String }
    }
    
    /* ################################################################## */
    /**
     This holds the storyboard IDs of the view controllers we are referencing.
     This is a combination of ones defined by custom segues, and by programmatic reference.
     > NOTE: The order is based on a simple alphabetic string sort, so the storyboard IDs should be defined, with the order of the view controllers in mind.
     */
    private var _referencedViewControllerIDs: [String] {
        var ret = self._referencedInterfaceBuilderViewControllerIDs
        ret.append(contentsOf: self.viewControllerIDs.compactMap { !ret.contains($0) ? $0 : nil })
        return ret.sorted()
    }
}

/* ###################################################################################################################################### */
// MARK: Private Instance Methods
/* ###################################################################################################################################### */
extension LGV_SwipeTabViewController {
    /* ################################################################## */
    /**
     This instantiates and stores the view controllers we are referencing.
     */
    private func _loadViewControllers() {
        self._referencedViewControllers = []
        #if DEBUG
            print("View Controller IDs: \(self._referencedViewControllerIDs)")
        #endif
        for id in self._referencedViewControllerIDs {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: id) as? LGV_SwipeTabViewControllerType,
                  nil != vc.myTabItem
            else { continue }
            #if DEBUG
                print("Instantiating: \(id)")
            #endif
            vc.mySwipeTabViewController = self
            self._referencedViewControllers.append(vc)
        }
        
        for vc in self.generatedViewControllers where !self._referencedViewControllers.contains(where: { $0 === vc }) && nil != vc.myTabItem {
            #if DEBUG
                print("Adding Pre-Instantiated View Controller: \(vc)")
            #endif
            vc.mySwipeTabViewController = self
            self._referencedViewControllers.append(vc)
        }
    }
}

/* ###################################################################################################################################### */
// MARK: Public Computed Properties
/* ###################################################################################################################################### */
public extension LGV_SwipeTabViewController {
    /* ################################################################## */
    /**
     This needs to be overridden, if you want to add view controllers programmatically, but using the storyboard.
     This returns a runtime-generated list of storyboard IDs of classes that we will instantiate for each of our tabbed controllers.
     */
    var viewControllerIDs: [String] { [] }
    
    /* ################################################################## */
    /**
     This needs to be overridden, if you want to add view controllers programmatically, without using the storyboard.
     This returns a concrete array of instantiated and loaded view controller instances.
     If we are also generating via IDs (storyboard), these will be appended to the existing list, in the order prescribed, here.
     */
    var generatedViewControllers: [any LGV_SwipeTabViewControllerType] { [] }
    
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
}

/* ###################################################################################################################################### */
// MARK: Base Class Overrides
/* ###################################################################################################################################### */
public extension LGV_SwipeTabViewController {
    /* ################################################################## */
    /**
     Called when the view hierarchy has been set up.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        let initialLabel = UILabel()
        self.view?.addSubview(initialLabel)
        initialLabel.translatesAutoresizingMaskIntoConstraints = false
        initialLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        initialLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        initialLabel.text = "HELO WRLD"
        self._loadViewControllers()
    }
}

/* ###################################################################################################################################### */
// MARK: UIPageViewControllerDelegate Conformance
/* ###################################################################################################################################### */
extension LGV_SwipeTabViewController: UIPageViewControllerDelegate {
}
#endif
