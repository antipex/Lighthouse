//
//  LighthouseViewController.swift
//  Lighthouse
//
//  Created by Kyle Rohr on 11/9/20.
//  Copyright © 2020 Kyle Rohr. All rights reserved.
//

import UIKit
import ReactiveSwift

class LighthouseViewController: UIViewController {

    private struct Constants {
        struct Images {
            static let lighthouseOff = "lighthouse-off"
            static let lighthouseOn = "lighthouse-on"
        }
    }

    @IBOutlet weak var lighthouseView: UIImageView!
    @IBOutlet weak var toggleButton: UIButton!

    private var beacon: Beacon!

    override func viewDidLoad() {
        super.viewDidLoad()

        beacon = Beacon()

        beacon.state.signal.observeValues { [weak self] (state) in
            guard let self = self else { return }

            switch state {
            case .idle:
                self.lighthouseView.image = UIImage(named: Constants.Images.lighthouseOff)
            case .advertising:
                self.lighthouseView.image = UIImage(named: Constants.Images.lighthouseOn)
            case .error(let error):
                self.handleBeaconError(error)
            }
        }
    }

    private func handleBeaconError(_ error: BeaconError) {
        let alert = UIAlertController(title: "Error",
                                      message: "An error has occurred: " + error.localizedDescription,
                                      preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "OK",
                                      style: .cancel,
                                      handler: nil))
    }

    @IBAction func handleToggleButtonTapped(_ sender: UIButton) {


        guard let beacon = beacon else { return }

        beacon.start()
    }

}

