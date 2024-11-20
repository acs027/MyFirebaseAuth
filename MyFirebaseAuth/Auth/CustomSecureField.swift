//
//  CustomSecureField.swift
//  MyFirebaseAuth
//
//  Created by ali cihan on 20.11.2024.
//

import SwiftUI

struct CustomSecureField: View {
    let placeholder: String
    @Binding var text: String

    @State private var width = CGFloat.zero
    @State private var labelWidth = CGFloat.zero

    var body: some View {
        SecureField(placeholder, text: $text)
            .foregroundColor(.gray)
            .font(.system(size: 20))
            .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
            .background {
                background
            }
            .overlay( GeometryReader { geo in Color.clear.onAppear { width = geo.size.width }})
   }
    private var background: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .trim(from: 0, to: 0.55)
                .stroke(.gray, lineWidth: 1)
            RoundedRectangle(cornerRadius: 5)
                .trim(from: 0.565 + (0.44 * (labelWidth / width)), to: 1)
                .stroke(.gray, lineWidth: 1)
            Text(placeholder)
                .foregroundColor(.gray)
                .overlay( GeometryReader { geo in Color.clear.onAppear { labelWidth = geo.size.width }})
                .padding(2)
                .font(.caption)
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: .topLeading)
                .offset(x: 20, y: -10)
        }
    }
}

#Preview {
    @Previewable @State var text = ""
    CustomSecureField(placeholder: "Password", text: $text)
}
