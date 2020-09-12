//
//  LighthouseViewController.swift
//  Lighthouse
//
//  Created by Kyle Rohr on 11/9/20.
//  Copyright © 2020 Kyle Rohr. All rights reserved.
//

import UIKit

class LighthouseViewController: UIViewController {

    private struct Constants {
        struct Images {
            static let lighthouseOff = "lighthouse-off"
            static let lighthouseOn = "lighthouse-on"
        }
    }

    @IBOutlet weak var lighthouseView: UIImageView!
    @IBOutlet weak var toggleButton: UIButton!

    private var beacon: Beacon?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func handleToggleButtonTapped(_ sender: UIButton) {
        beacon = Beacon()

        guard let beacon = beacon else { return }

        beacon.start()
    }

}

