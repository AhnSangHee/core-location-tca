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
        case onAppear
        case locationManager(LocationManager.Action)
    }
    
    @Dependency(\.locationManagerClient) var locationManagerClient
    
    private struct LocationManagerId: Hashable {}
    
    public var body: some ReducerProtocol<State, Action> {
        Scope(state: \.locationManager, action: /Action.locationManager) {
            LocationManager()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return locationManagerClient.delegate().map(Action.locationManager).cancellable(id: LocationManagerId())
                
            default:
                return .none
            }
        }
    }
}
