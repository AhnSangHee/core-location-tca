//
//  LocationManagerClientTest.swift
//  CoreLocationTCA
//
//  Created by Selina on 2023/04/14.
//

import Dependencies
import XCTestDynamicOverlay

extension LocationManagerClient: TestDependencyKey {
    static var testValue = Self(
        delegate: unimplemented("\(Self.self).delegate"),
        locationServicesEnabled: unimplemented("\(Self.self).locationServicesEnabled"),
        authorizationStatus: unimplemented("\(Self.self).authorizationStatus"),
        requestAlwaysAuthorization: unimplemented("\(Self.self).requestAlwaysAuthorization"),
        requestLocation: unimplemented("\(Self.self).requestLocation"),
        requestWhenInUseAuthorization: unimplemented("\(Self.self).requestWhenInUseAuthorization"),
        startUpdatingLocation: unimplemented("\(Self.self).startUpdatingLocation")
    )
}
