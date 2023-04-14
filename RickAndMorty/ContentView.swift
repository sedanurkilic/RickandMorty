import SwiftUI

struct ContentView: View {
    @State private var isHomepageActive = false
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Splash(isHomepageActive: $isHomepageActive) // isHomepageActive -> Splash
                
        }
        .sheet(isPresented: $isHomepageActive) {
            Homepage()
        }
    }
}

