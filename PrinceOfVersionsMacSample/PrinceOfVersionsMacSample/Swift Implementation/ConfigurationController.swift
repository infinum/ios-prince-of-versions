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

    @IBOutlet weak var installedVersionTextField: NSTextField!
    @IBOutlet weak var macOSVersionTextField: NSTextField!

    @IBOutlet weak var minimumVersionTextField: NSTextField!
    @IBOutlet weak var minimumSDKTextField: NSTextField!
    @IBOutlet weak var latestVersionTextField: NSTextField!
    @IBOutlet weak var notificationTypeTextField: NSTextField!
    @IBOutlet weak var latestMinimumSDKTextField: NSTextField!
    @IBOutlet weak var metaTextField: NSTextField!

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        checkAppVersion()
    }
}

// MARK: - Private methods -

private extension ConfigurationController {

    func checkAppVersion() {
        let princeOfVersionsURL = URL(string: Constants.princeOfVersionsURL)!
        PrinceOfVersions().loadConfiguration(
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

    func fillUI(with infoResponse: UpdateInfo ) {
        installedVersionTextField.stringValue = infoResponse.installedVersion.description
        macOSVersionTextField.stringValue = infoResponse.sdkVersion.description
        minimumVersionTextField.stringValue = infoResponse.minimumRequiredVersion?.description ?? "-"
        minimumSDKTextField.stringValue = infoResponse.minimumSdkForMinimumRequiredVersion?.description ?? "-"
        latestVersionTextField.stringValue = infoResponse.latestVersion.description
        notificationTypeTextField.stringValue = infoResponse.notificationType == .once ? "Once" : "Always"
        latestMinimumSDKTextField.stringValue = infoResponse.minimumSdkForLatestVersion?.description ?? "-"
        metaTextField.stringValue = String(describing: infoResponse.metadata!)
    }
}
