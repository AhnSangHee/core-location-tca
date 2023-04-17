//
//  LocationManagerCore.swift
//  CoreLocationTCA
//
//  Created by Selina on 2023/04/14.
//

import CoreLocation
import SwiftUI

import ComposableArchitecture

public struct LocationManager: ReducerProtocol {
    public struct State: Equatable {
        var authorizationStatus: CLAuthorizationStatus?
        var alert: AlertState<Action>?
        
        public init() { }
    }
    
    public enum Action: Equatable {
        case alertDismissed
        case checklocationServicesStatus
        case locationServicesEnabled(TaskResult<Bool>)
        case requestAuthorizationStatus
        case didChangeAuthorization(CLLocationManager)
        case didUpdateLocations([CLLocation])
        case didFailWithError(Error)
        case showAlert
    }
    
    public struct Error: Swift.Error, Equatable {
      public let error: NSError

      public init(_ error: Swift.Error) {
        self.error = error as NSError
      }
    }
    
    @Dependency(\.locationManagerClient) var locationManagerClient
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .alertDismissed:
                state.alert = nil
                return .none
            case .checklocationServicesStatus:
                return .task {
                    .locationServicesEnabled(
                        await TaskResult {
                            self.locationManagerClient.locationServicesEnabled()
                        }
                    )
                }
            case .locationServicesEnabled(.success):
                return .task {
                    .requestAuthorizationStatus
                }
            case .locationServicesEnabled(.failure):
                state.alert = .init(title: TextState("위치서비스가 꺼져있당!"))
                return .none
            case .requestAuthorizationStatus:
                state.authorizationStatus = locationManagerClient.authorizationStatus()
                
                switch state.authorizationStatus {
                case .notDetermined:
                    print("1")
                    return locationManagerClient.requestAlwaysAuthorization().fireAndForget()
                case .restricted:
                    print("2")
                    state.alert = .init(title: TextState("Please give us access to your location in settings."))
                    return .none

                case .denied:
                    print("3")
                    state.alert = AlertState(
                        title: { TextState("알림") },
                        actions: {
                            ButtonState(
                                role: .cancel,
                                action: .alertDismissed,
                                label: { TextState("취소") }
                            )

                            ButtonState(
                                role: .none,
                                action: .showAlert.self,
                                label: { TextState("확인") }
                            )
                        },
                        message: { TextState("위치에 접근할 수 없습니다. 위치 접근 권한을 허용하시겠습니까?") }
                    )
//                    state.alert = .init(title: TextState("Please give us access to your location in settings."))
                    return .none

                case .authorizedAlways, .authorizedWhenInUse:
                    print("4")
                    return locationManagerClient.requestLocation().fireAndForget()

                default:
                    print("5")
                    return .none
                }
            case .didChangeAuthorization(let manager):
                state.authorizationStatus = manager.authorizationStatus
                return .none
            case .didUpdateLocations(let locations):
                print("locations", locations)
//                return self.locationManagerClient.startUpdatingLocation().fireAndForget()
////                print("locations", locations)
                return .none
            case .didFailWithError(_):
                return .none
            case .showAlert:
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return .none
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { _ in })
                    return .none
                }
                return .none
            }
        }
    }
}
