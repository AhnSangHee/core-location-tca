//
//  GpsCore.swift
//  CoreLocationTCA
//
//  Created by Selina on 2023/04/14.
//

import CoreLocation

import ComposableArchitecture

public struct Gps: ReducerProtocol {
    public struct State: Equatable {
        var locationManager = LocationManager.State()
        
        public init() { }
    }
    
    public enum Action: Equatable {
        case locationManager(LocationManager.Action)
    }
    
    public var body: some ReducerProtocol<State, Action> {
        Scope(state: \.locationManager, action: /Action.locationManager) {
            LocationManager()
        }
    }
}
