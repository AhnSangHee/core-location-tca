//
//  ContentView.swift
//  CoreLocationTCA
//
//  Created by Selina on 2023/04/14.
//

import SwiftUI

import ComposableArchitecture

public struct ContentView: View {
    let store: StoreOf<Gps>
    
    public init(store: StoreOf<Gps>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Text("Gps")
                    .onAppear {
                        viewStore.send(.locationManager(.requestAuthorizationStatus))
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: Store(
                initialState: Gps.State(),
                reducer: Gps()
            )
        )
    }
}
