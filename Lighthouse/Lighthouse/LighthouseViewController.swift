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

    private var viewModel: LighthouseViewModel

    @IBOutlet weak var lighthouseView: UIImageView!
    @IBOutlet weak var toggleButton: UIButton!

    required init?(coder: NSCoder) {
        let beacon = LighthouseBeacon()

        viewModel = LighthouseViewModel(beacon: beacon)

        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.state.signal.observeValues { [weak self] (state) in
            guard let self = self else { return }

            switch state {
            case .off:
                self.lighthouseView.image = UIImage(named: Constants.Images.lighthouseOff)
                self.tabBarItem.image = UIImage(named: "lighthouse-off-tab")

                self.toggleButton.setTitle("illuminate", for: .normal)
            case .illuminating:
                self.lighthouseView.image = UIImage(named: Constants.Images.lighthouseOn)
                self.tabBarItem.image = UIImage(named: "lighthouse-on-tab")

                self.toggleButton.setTitle("obscure", for: .normal)
            case .beaconError(let error):
                self.handleBeaconError(error)
            }
        }
    }

    private func handleBeaconError(_ error: BeaconError) {
        let alert = UIAlertController(title: "Error",
                                      message: "An error has occurred: " + error.localizedDescription,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK",
                                      style: .cancel,
                                      handler: nil))
    }

    @IBAction func handleToggleButtonTapped(_ sender: UIButton) {
        viewModel.handleToggleButtonTapped()
    }

}

