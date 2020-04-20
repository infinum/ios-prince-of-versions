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
        PrinceOfVersions().checkForUpdates(from: princeOfVersionsURL, completion: { [unowned self] updateResultResponse in
            switch updateResultResponse.result {
            case .success(let updateResultData):
                self.handle(updateResultData: updateResultData)
            case .failure:
                // Handle error
                break
            }
        })
    }

    func fillUI(with appState: String, and meta: String) {
        appStateTextField.stringValue = appState
        metaTextField.stringValue = meta
    }

    func handle(updateResultData: UpdateResult) {
        switch updateResultData.updateState {
        case .newUpdateAvailable:
            let stateText = "New version is available."
            fillUI(with: stateText, and: String(describing: updateResultData.metadata!))
        case .noUpdateAvailable:
            let stateText = "There is no new app versions."
            fillUI(with: stateText, and: String(describing: updateResultData.metadata!))
        case .requiredUpdateNeeded:
            break
        default:
            break
        }
    }
}
