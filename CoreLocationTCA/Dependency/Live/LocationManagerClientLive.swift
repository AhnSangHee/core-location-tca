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
            location: { manager.location ?? CLLocation() },
            authorizationStatus: { manager.authorizationStatus },
            requestAlwaysAuthorization: {
                .fireAndForget {
                  #if os(iOS) || os(macOS) || os(watchOS) || targetEnvironment(macCatalyst)
                    manager.requestAlwaysAuthorization()
                  #endif
                }
            },
            requestLocation: {
                .fireAndForget { manager.startUpdatingLocation() }
            },
            requestWhenInUseAuthorization: {
                .fireAndForget {
                  #if os(iOS) || os(macOS) || os(watchOS) || targetEnvironment(macCatalyst)
                    manager.requestWhenInUseAuthorization()
                  #endif
                }
            },
            startUpdatingLocation: {
                .fireAndForget {
                  #if os(iOS) || os(macOS) || os(watchOS) || targetEnvironment(macCatalyst)
                    manager.startUpdatingLocation()
                  #endif
                }
            },
            set: { properties in
                    .fireAndForget {
                  #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
                        if let allowsBackgroundLocationUpdates = properties.allowsBackgroundLocationUpdates {
                            manager.allowsBackgroundLocationUpdates = allowsBackgroundLocationUpdates
                        }
                  #endif
                  #if os(iOS) || targetEnvironment(macCatalyst)
                        if let showsBackgroundLocationIndicator = properties.showsBackgroundLocationIndicator {
                            manager.showsBackgroundLocationIndicator = showsBackgroundLocationIndicator
                        }
                  #endif
                    }
            }
        )
    }
}

private final class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    let subscriber: EffectTask<LocationManager.Action>.Subscriber
    
    init(_ subscriber: EffectTask<LocationManager.Action>.Subscriber) {
        self.subscriber = subscriber
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.subscriber.send(.didChangeAuthorization(manager))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.subscriber.send(.didUpdateLocations(locations))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.subscriber.send(.didFailWithError(error.localizedDescription))
    }
}
