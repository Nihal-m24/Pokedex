//
//  ContentView.swift
//  Pokedex
//
//  Created by Nihal Memon on 9/12/22.
//

import SwiftUI

struct ContentView: View {
    @State var searchText = ""
    var body: some View {
        CustomNavigationBar(view: HomePage(searchText: self.$searchText), onSearch: { searchedText in
            self.searchText = searchedText
        }, onCancel: {
            self.searchText = ""
        })
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct HomePage: View{
    private let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    @Binding var searchText : String
    @State var theString = ""
    @ObservedObject var pokemonModel = PokemonViewModel()
    @State var screenWidth = UIScreen.main.bounds.width
    @State var rotation = 0.0
    var body: some View{
        
        ZStack{
            
            OriginalPokeBall()
                .rotationEffect(Angle(degrees: rotation))
                .onChange(of: searchText) { newValue in
                    withAnimation(.spring()){
                        //DO BASED ON SIZE OF STRING
                        if(self.searchText.count < theString.count){
                            self.rotation -= 45
                        } else {
                            self.rotation += 45
                        }
                        
                        if(searchText == ""){
                            rotation = 0.0
                        }
                        self.theString = searchText
                    }
                   
                }
            
            VStack{
                ScrollView{
                    LazyVGrid(columns: gridItems) {
                        ForEach(getPokemons()){pokemon in
                            NavigationLink(destination: PokemonInfoPage(pokemon: pokemon)) {
                                PokemonCell(pokemon: pokemon)
                            }
                        }
                    }
                    
                    if(getPokemons().count == 0 && !self.searchText.isEmpty){
                        VStack{
                            Text("No Matching Pokemons")
                                .font(.title3)
                                .fontWeight(.black)
                                .foregroundColor(.white)
                            Button {
                                withAnimation(.spring()){
                                    self.searchText = ""
                                }
                                
                            } label: {
                                Text("Clear Search")
                                    .font(.body)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    else if (getPokemons().count == 0){
                        VStack{
                            ProgressView("Loading Pokemons")
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .padding(.vertical)
                        }
                    }
                }
            }
            
        }
        .background(.black)
        .preferredColorScheme(.dark)
        
    }
    
    func getPokemons()->[PokemonModel]{
        var thePokemons = pokemonModel.pokemons
        
        if(!searchText.isEmpty){
            let namesMatched = thePokemons.filter{$0.name.lowercased().contains(searchText.lowercased())}
            let typesMatched = thePokemons.filter{$0.types[0].type.name.lowercased().contains(searchText.lowercased())}
            
            thePokemons = namesMatched + typesMatched
        }
        
        return thePokemons.sorted(by: {$0.id < $1.id})
    }
}

struct OriginalPokeBall : View {
    @State var screenWidth = UIScreen.main.bounds.width
    var body: some View {
        ZStack(alignment: .center){
            Circle()
                .trim(from: 0, to: 0.5)
                .fill(.red)
                .rotationEffect(Angle(degrees: 180))
                .frame(width: screenWidth - 100, height: screenWidth - 100)


            Circle()
                .trim(from: 0, to: 0.5)
                .fill(.white)
                .frame(width: screenWidth - 100, height: screenWidth - 100)

            Rectangle()
                .fill(.black)
                .frame(width: screenWidth - 100, height: screenWidth / 15)
                .cornerRadius(3)

            Circle()
                .fill(.black)
                .frame(width: screenWidth / 5, height: screenWidth / 5)

            Circle()
                .fill(.white)
                .frame(width: screenWidth / 9, height: screenWidth / 9)

        }
    }
}

struct PokemonCell : View{
    let pokemon : PokemonModel
    @State var screenWidth = UIScreen.main.bounds.width / 2
    var body: some View{
        ZStack{
            VStack(alignment: .leading){
                HStack{
                    Text("\(pokemon.name)")
                        .font(.title3)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.leading)
                HStack{
                    Text("\(pokemon.types[0].type.name)")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 3)
                        .padding(.horizontal, 10)
                        .background(.ultraThinMaterial)
                        .cornerRadius(30)
                    
                    Spacer()
                }
                .padding(.leading)
                
                Spacer()
            }
            .padding(.vertical)
            .padding(.top)
            
            VStack{
                Spacer()
                
                HStack{
                    Spacer()
                    AsyncImage(url: URL(string: pokemon.sprites.main!)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: screenWidth / 2, height: screenWidth / 2)
                            .padding(7)
                    } placeholder: {
                        HStack{
                            Spacer()
                            
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                        .padding(50)
                    }
                }
               // .offset(x: 15, y: 20)
            }
        }
        .frame(width: screenWidth - 15, height: screenWidth - 15)
        .background(.ultraThinMaterial)
        .cornerRadius(30)
    }
    
    func cellBackground() -> Color {
        switch pokemon.types[0].type.name{
        case "electric":
            return Color.yellow
        case "fire":
            return Color.red
        case "water":
            return Color.blue
        case "poison":
            return Color.purple
        case "grass":
            return Color.green
        case "ground":
            return Color.brown
        case "fairy":
            return Color.pink
        case "bug":
            return Color.mint
        case "fighting":
            return Color.teal
        case "rock":
            return Color.gray
        case "normal":
            return Color.orange
        case "ghost":
            return Color.indigo
        case "psychic":
            return Color.yellow.opacity(0.7)
        default:
            return Color.black
        }
    }
}

struct CustomNavigationBar : UIViewControllerRepresentable{
    
    func makeCoordinator() -> Coordinator {
        return CustomNavigationBar.Coordinator(parent: self)
    }
    
    var view: HomePage
    var onSearch : (String) -> ()
    var onCancel : () -> ()
    
    init(view: HomePage, onSearch: @escaping (String) -> (), onCancel: @escaping () -> ()) {
        self.view = view
        self.onSearch = onSearch
        self.onCancel = onCancel
    }
    
    func makeUIViewController(context: Context) ->  UINavigationController {
        
        let childView = UIHostingController(rootView: view)
        
        let controller = UINavigationController(rootViewController: childView)
        
        //Navigation bar
        controller.navigationBar.topItem?.title = "Pokedex"
        controller.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Name, Type"
        
        searchController.searchBar.delegate = context.coordinator
        
        controller.navigationBar.topItem?.searchController = searchController
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    class Coordinator : NSObject, UISearchBarDelegate{
        var parent : CustomNavigationBar
        
        init(parent : CustomNavigationBar) {
            self.parent = parent
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.parent.onSearch(searchText)
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            //When cancel button clocked
            self.parent.onCancel()
        }
    }
}
