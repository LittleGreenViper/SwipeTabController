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
import SwipeTabController

/* ###################################################################################################################################### */
// MARK: - The Main View Controller for Storybard-Only Tabs -
/* ###################################################################################################################################### */
/**
 This is presented when the user selects the "Storyboard Only" button.
 */
class STVCTH_StoryboardOnly_SwipeTab_ViewController: LGV_SwipeTabViewController { }

/* ###################################################################################################################################### */
// MARK: Base Class Overrides
/* ###################################################################################################################################### */
extension STVCTH_StoryboardOnly_SwipeTab_ViewController {
    /* ################################################################## */
    /**
     Called when the view hierachy has been loaded
     */
    override func viewDidLoad() {
        self.viewControllerIDs = ["controller3"]    // Note that this is being set BEFORE calling the superclass method.
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .dark
        // It's a gradient, so the top is lighter.
        self.navigationController?.navigationBar.overrideUserInterfaceStyle = .light
        self.toolbar?.overrideUserInterfaceStyle = self.toolbarOnTop ? .light : .dark
    }
}
