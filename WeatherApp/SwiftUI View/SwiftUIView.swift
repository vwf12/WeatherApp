//
//  ContentView.swift
//  WeatherSwiftUI
//
//  Created by FARIT GATIATULLIN on 09.06.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(hue: 0.5334009836955244, saturation: 1.0, brightness: 1.0, opacity: 1.0), location: 0.0), Gradient.Stop(color: Color(hue: 0.5342215112892978, saturation: 0.0, brightness: 0.8, opacity: 1.0), location: 1.0)]), startPoint: UnitPoint.topLeading, endPoint: UnitPoint.bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    TextField("Enter city name", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
//                        .background(Color.white.opacity(0.1))
                        .opacity(0.8)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                        Text("Search")
                    }
                    .padding()
                }
                ScrollView {
                    VStack(alignment: .leading) {
                        Divider()
                            HStack() {
                                Text("City name")
                                    .font(.title)
                                    Spacer()
                                Image(systemName: "sun.min")
                                    //.resizable()
                                    //.aspectRatio(contentMode: .fit)
                                Text("20°")
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                        Divider()
                            HStack() {
                                Text("Another city")
                                    .font(.title)
                                    Spacer()
                                Image(systemName: "cloud.rain")
                                    //.resizable()
                                    //.aspectRatio(contentMode: .fit)
                                Text("15°")
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                        
                        Divider()
                    }
                    .padding()
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
