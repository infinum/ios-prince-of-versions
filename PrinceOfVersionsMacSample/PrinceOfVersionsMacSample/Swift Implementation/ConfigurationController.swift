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

    var options: PoVRequestOptions {

        let options = PoVRequestOptions()

        options.addRequirement(key: "region") { (value) -> Bool in
            guard let value = value as? String else { return false }
            // Check OS localisation
            return value == "hr"
        }

        options.addRequirement(key: "bluetooth") { (value) -> Bool in
            guard let value = value as? String else { return false }
            // Check device bluetooth version
            return value.starts(with: "5")
        }

        return options
    }

    func checkAppVersion() {
        let princeOfVersionsURL = URL(string: Constants.princeOfVersionsURL)!
        PrinceOfVersions.checkForUpdates(from: princeOfVersionsURL, options: options, completion: { [unowned self] response in
            switch response.result {
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
        PrinceOfVersions.checkForUpdateFromAppStore(
            trackPhaseRelease: false,
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
        updateStateTextField.stringValue = infoResponse.updateState.updateState
        metaTextField.stringValue = "\(infoResponse.metadata ?? [:])"
    }

    func fillVersionInfoUI(with versionInfo: UpdateInfo) {
        requiredVersionTextField.stringValue = versionInfo.updateInfo.requiredVersion?.description ?? ""
        lastVersionAvailableTextField.stringValue = versionInfo.updateInfo.lastVersionAvailable?.description ?? ""
        installedVersionTextField.stringValue = versionInfo.updateInfo.installedVersion.description
        notificationTypeTextField.stringValue = versionInfo.notificationType == .once ? "ONCE" : "ALWAYS"
        requirementsTextField.stringValue = "\(versionInfo.updateInfo.requirements ?? [:])"
    }
}

private extension UpdateStatus {

    var updateState: String {
        switch self {
        case .noUpdateAvailable: return "No Update Available"
        case .requiredUpdateNeeded: return "Required Update Needed"
        case .newUpdateAvailable: return "New Update Available"
        default: return ""
        }
    }
}
