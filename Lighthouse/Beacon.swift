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
import ReactiveSwift

enum BeaconError: Error {
    case unknown
    case unsupported
    case unauthorized
    case regionFailed
    case notReady
}

class Beacon: NSObject {

    enum State {
        case idle
        case advertising
        case error(error: BeaconError)
    }

    let uuidString = "E4E8C5A9-1D34-4292-814C-569D229E48C4"
    let major: CLBeaconMajorValue = 50
    let minor: CLBeaconMinorValue = 1
    let identifier = "com.kylerohr.lighthouseRegion"

    var beaconRegion: CLBeaconRegion?

    private var peripheralManager: CBPeripheralManager!

    private(set) lazy var state = Property<State>(mutableState)
    let mutableState: MutableProperty<State>

    override init() {
        if let uuid = UUID(uuidString: uuidString) {
            beaconRegion = CLBeaconRegion(uuid: uuid,
                                          major: major,
                                          minor: minor,
                                          identifier: identifier)
        }

        mutableState = MutableProperty<State>(.idle)

        super.init()

        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }

    func start() {
        guard let region = beaconRegion else {
            mutableState.value = .error(error: .regionFailed)

            return
        }

        guard peripheralManager.state == .poweredOn else {
            mutableState.value = .error(error: .notReady)

            return
        }

        let peripheralData = region.peripheralData(withMeasuredPower: nil)

        peripheralManager.startAdvertising((peripheralData as NSDictionary) as! [String: AnyObject])

        mutableState.value = .advertising
    }

}

extension Beacon: CBPeripheralManagerDelegate {

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn, .poweredOff:
            mutableState.value = .idle
        case .resetting:
            break
        case .unauthorized:
            mutableState.value = .error(error: .unauthorized)
        case .unsupported:
            mutableState.value = .error(error: .unsupported)
        default:
            mutableState.value = .error(error: .unknown)
        }
    }

}
