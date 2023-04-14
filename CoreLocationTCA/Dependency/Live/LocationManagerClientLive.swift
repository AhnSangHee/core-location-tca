//
//  LocationManagerClientLive.swift
//  CoreLocationTCA
//
//  Created by Selina on 2023/04/14.
//

import Combine
import CoreLocation

import ComposableArchitecture
import Dependencies
import XCTestDynamicOverlay

extension LocationManagerClient: DependencyKey {
    public static var liveValue: Self {
        let manager = CLLocationManager()
        
        let delegate = EffectTask<LocationManager.Action>.run { subscriber in
            let delegate = LocationManagerDelegate(subscriber)
            manager.delegate = delegate
            
            return AnyCancellable {
                _ = delegate
            }
        }
            .share()
            .eraseToEffect()
        
        return Self(
            delegate: { delegate },
            locationServicesEnabled: { CLLocationManager.locationServicesEnabled() },
            authorizationStatus: { manager.authorizationStatus }
        )
    }
}

private final class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    let subscriber: EffectTask<LocationManager.Action>.Subscriber
    
    init(_ subscriber: EffectTask<LocationManager.Action>.Subscriber) {
        self.subscriber = subscriber
    }
}
