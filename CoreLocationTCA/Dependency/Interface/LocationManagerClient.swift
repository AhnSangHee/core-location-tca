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
    var location: () -> CLLocation
    var authorizationStatus: () -> CLAuthorizationStatus
    var requestAlwaysAuthorization: () -> EffectTask<Never>
    var requestLocation: () -> EffectTask<Never>
    var requestWhenInUseAuthorization: () -> EffectTask<Never>
    var startUpdatingLocation: () -> EffectTask<Never>
    var set: (Properties) -> EffectTask<Never>
    
    public func set(
        allowsBackgroundLocationUpdates: Bool? = nil,
        showsBackgroundLocationIndicator: Bool? = nil
    ) -> EffectTask<Never> {
        self.set(
            Properties(
                allowsBackgroundLocationUpdates: allowsBackgroundLocationUpdates,
                showsBackgroundLocationIndicator: showsBackgroundLocationIndicator
            )
        )
    }
}

extension LocationManagerClient {
    public struct Properties {
        @available(macOS, unavailable)
        @available(tvOS, unavailable)
        var allowsBackgroundLocationUpdates: Bool? = nil
        
        @available(macOS, unavailable)
        @available(tvOS, unavailable)
        @available(watchOS, unavailable)
        var showsBackgroundLocationIndicator: Bool? = nil
    }
}

extension DependencyValues {
    var locationManagerClient: LocationManagerClient {
        get { self[LocationManagerClient.self] }
        set { self[LocationManagerClient.self] = newValue }
    }
}
