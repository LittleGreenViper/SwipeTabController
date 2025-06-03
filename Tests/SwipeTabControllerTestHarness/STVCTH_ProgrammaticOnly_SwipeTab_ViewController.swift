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
internal import SwipeTabController

/* ###################################################################################################################################### */
// MARK: - Class for Programmatic Views -
/* ###################################################################################################################################### */
/**
 The class for dynamically-generated view controllers.
 */
class STVCTH_ProgrammaticOnly_ViewController: LGV_SwipeTab_Base_ViewController {
    /* ################################################################## */
    /**
     This has the name shown in the main label.
     */
    var whatsMyName = ""
    
    /* ################################################################## */
    /**
     This displays the name.
     */
    weak var nameLabel: UILabel?
}

/* ###################################################################################################################################### */
// MARK: Base Class Overrides
/* ###################################################################################################################################### */
extension STVCTH_ProgrammaticOnly_ViewController {
    /* ################################################################## */
    /**
     Called when the view hierachy has been loaded
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let view = self.view else { return }
        self.overrideUserInterfaceStyle = .dark
        self.navigationController?.navigationBar.overrideUserInterfaceStyle = .light
        
        let myLabel = UILabel()
        myLabel.textAlignment = .center
        myLabel.textColor = .white
        myLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        myLabel.text = self.whatsMyName
        self.view.addSubview(myLabel)
        self.nameLabel = myLabel
        
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        myLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        myLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        let descriptionLabel = UILabel()
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.systemFont(ofSize: 18)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "Dynamically Generated"
        
        self.view.addSubview(descriptionLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: myLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        self.navigationItem.title = self.whatsMyName
        let endOfTheLineButton = UIBarButtonItem()
        endOfTheLineButton.image = UIImage(systemName: "chevron.right.2")
        endOfTheLineButton.target = self
        endOfTheLineButton.action = #selector(endOfTheLineHit)
        self.navigationItem.rightBarButtonItem = endOfTheLineButton
    }
}

/* ###################################################################################################################################### */
// MARK: Callbacks
/* ###################################################################################################################################### */
extension STVCTH_ProgrammaticOnly_ViewController {
    /* ################################################################## */
    /**
     This is called when the double-chevrom bar button is hit. We create and bring in a new instance of the "end of the line" controller.
     */
    @objc func endOfTheLineHit() {
        // We don't have a storyboard, but our navigation controller does.
        if let newVC = self.navigationController?.storyboard?.instantiateViewController(withIdentifier: STVCTH_LastNav_ViewController.storyboardID) as? STVCTH_LastNav_ViewController {
            self.navigationController?.pushViewController(newVC, animated: true)
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - The Main View Controller for Programmatic-Only Tabs -
/* ###################################################################################################################################### */
/**
 This is presented when the user selects the "Programmatic Only" button.
 */
class STVCTH_ProgrammaticOnly_SwipeTab_ViewController: LGV_SwipeTabViewController {
    /* ################################################################## */
    /**
     This returns a concrete array of instantiated and loaded view controller instances.
     > NOTE: This needs to be declared here, because we can't override Swift-only properties in extensions.
     */
    override var generatedViewControllers: [any LGV_SwipeTabViewControllerType] {
        var ret = [STVCTH_ProgrammaticOnly_ViewController]()
        
        for i in 0..<4 {
            let vc = STVCTH_ProgrammaticOnly_ViewController()
            vc.whatsMyName = "View \(i)"
            vc.tabBarItem = UITabBarItem(title: vc.whatsMyName, image: UIImage(systemName: "\(i).circle.fill"), tag: i)
            ret.append(vc)
        }
        
        return ret
    }
}

/* ###################################################################################################################################### */
// MARK: Base Class Overrides
/* ###################################################################################################################################### */
extension STVCTH_ProgrammaticOnly_SwipeTab_ViewController {
    /* ################################################################## */
    /**
     Called when the view hierachy has been loaded
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .dark
        self.navigationController?.navigationBar.overrideUserInterfaceStyle = .light
        self.toolbar?.overrideUserInterfaceStyle = self.toolbarOnTop ? .light : .dark
    }
}
