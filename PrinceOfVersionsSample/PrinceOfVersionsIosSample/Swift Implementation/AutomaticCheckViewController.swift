//
//  AutomaticCheckViewController.swift
//  PrinceOfVersionsSample
//
//  Created by Jasmin Abou Aldan on 13/09/2019.
//  Copyright © 2019 infinum. All rights reserved.
//

import UIKit
import PrinceOfVersions

class AutomaticCheckViewController: UIViewController {

    // MARK: - Private properties
    // MARK: IBOutlets
    @IBOutlet private var appStateLabel: UILabel!
    @IBOutlet private var metaLabel: UILabel!

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        checkAppVersion()
    }
}

// MARK: - Private methods -

private extension AutomaticCheckViewController {

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
        appStateLabel.text = appState
        metaLabel.text = meta
    }
}
