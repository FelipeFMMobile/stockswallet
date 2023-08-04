//
//  IntroUIView.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 31/07/23.
//

import SwiftUI

struct IntroUIView: View {
    @State var presentSheet = false
    var body: some View {
        ZStack {
            HStack(alignment: .bottom) {
                Spacer()
                Text("Stocks")
                    .font(.largeTitle)
                Text("Wallet")
                    .font(.title3)
                Spacer()
            }
        }.task {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                presentSheet = true
            }
        }.fullScreenCover(isPresented: $presentSheet) {
            NavigationRouteView()
        }
    }
}

struct IntroUIView_Previews: PreviewProvider {
    static var previews: some View {
        IntroUIView()
    }
}
