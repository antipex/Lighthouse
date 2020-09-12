//
//  LighthouseViewModel.swift
//  Lighthouse
//
//  Created by Kyle Rohr on 11/9/20.
//  Copyright © 2020 Kyle Rohr. All rights reserved.
//

import Foundation
import ReactiveSwift

class LighthouseViewModel {

    enum State {
        case off
        case illuminating
        case beaconError(error: BeaconError)
    }

    private var beacon: Beacon

    private(set) lazy var state = Property<State>(mutableState)
    let mutableState: MutableProperty<State>

    init(beacon: Beacon) {
        self.beacon = beacon

        self.mutableState = MutableProperty<State>(.off)

        beacon.state.signal.observeValues { [weak self] (state) in
            guard let self = self else { return }

            switch state {
            case .advertising:
                self.mutableState.value = .illuminating
            case .idle:
                self.mutableState.value = .off
            case .error(let error):
                self.mutableState.value = .beaconError(error: error)
            }
        }
    }

    func handleToggleButtonTapped() {
        beacon.start()
    }

}
