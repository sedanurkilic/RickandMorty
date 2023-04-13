import SwiftUI

struct ContentView: View {
    @State private var isHomepageActive = false
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Splash(isHomepageActive: $isHomepageActive) // isHomepageActive -> Splash
                .tag(0)
            
            EmptyView()
                .tag(1)
        }
        .sheet(isPresented: $isHomepageActive) {
            Homepage()
        }
    }
}

