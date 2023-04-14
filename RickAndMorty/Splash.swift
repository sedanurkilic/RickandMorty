//
//  Splash.swift
//  RickAndMorty
//
//  Created by Seda Kılıç on 7.04.2023.
//

import SwiftUI

struct Splash: View {
    @Binding var isHomepageActive: Bool
    @State private var isFirstLaunch: Bool = true
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            Image("splash")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
                Button(action: {
                    isHomepageActive = true
                    isFirstLaunch = false
                }) {
                    Text(isFirstLaunch ? "Welcome!" : "Hello!")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
            }
        }
    }


