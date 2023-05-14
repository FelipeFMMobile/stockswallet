//
//  GenericErrorUIView.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 07/05/23.
//

import SwiftUI
import SwiftApiSDK

struct GenericErrorUIView: View {
    let apiError: Error
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(spacing: 24.0) {
            Spacer()
            Text(str(Strings.title))
                .font(.title)
            Text(self.getErrorMessage(apiError: apiError))
                .font(.body)
            Spacer()
            Button(action: {
                dismiss()
            }, label: {
                Text(str(Strings.buttonTitle))
                    .frame(minWidth: 240.0,
                           alignment: .center)
            })
            .buttonBorderShape(.roundedRectangle)
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .navigationTitle(str(Strings.navTitle))
        .padding(48.0)
    }

    private func getErrorMessage(apiError: Error) -> String {
        guard let apiError = apiError as? ApiError else {
            return ""
        }
        var errorMessage = str(Strings.connectionMessage)
        switch apiError {
        case .statusCodeError(let code):
            if 400...409 ~= code {
                errorMessage = str(Strings.serverMessage)
            }
        case .contentSerializeError:
            errorMessage = str(Strings.serverMessage)
        case .domainFail:
            errorMessage = str(Strings.serverMessage)
        case .networkingError:
            errorMessage = str(Strings.connectionMessage)
        }
        debugPrint("🚨 Networking error: \(errorMessage) : \(apiError.localizedDescription)")
        return errorMessage
    }
}

struct GenericErrorUIView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GenericErrorUIView(apiError: ApiError.statusCodeError(404))
        }
    }
}
