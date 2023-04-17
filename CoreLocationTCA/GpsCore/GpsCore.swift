//
//  GpsCore.swift
//  CoreLocationTCA
//
//  Created by Selina on 2023/04/14.
//

import CoreLocation
import SwiftUI

import ComposableArchitecture

public struct Gps: ReducerProtocol {
    public struct State: Equatable {
        var alert: AlertState<Action>?
        var locationManager = LocationManager.State()
        
        public init() { }
    }
    
    public enum Action: Equatable {
        case alertDismissed
        case onAppear
        case locationManager(LocationManager.Action)
        case showAlert
    }
    
    @Dependency(\.locationManagerClient) var locationManagerClient
    
    private struct LocationManagerId: Hashable {}
    
    public var body: some ReducerProtocol<State, Action> {
        Scope(state: \.locationManager, action: /Action.locationManager) {
            LocationManager()
        }
        
        Reduce { state, action in
            switch action {
            case .alertDismissed:
                state.alert = nil
                return .none
            case .onAppear:
                return locationManagerClient.delegate().map(Action.locationManager).cancellable(id: LocationManagerId())
            case .showAlert:
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return .none
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { _ in })
                    return .none
                }
                return .none
            case .locationManager(.showAlert(let message)):
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
                    message: { TextState(message) }
                )
                return .none
            default:
                return .none
            }
        }
    }
}
