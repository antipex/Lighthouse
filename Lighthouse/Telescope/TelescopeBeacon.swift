//
//  TelescopeBeacon.swift
//  Lighthouse
//
//  Created by Kyle Rohr on 12/9/20.
//  Copyright © 2020 Kyle Rohr. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation

struct TelescopeBeacon: Beacon {

    let uuidString: String
    let major: CLBeaconMajorValue
    let minor: CLBeaconMinorValue
    let identifier: String

    var isSelected: Bool = false

    var displayString: String {
        return "Major: \(major), Minor: \(minor)"
    }

    private var beacon: CLBeacon?

    init(beacon: CLBeacon) {
        uuidString = beacon.uuid.uuidString
        major = beacon.major.uint16Value
        minor = beacon.minor.uint16Value
        identifier = ""
        self.beacon = beacon
    }

}
