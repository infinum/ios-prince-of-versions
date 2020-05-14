//
//  ConfigurationViewController.swift
//  PrinceOfVersionsSample
//
//  Created by Jasmin Abou Aldan on 13/09/2019.
//  Copyright © 2019 infinum. All rights reserved.
//

import UIKit
import PrinceOfVersions

class ConfigurationViewController: UIViewController {

    // MARK: - Private properties
    // MARK: IBOutlets

    @IBOutlet private var installedVersionLabel: UILabel!
    @IBOutlet private var iOSVersionLabel:UILabel!

    @IBOutlet private var minimumVersionLabel: UILabel!
    @IBOutlet private var minimumSDKLabel: UILabel!
    @IBOutlet private var latestVersionLabel: UILabel!
    @IBOutlet private var notificationTypeLabel: UILabel!
    @IBOutlet private var latestMinimumSDKLabel: UILabel!
    @IBOutlet private var metaLabel: UILabel!

    @IBOutlet weak var updateVersionTextField: UILabel!
    @IBOutlet weak var updateStateTextField: UILabel!
    @IBOutlet weak var metaTextField: UILabel!

    @IBOutlet weak var requiredVersionTextField: UILabel!
    @IBOutlet weak var lastVersionAvailableTextField: UILabel!
    @IBOutlet weak var installedVersionTextField: UILabel!
    @IBOutlet weak var notificationTypeTextField: UILabel!
    @IBOutlet weak var requirementsTextField: UILabel!


    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        checkAppVersion()
        checkAppStoreVersion()
    }
}

// MARK: - Private methods -

private extension ConfigurationViewController {

    func checkAppVersion() {
        let princeOfVersionsURL = URL(string: Constants.princeOfVersionsURL)!
        PrinceOfVersions.checkForUpdates(
            from: princeOfVersionsURL,
            completion: { [weak self] response in
                switch response.result {
                case .success(let infoResponse):
                    self?.fillUI(with: infoResponse)
                case .failure:
                    // Handle error
                    break
                }
        })
    }

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
        updateVersionTextField.text = infoResponse.updateVersion.description
        updateStateTextField.text = infoResponse.updateState.updateState
        metaTextField.text = "\(infoResponse.metadata ?? [:])"
    }

    func fillVersionInfoUI(with versionInfo: UpdateInfo) {
        requiredVersionTextField.text = versionInfo.requiredVersion?.description ?? ""
        lastVersionAvailableTextField.text = versionInfo.lastVersionAvailable?.description ?? ""
        installedVersionTextField.text = versionInfo.installedVersion.description
        notificationTypeTextField.text = versionInfo.notificationType == .once ? "ONCE" : "ALWAYS"
        requirementsTextField.text = "\(versionInfo.requirements ?? [:])"
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
