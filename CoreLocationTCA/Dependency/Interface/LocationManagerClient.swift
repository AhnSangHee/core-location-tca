//
//  LocationManagerClient.swift
//  CoreLocationTCA
//
//  Created by Selina on 2023/04/14.
//

import Combine
import CoreLocation

import ComposableArchitecture
import Dependencies

struct LocationManagerClient {
    var delegate: () -> EffectTask<LocationManager.Action>
    var locationServicesEnabled: () -> Bool
    var authorizationStatus: () -> CLAuthorizationStatus
}

extension DependencyValues {
    var locationManagerClient: LocationManagerClient {
        get { self[LocationManagerClient.self] }
        set { self[LocationManagerClient.self] = newValue }
    }
}
