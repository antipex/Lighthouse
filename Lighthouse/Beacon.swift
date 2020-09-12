//
//  Beacon.swift
//  Lighthouse
//
//  Created by Kyle Rohr on 11/9/20.
//  Copyright © 2020 Kyle Rohr. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

class Beacon: NSObject {

    let uuidString = "E4E8C5A9-1D34-4292-814C-569D229E48C4"
    let major: CLBeaconMajorValue = 50
    let minor: CLBeaconMinorValue = 1
    let identifier = "com.kylerohr.lighthouseRegion"

    var beaconRegion: CLBeaconRegion?

    override init() {
        if let uuid = UUID(uuidString: uuidString) {
            beaconRegion = CLBeaconRegion(uuid: uuid,
                                          major: major,
                                          minor: minor,
                                          identifier: identifier)
        }
    }

    func start() {
        guard let region = beaconRegion else { return }

        let peripheral = CBPeripheralManager(delegate: self, queue: nil)
        let peripheralData = region.peripheralData(withMeasuredPower: nil)

        peripheral.startAdvertising((peripheralData as NSDictionary) as! [String: AnyObject])
    }

}

extension Beacon: CBPeripheralManagerDelegate {

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            break
        case .poweredOff:
            break
        case .resetting:
            break
        case .unauthorized:
            break
        case .unsupported:
            break
        default:
            break
        }
    }

}
