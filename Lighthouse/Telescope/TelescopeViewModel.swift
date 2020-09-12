//
//  TelescopeViewModel.swift
//  Lighthouse
//
//  Created by Kyle Rohr on 11/9/20.
//  Copyright © 2020 Kyle Rohr. All rights reserved.
//

import Foundation
import ReactiveSwift
import CoreBluetooth
import CoreLocation

class TelescopeViewModel: NSObject {

    enum State {
        case initial
        case foundBeacon(distanceString: String)
        case notFound
        case needsCalibration
    }

    private(set) lazy var state = Property<State>(mutableState)
    let mutableState: MutableProperty<State>

    var manager: CLLocationManager

    private var beaconRegion: CLBeaconRegion?
    private var regions = [CLBeaconRegion]()

    private var currentRssi: Int?
    private var calibration: Int?

    override init() {
        mutableState = MutableProperty<State>(.initial)

        manager = CLLocationManager()

        super.init()

        manager.delegate = self
    }

    func beginMonitoring() {
        manager.requestAlwaysAuthorization()
    }

    func distance(forRssi rssi: Int, calibration: Int) -> Double {
        let ratio = Double(calibration - rssi)

        let ratioLinear = pow(10, ratio / 20)

        return ratioLinear
    }

    func distanceString(forDistance distance: Double) -> String {
        return String(format: "%.2f m", distance)
    }

    func handleCalibrateTapped() {
        guard let currentRssi = currentRssi else { return }

        calibration = currentRssi
    }

}

extension TelescopeViewModel: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self),
            let uuid = UUID(uuidString: Constants.uuidString) else { return }

        beaconRegion = CLBeaconRegion(uuid: uuid, identifier: Constants.regionIdentifier)

        if let beaconRegion = beaconRegion {
            beaconRegion.notifyOnEntry = true

            manager.startMonitoring(for: beaconRegion)
        }
    }

    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        guard state == .inside,
            let beaconRegion = beaconRegion else { return }

        manager.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
    }

    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        guard beacons.count > 0,
              let beacon = beacons.filter({ $0.major.intValue == Constants.major && $0.minor.intValue == Constants.minor }).first else {
            calibration = nil
            currentRssi = nil

            mutableState.value = .notFound

            return
        }

        currentRssi = beacon.rssi

        if let calibration = calibration {
            let distanceMetres = distance(forRssi: beacon.rssi, calibration: calibration)

            print("RSSI: \(beacon.rssi), Distance: \(distanceMetres)")

            mutableState.value = .foundBeacon(distanceString: distanceString(forDistance: distanceMetres))
        } else {
            mutableState.value = .needsCalibration
        }
    }

}
