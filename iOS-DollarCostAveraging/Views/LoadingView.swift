//
//  LoadingView.swift
//  iOS-DollarCostAveraging
//
//  Created by Marina McPeak on 2022-05-03.
//

import Foundation
import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct LoadingView<Content>: View where Content: View {
    
    @Binding var isShowing: Bool
    var content: () -> Content
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.content()
                ActivityIndicator(isAnimating: .constant(true), style: .large)
                    .frame(width: geometry.size.width / 4,
                           height: geometry.size.width / 4)
                    .background(Color.secondary.colorInvert())
                    .foregroundColor(Color.primary)
                    .cornerRadius(20)
                    .opacity(self.isShowing ? 1 : 0)
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width)
    }
}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(isShowing: .constant(true)) {
            VStack {
                Text("Loading View")
            }
        }
    }
}
