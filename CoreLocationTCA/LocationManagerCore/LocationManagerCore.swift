//
//  LocationManagerCore.swift
//  CoreLocationTCA
//
//  Created by Selina on 2023/04/14.
//

import CoreLocation

import ComposableArchitecture

public struct LocationManager: ReducerProtocol {
    public struct State: Equatable {
        var authorizationStatus: CLAuthorizationStatus?
        var alert: AlertState<Action>?
        
        public init() { }
    }
    
    public enum Action: Equatable {
        case requestAuthorizationStatus
        case locationServicesEnabled(TaskResult<Bool>)
    }
    
    @Dependency(\.locationManagerClient) var locationManagerClient
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .requestAuthorizationStatus:
                state.authorizationStatus = locationManagerClient.authorizationStatus()
                
                return .task {
                    .locationServicesEnabled(
                        await TaskResult {
                            self.locationManagerClient.locationServicesEnabled()
                        }
                    )
                }
            case .locationServicesEnabled(.success):
                return .none
            case .locationServicesEnabled(.failure):
                state.alert = .init(title: TextState("위치서비스가 꺼져있당!"))
                return .none
            }
        }
    }
}
