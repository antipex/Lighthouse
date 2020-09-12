//
//  Beacon.swift
//  Lighthouse
//
//  Created by Kyle Rohr on 12/9/20.
//  Copyright © 2020 Kyle Rohr. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation

enum BeaconError: Error {
    case unknown
    case unsupported
    case unauthorized
    case regionFailed
    case notReady
}

protocol Beacon {

    var uuidString: String { get }
    var major: CLBeaconMajorValue { get }
    var minor: CLBeaconMinorValue { get }
    var identifier: String { get }

}
