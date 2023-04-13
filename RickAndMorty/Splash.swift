//
//  Splash.swift
//  RickAndMorty
//
//  Created by Seda Kılıç on 7.04.2023.
//

import SwiftUI

struct Splash: View {
    @Binding var isHomepageActive: Bool
    var body: some View {
        ZStack {
            Image("splash")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            // Splash
            Button("Welcome!") {
                isHomepageActive = true
                
            }
        }
    }
}

