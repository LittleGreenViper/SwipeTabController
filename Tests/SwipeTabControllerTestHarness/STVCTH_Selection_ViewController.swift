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
internal import RVS_Generic_Swift_Toolbox

/* ###################################################################################################################################### */
// MARK: - Selection (Initial) View Controller Class -
/* ###################################################################################################################################### */
/**
 This presentes the user with choices as to how they want the next screen rendered.
 */
class STVCTH_Selection_ViewController: UIViewController {
    /* ################################################################## */
    /**
     The switch that denotes the position of the tab bar, in the next screen.
     */
    @IBOutlet weak var tabBarOnTopSwitch: UISwitch?
}

/* ###################################################################################################################################### */
// MARK: Callbacks
/* ###################################################################################################################################### */
extension STVCTH_Selection_ViewController {
    /* ################################################################## */
    /**
     Called when the tabBarOnTop label is hit.
     - parameter: Ignored
     */
    @IBAction func tabBarOnTopHit(_: UIButton) {
        self.tabBarOnTopSwitch?.setOn(!(self.tabBarOnTopSwitch?.isOn ?? true), animated: true)
        self.tabBarOnTopSwitch?.sendActions(for: .valueChanged)
    }
}

/* ###################################################################################################################################### */
// MARK: Base Class Overrides
/* ###################################################################################################################################### */
extension STVCTH_Selection_ViewController {
    /* ################################################################## */
    /**
     Called when the view hierarchy has been set up.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .dark
        self.navigationController?.navigationBar.overrideUserInterfaceStyle = .light
    }

    /* ################################################################## */
    /**
     Called before we switch to the next screen.
     We use this to set the toolbar position.
     
     - parameter inSegue: The segue instance.
     - parameter sender: Ignored.
     */
    override func prepare(for inSegue: UIStoryboardSegue, sender: Any?) {
        guard let destination = inSegue.destination as? STVCTH_Basic_ViewController,
              let switcheroo = self.tabBarOnTopSwitch
        else { return }
        
        destination.toolbarOnTop = switcheroo.isOn
    }
}
