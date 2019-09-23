//
//  AutomaticCheckController.swift
//  PrinceOfVersionsMacSample
//
//  Created by Jasmin Abou Aldan on 20/09/2019.
//  Copyright © 2019 infinum. All rights reserved.
//

import Cocoa
import PrinceOfVersions

class AutomaticCheckController: NSViewController {

    // MARK: - Private properties
    // MARK: IBOutlets

     @IBOutlet weak var appStateTextField: NSTextField!
     @IBOutlet weak var metaTextField: NSTextField!

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        checkAppVersion()
    }
}

// MARK: - Private methods -

private extension AutomaticCheckController {

    func checkAppVersion() {

        let princeOfVersionsURL = URL(string: Constants.princeOfVersionsURL)!
        PrinceOfVersions().checkForUpdates(
            from: princeOfVersionsURL,
            newVersion: { [weak self] (versionData, isMinimumVersionSatisfied, meta) in
                // versionData is same as in `ConfigurationViewController`. Check example there
                let stateText = "New \(isMinimumVersionSatisfied ? "optional" : "mandatory") version is available."
                DispatchQueue.main.async {
                    self?.fillUI(with: stateText, and: String(describing: meta!))
                }
            }, noNewVersion: { [weak self] (isMinimumVersionSatisfied, meta) in
                var stateText = "There is no new app versions."
                if !isMinimumVersionSatisfied {
                    stateText += "But minimum version is not satisfied."
                }
                DispatchQueue.main.async {
                    self?.fillUI(with: stateText, and: String(describing: meta!))
                }
            }, error: { error in
                // Handle error
            }
        )
    }

    func fillUI(with appState: String, and meta: String) {
        appStateTextField.stringValue = appState
        metaTextField.stringValue = meta
    }
}
