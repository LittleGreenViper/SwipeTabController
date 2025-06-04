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
class STVCTH_LastNav_ViewController: UIViewController {
    /* ################################################################## */
    /**
     For instantiating us.
     */
    static let storyboardID = "STVCTH_LastNav_ViewController"
}

/* ###################################################################################################################################### */
// MARK: Base Class Overrides
/* ###################################################################################################################################### */
extension STVCTH_LastNav_ViewController {
    /* ################################################################## */
    /**
     Called when the view hierachy has been loaded
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .dark
        let allTheWayBackButton = UIBarButtonItem()
        allTheWayBackButton.target = self
        allTheWayBackButton.action = #selector(allTheWayJose)
        allTheWayBackButton.image = UIImage(systemName: "chevron.left.2")
        self.navigationItem.leftBarButtonItem = allTheWayBackButton
    }
}

/* ###################################################################################################################################### */
// MARK: Callbacks
/* ###################################################################################################################################### */
extension STVCTH_LastNav_ViewController {
    @objc func allTheWayJose(_: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
