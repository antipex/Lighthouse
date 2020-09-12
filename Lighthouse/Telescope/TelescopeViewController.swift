//
//  TelescopeViewController.swift
//  Lighthouse
//
//  Created by Kyle Rohr on 11/9/20.
//  Copyright © 2020 Kyle Rohr. All rights reserved.
//

import UIKit
import ReactiveSwift

class TelescopeViewController: UIViewController {

    @IBOutlet weak var distanceLabel: UILabel!

    var viewModel: TelescopeViewModel

    required init?(coder: NSCoder) {
        viewModel = TelescopeViewModel()

        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.state.producer.startWithValues { [weak self] (state) in
            var distanceLabelText: String

            switch state {
            case .initial:
                distanceLabelText = "ready"
            case .needsCalibration:
                distanceLabelText = "needs calibration"
            case .notFound:
                distanceLabelText = "not found"
            case .foundBeacon(let distanceString):
                distanceLabelText = distanceString
            }

            self?.distanceLabel.text = distanceLabelText
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.beginMonitoring()
    }

    @IBAction func calibrateTapped(_ sender: UIButton) {
        viewModel.handleCalibrateTapped()
    }

}
