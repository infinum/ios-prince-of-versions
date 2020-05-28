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

    @IBOutlet weak var updateVersionLabel: UILabel!
    @IBOutlet weak var updateStateLabel: UILabel!
    @IBOutlet weak var metaLabel: UILabel!

    @IBOutlet weak var requiredVersionLabel: UILabel!
    @IBOutlet weak var lastVersionAvailableLabel: UILabel!
    @IBOutlet weak var installedVersionLabel: UILabel!
    @IBOutlet weak var notificationTypeLabel: UILabel!
    @IBOutlet weak var requirementsLabel: UILabel!


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

        PrinceOfVersions.checkForUpdates(
            from: princeOfVersionsURL,
            options: options,
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
        updateVersionLabel.text = infoResponse.updateVersion.description
        updateStateLabel.text = infoResponse.updateState.updateState
        metaLabel.text = "\(infoResponse.metadata ?? [:])"
    }

    func fillVersionInfoUI(with versionInfo: UpdateInfo) {
        requiredVersionLabel.text = versionInfo.updateData.requiredVersion?.description ?? ""
        lastVersionAvailableLabel.text = versionInfo.updateData.lastVersionAvailable?.description ?? ""
        installedVersionLabel.text = versionInfo.updateData.installedVersion.description
        notificationTypeLabel.text = versionInfo.notificationType == .once ? "ONCE" : "ALWAYS"
        requirementsLabel.text = "\(versionInfo.updateData.requirements ?? [:])"
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
