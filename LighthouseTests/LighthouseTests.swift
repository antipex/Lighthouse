//
//  LighthouseTests.swift
//  LighthouseTests
//
//  Created by Kyle Rohr on 11/9/20.
//  Copyright © 2020 Kyle Rohr. All rights reserved.
//

import XCTest
@testable import Lighthouse

class LighthouseTests: XCTestCase {

    func testBeaconRegionCreated() throws {
        let beacon = LighthouseBeacon()

        XCTAssertNotNil(beacon.beaconRegion)
    }

    func testDistanceCalculation() throws {
        let calibration = -57
        let rssi = -64

        let telescopeViewModel = TelescopeViewModel()

        let distance = telescopeViewModel.distance(forRssi: rssi, calibration: calibration)

        XCTAssertEqual(distance, 2.2387211385683394)
        XCTAssertEqual(telescopeViewModel.distanceString(forDistance: distance), "2.24 m")
    }

}
