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
        var location: [CLLocation]?
        
        public init() { }
    }
    
    public enum Action: Equatable {
        case checklocationServicesStatus
        case checkAuthorizationStatus
        case locationServicesEnabled(TaskResult<Bool>)
        case requestAuthorizationStatus
        case didChangeAuthorization(CLLocationManager)
        case didUpdateLocations([CLLocation])
        case didFailWithError(String)
        case showAlert(String)
    }
    
    @Dependency(\.locationManagerClient) var locationManagerClient
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .checklocationServicesStatus:
                return .task {
                    .locationServicesEnabled(
                        await TaskResult {
                            self.locationManagerClient.locationServicesEnabled()
                        }
                    )
                }
            case .checkAuthorizationStatus:
                switch state.authorizationStatus {
                case .notDetermined:
                    return locationManagerClient.requestAlwaysAuthorization().fireAndForget()
                    
                case .restricted:
                    return .task {
                        .showAlert("Please give us access to your location in settings.")
                    }

                case .denied:
                    return .task {
                        .showAlert("위치에 접근할 수 없습니다. 위치 접근 권한을 허용하시겠습니까?")
                    }

                case .authorizedAlways, .authorizedWhenInUse:
                    return locationManagerClient.requestLocation().fireAndForget()

                default:
                    return .none
                }
            case .locationServicesEnabled(.success):
                return .task {
                    .requestAuthorizationStatus
                }
            case .locationServicesEnabled(.failure):
                return .task {
                    .showAlert("위치서비스가 꺼져있당!")
                }
            case .requestAuthorizationStatus:
                state.authorizationStatus = locationManagerClient.authorizationStatus()
                return .task {
                    .checkAuthorizationStatus
                }
            case .didChangeAuthorization(let manager):
                state.authorizationStatus = manager.authorizationStatus
                return .task {
                    .checkAuthorizationStatus
                }
            case .didUpdateLocations(let locations):
                state.location = locations
                return .none
            case .didFailWithError(_):
                return .none
            case .showAlert:
                return .none
            }
        }
    }
}
