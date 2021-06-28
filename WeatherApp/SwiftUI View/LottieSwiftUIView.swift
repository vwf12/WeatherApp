//
//  LottieSwiftUIView.swift
//  WeatherApp
//
//  Created by FARIT GATIATULLIN on 25.06.2021.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var name = "4791-foggy"
    var loopMode: LottieLoopMode = .loop

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)

        let animationView = AnimationView()
        let animation = Animation.named(name)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

struct LottieSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        LottieView()
    }
}
