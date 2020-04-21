//
//  ConfigurationController.swift
//  PrinceOfVersionsMacSample
//
//  Created by Jasmin Abou Aldan on 20/09/2019.
//  Copyright © 2019 infinum. All rights reserved.
//

import Cocoa
import PrinceOfVersions

class ConfigurationController: NSViewController {

    // MARK: - Private properties
    // MARK: IBOutlets

    @IBOutlet weak var updateVersionTextField: NSTextField!
    @IBOutlet weak var updateStateTextField: NSTextField!
    @IBOutlet weak var metaTextField: NSTextField!

    @IBOutlet weak var requiredVersionTextField: NSTextField!
    @IBOutlet weak var lastVersionAvailableTextField: NSTextField!
    @IBOutlet weak var installedVersionTextField: NSTextField!
    @IBOutlet weak var notificationTypeTextField: NSTextField!
    @IBOutlet weak var requirementsTextField: NSTextField!

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        checkAppVersion()
        checkAppStoreVersion()
    }
}

// MARK: - Private methods -

private extension ConfigurationController {

    var options: PoVOptions {

        let options = PoVOptions()

        options.addRequirement(key: "region") { (value) -> Bool in
            guard let value = value as? String else { return false }
            return value == "hr"
        }

        options.addRequirement(key: "bluetooth") { (value) -> Bool in
            guard let value = value as? String else { return false }
            return value.starts(with: "5")
        }

        return options
    }

    func checkAppVersion() {
        let princeOfVersionsURL = URL(string: Constants.princeOfVersionsURL)!
        PrinceOfVersions(with: options).checkForUpdates(from: princeOfVersionsURL, completion: { [unowned self] updateResultResponse in
            switch updateResultResponse.result {
            case .success(let updateResultData):
                self.fillUI(with: updateResultData)
            case .failure:
                // Handle error
                break
            }
        })

    }

    // In sample app, error will occur as bundle ID
    // of the app is not available on the App Store

    func checkAppStoreVersion() {
        // In sample app, error will occur as bundle ID
        // of the app is not available on the App Store
        let options = PoVOptions()
        options.trackPhaseRelease = false

        PrinceOfVersions(with: options).checkForUpdateFromAppStore(
            completion: { result in
                switch result {
                case .success:
                    // Handle success
                    break
                case .failure:
                    // Handle error
                    break
                }
        })
    }

    func fillUI(with infoResponse: UpdateResult) {
        fillUpdateResultUI(with: infoResponse)
        fillVersionInfoUI(with: infoResponse.versionInfo)
    }

    func fillUpdateResultUI(with infoResponse: UpdateResult) {
        updateVersionTextField.stringValue = infoResponse.updateVersion.description
        updateStateTextField.stringValue = infoResponse.updateState.description
        metaTextField.stringValue = String(format: "%@", infoResponse.metadata!)
    }

    func fillVersionInfoUI(with versionInfo: UpdateInfo) {
        requiredVersionTextField.stringValue = versionInfo.requiredVersion?.description ?? ""
        lastVersionAvailableTextField.stringValue = versionInfo.lastVersionAvailable?.description ?? ""
        installedVersionTextField.stringValue = versionInfo.installedVersion.description
        notificationTypeTextField.stringValue = versionInfo.notificationType == .once ? "ONCE" : "ALWAYS"
        requirementsTextField.stringValue = String(format: "%@", versionInfo.requirements!)
    }
}

private extension UpdateStatus {

    var description: String {
        switch self {
        case .noUpdateAvailable: return "No Update Available"
        case .requiredUpdateNeeded: return "Required Update Needed"
        case .newUpdateAvailable: return "New Update Available"
        default: return ""
        }
    }
}
