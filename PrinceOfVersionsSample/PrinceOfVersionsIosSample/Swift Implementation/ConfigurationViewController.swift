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

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        checkAppVersion()
    }
}

// MARK: - Private methods -

private extension ConfigurationViewController {

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
        installedVersionLabel.text = infoResponse.installedVersion.description
        iOSVersionLabel.text = infoResponse.sdkVersion.description
        minimumVersionLabel.text = infoResponse.minimumRequiredVersion?.description
        minimumSDKLabel.text = infoResponse.minimumSdkForMinimumRequiredVersion?.description
        latestVersionLabel.text = infoResponse.latestVersion.description
        notificationTypeLabel.text = infoResponse.notificationType == .once ? "Once" : "Always"
        latestMinimumSDKLabel.text = infoResponse.minimumSdkForLatestVersion?.description
        metaLabel.text = String(describing: infoResponse.metadata!)
    }
}
