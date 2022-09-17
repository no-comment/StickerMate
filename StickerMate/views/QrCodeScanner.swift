//
//  QrCodeScanner.swift
//  StickerMate
//
//  Created by Miká Kruschel on 17.09.22.
//

import CodeScanner
import SwiftUI

struct QrCodeScanner: View {
    var body: some View {
        GeometryReader { geo in
            VStack {
                Text("Scan QR Code").font(.title3.weight(.semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                CodeScannerView(codeTypes: [.qr], scanMode: .once, showViewfinder: true, simulatedData: "Test", shouldVibrateOnSuccess: true, isTorchOn: false) { response in
                    switch response {
                    case .success(let result):
                        print("Found code: \(result.string)")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(width: geo.size.width - 34, height: geo.size.width - 34)
                .clipped()
                .aspectRatio(1, contentMode: .fill)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 25).fill(Color(uiColor: .systemBackground))
                    .shadow(radius: 7)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}

struct QrCodeScanner_Previews: PreviewProvider {
    static var previews: some View {
        QrCodeScanner()
    }
}
