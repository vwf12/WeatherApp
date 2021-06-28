//
//  WeatherLocationUIView.swift
//  WeatherApp
//
//  Created by FARIT GATIATULLIN on 25.06.2021.
//

import SwiftUI
import Lottie

struct WeatherLocationUIView: View {
    struct Ocean: Identifiable, Hashable {
        let name: String
        let id = UUID()
    }
    private var oceans = [
        Ocean(name: "Pacific"),
        Ocean(name: "Atlantic"),
        Ocean(name: "Indian"),
        Ocean(name: "Southern"),
        Ocean(name: "Arctic"),
        Ocean(name: "Arctic"),
        Ocean(name: "Arctic"),
        Ocean(name: "Arctic"),
        Ocean(name: "Arctic"),
        Ocean(name: "Arctic")
    ]
    
    var body: some View {
//        List(oceans) {
//                Text($0.name)
//            }

        ScrollView() {
            VStack() {
                Text("Ufa")
                LottieView(name: "4791-foggy", loopMode: .loop)
                    .frame(width: 200, height: 200, alignment: .center)
                Text("20 degrees")
                ScrollView(.horizontal) {
                    HStack {
                            VStack {
                                List(oceans) {
                                        Text($0.name)
                                    }
                                Text("20:00")
                                Divider()
                                    .frame(width: 10, height: 10, alignment: .center)
                                Text("21")
                            }


                        VStack {
                            Text("20:00")
                            Divider()
                                .frame(width: 10, height: 10, alignment: .center)
                            Text("21")
                        }
                        VStack {
                            Text("20:00")
                            Divider()
                                .frame(width: 10, height: 10, alignment: .center)
                            Text("21")
                        }
                        VStack {
                            Text("20:00")
                            Divider()
                                .frame(width: 10, height: 10, alignment: .center)
                            Text("21")
                        }
                        VStack {
                            Text("20:00")
                            Divider()
                                .frame(width: 10, height: 10, alignment: .center)
                            Text("21")
                        }
                        VStack {
                            Text("20:00")
                            Divider()
                                .frame(width: 10, height: 10, alignment: .center)
                            Text("21")
                        }
                        VStack {
                            Text("20:00")
                            Divider()
                                .frame(width: 10, height: 10, alignment: .center)
                            Text("21")
                        }
                    }


                    .padding()
                }
                ScrollView {
                    ForEach(oceans, id: \.self) { ocean in
                        Text(ocean.name)
                    }
                }
            }
            .padding()

        }

        
    }
}

struct WeatherLocationUIView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherLocationUIView()
    }
}
