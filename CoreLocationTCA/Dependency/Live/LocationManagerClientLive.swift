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
            authorizationStatus: { manager.authorizationStatus },
            requestAlwaysAuthorization: {
                .fireAndForget {
                  #if os(iOS) || os(macOS) || os(watchOS) || targetEnvironment(macCatalyst)
                    manager.requestAlwaysAuthorization()
                  #endif
                }
            },
            requestLocation: {
                .fireAndForget { manager.requestLocation() }
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
        print(#function)
        self.subscriber.send(.didChangeAuthorization(manager))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        self.subscriber.send(.didUpdateLocations(locations))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
        self.subscriber.send(.didFailWithError(error as! LocationManager.Error))
    }
}
