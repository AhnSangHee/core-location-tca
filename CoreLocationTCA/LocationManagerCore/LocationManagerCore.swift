//
//  LocationManagerCore.swift
//  CoreLocationTCA
//
//  Created by Selina on 2023/04/14.
//

import ComposableArchitecture

public struct LocationManager: ReducerProtocol {
    public struct State: Equatable {
        public init() { }
    }
    
    public enum Action: Equatable { }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}
