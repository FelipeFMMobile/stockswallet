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
                Text(str(Strings.nameTitle))
                    .font(.largeTitle)
                HStack(spacing: 2) {
                    Text(str(Strings.nameDesc))
                        .font(.title3)
                    Image(systemName: "dollarsign.circle")
                    Image(systemName: "yensign.circle")
                    Image(systemName: "eurosign.circle")
                }
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
