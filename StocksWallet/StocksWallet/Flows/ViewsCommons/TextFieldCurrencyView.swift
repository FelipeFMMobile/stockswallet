//
//  TextFieldCurrencyUIView.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 08/05/23.
//

import SwiftUI
import Combine

struct TextFieldCurrencyView: View {
    let label: String
    @Binding var value: String
    var body: some View {
        TextField(label,
                  text: $value)
        .textFieldStyle(.roundedBorder)
        .keyboardType(.numberPad)
        .multilineTextAlignment(.trailing)
        .onReceive(Just(value)) { text in
            self.value = self.currencyCharacters(text)
        }
    }

    private func currencyCharacters(_ inputString: String) -> String {
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: [])
        let outputString = regex.stringByReplacingMatches(in: inputString, options: [],
                                                          range: NSMakeRange(0, inputString.count), withTemplate: "")
        var doubleValue = Double(outputString) ?? 0.0
        if doubleValue > 0 {
            doubleValue /= 100
        }
        return Formatters.currency.string(from: NSNumber(value: doubleValue)) ?? ""
    }

}

struct TextFieldCurrencyUIView_Previews: PreviewProvider {
    static var previews: some View {
        @State var value: String = ""
        TextFieldCurrencyView(label: "Teste", value: $value)
    }
}
