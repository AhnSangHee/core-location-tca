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
    var locationServicesEnabled: @Sendable () -> Bool
    var authorizationStatus: () -> CLAuthorizationStatus
    var requestAlwaysAuthorization: () -> EffectTask<Never>
    var requestLocation: () -> EffectTask<Never>
    var requestWhenInUseAuthorization: () -> EffectTask<Never>
    var startUpdatingLocation: () -> EffectTask<Never>
}

extension DependencyValues {
    var locationManagerClient: LocationManagerClient {
        get { self[LocationManagerClient.self] }
        set { self[LocationManagerClient.self] = newValue }
    }
}
