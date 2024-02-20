//
//  WelcomeSwiftUIView.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 09/08/23.
//

import SwiftUI

struct WelcomeSwiftUIView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showDetail = false
    @State private var showTutorial = false
    @State var ySize: CGSize = .zero
    @State var yTextSize: CGSize = .zero
    @State var wellComeText: String = ""
    @State var tutorial1Text: String = ""
    var body: some View {
        VStack {
            Spacer(minLength: 10.0)
            VStack(spacing: 5.0) {
                HStack(alignment: .center) {
                    Image(systemName: "dollarsign.circle")
                        .scaleEffect(showDetail ? 1 : 1.5)
                        .animation(.easeOut(duration: 1).delay(0.5), value: showDetail)
                    Image(systemName: "yensign.circle")
                        .scaleEffect(showDetail ? 1 : 1.5)
                        .animation(.easeOut(duration: 1).delay(1), value: showDetail)
                    Image(systemName: "eurosign.circle")
                        .scaleEffect(showDetail ? 1 : 1.5)
                        .animation(.easeOut(duration: 1).delay(1.5), value: showDetail)
                    
                }
                HStack(alignment: .bottom, spacing: 4) {
                    Text(str(Strings.nameTitle))
                        .font(.largeTitle)
                    Text(str(Strings.nameDesc))
                        .font(.title3)
                }
            }
            .offset(ySize)
            .animation(.easeOut(duration: 1).delay(1.6),
                       value: ySize)
            VStack(alignment: .leading, spacing: 20.0) {
                Text(wellComeText)
                    .font(.title3)
                    .multilineTextAlignment(.leading)
                    .offset(yTextSize)
                    .opacity(showDetail ? 1: 0)
                    .animation(.easeIn(duration: 1.5).delay(1.8),
                               value: showDetail)
                VStack(alignment: .leading, spacing: 4.0) {
                    Text(str(Strings.tutorial1))
                        .font(.body)
                        .foregroundColor(Color(ColorResource.darkGray))
                        .offset(yTextSize)
                        .opacity(showTutorial ? 1: 0)
                        .multilineTextAlignment(.leading)
                        .animation(.easeIn(duration: 1.5).delay(6.0),
                                   value: showTutorial)
                    Text(str(Strings.tutorial2))
                        .font(.body)
                        .offset(yTextSize)
                        .foregroundColor(Color(ColorResource.darkGray))
                        .opacity(showTutorial ? 1: 0)
                        .multilineTextAlignment(.leading)
                        .animation(.easeIn(duration: 1.5).delay(6.5),
                                   value: showTutorial)
                }
                Button {
                    dismiss()
                } label: {
                    Text(str(Strings.tutorial3))
                        .font(.title2).bold()
                }
                .offset(yTextSize)
                .opacity(showTutorial ? 1: 0)
                .animation(.easeIn(duration: 1.5).delay(7.0),
                           value: showTutorial)
            }.padding(40.0)
        }.task {
            withAnimation {
                showDetail = true
                ySize = .init(width: 0, height: -60)
                yTextSize = .init(width: 0, height: -20)
                typeWriter(source: $wellComeText,
                           original: str(Strings.welcomeText))
            }
            withAnimation {
                showTutorial = true
            }
        }
    }
    
    func typeWriter(source: Binding<String>,
                    original: String,
                    at position: Int = 0) {
        if position == 0 {
            source.wrappedValue = ""
        }
        if position < original.count {
            source.wrappedValue.append(original[position])
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                typeWriter(source: source,
                           original: original,
                           at: position + 1)
            }
        }
    }
}

struct WelcomeSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeSwiftUIView()
    }
}

extension String {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
