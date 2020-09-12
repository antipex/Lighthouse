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

class LighthouseBeacon: NSObject, Beacon {

    enum State {
        case idle
        case advertising
        case error(error: BeaconError)
    }

    let uuidString = Constants.uuidString
    let major: CLBeaconMajorValue = Constants.major
    let minor: CLBeaconMinorValue = Constants.minor
    let identifier = Constants.regionIdentifier

    var beaconRegion: CLBeaconRegion?

    var peripheralManager: CBPeripheralManager?

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

        guard let peripheralManager = peripheralManager,
            peripheralManager.state == .poweredOn else {
            mutableState.value = .error(error: .notReady)

            return
        }

        let peripheralData = region.peripheralData(withMeasuredPower: nil)

        peripheralManager.startAdvertising((peripheralData as NSDictionary) as! [String: AnyObject])

        mutableState.value = .advertising
    }

    func stop() {
        peripheralManager?.stopAdvertising()

        mutableState.value = .idle
    }

}

extension LighthouseBeacon: CBPeripheralManagerDelegate {

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
