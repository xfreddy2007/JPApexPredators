import SwiftUI

struct ContentView: View {
  let predators = Predators()
  
  @State var searchText: String = ""
  @State var alphabetical = false
  @State var currentSelection = APType.all
  
  var filteredDinos: [ApexPredator] {
    predators.filter(by: currentSelection)
    
    predators.sort(by: alphabetical)
    
    return predators.search(for: searchText)
  }
  
  var body: some View {
    NavigationStack {
      List(filteredDinos) { predator in
        NavigationLink{
          PredatorDetail(predator: predator)
        } label: {
          HStack {
            // Dinosaur image
            Image(predator.image)
              .resizable()
              .scaledToFit()
              .frame(width: 100, height: 100)
              .shadow(color: .white, radius: 1)
            
            VStack(alignment: .leading) {
              // Name
              Text(predator.name)
                .fontWeight(.bold)
              
              // Type
              Text(predator.type.rawValue.capitalized)
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.horizontal, 13)
                .padding(.vertical, 5)
                .background(predator.type.background)
                .clipShape(.capsule)
            }
          }
        }
      }
      .navigationTitle("Apex Predators")
      .searchable(text: $searchText)
      .autocorrectionDisabled()
      .animation(.default, value: searchText)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            withAnimation {
              alphabetical.toggle()
            }
          } label: {
            Image(systemName: alphabetical ? "film" : "textformat")
              .symbolEffect(.bounce, value: alphabetical)
          }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
          Menu {
            Picker("Filter", selection: $currentSelection.animation()) {
              ForEach(APType.allCases) { type in
                Label(type.rawValue.capitalized, systemImage: type.icon)
              }
            }
          } label: {
            Image(systemName: "slider.horizontal.3")
          }
        }
      }
    }
    .preferredColorScheme(.dark)
  }
}

#Preview {
    ContentView()
}
