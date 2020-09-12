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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBeaconRegionCreated() throws {
        let beacon = Beacon()

        XCTAssertNotNil(beacon.beaconRegion)
    }

}
