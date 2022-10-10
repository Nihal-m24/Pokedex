//
//  PokemonInfoPage.swift
//  Pokedex
//
//  Created by Nihal Memon on 9/13/22.
//

import SwiftUI
import SDWebImageSwiftUI
import CoreImage.CIFilterBuiltins

struct PokemonInfoPage: View {
    let pokemon : PokemonModel
    @State var screenWidth = UIScreen.main.bounds.width
    @State var screenHeight = UIScreen.main.bounds.height
    @State var showCard = false
    var body: some View {
        ZStack(alignment: .center){
            OriginalPokeBall()
            VStack{
                // Top Image
                HStack{
                    Spacer()
                    
                    AsyncImage(url: URL(string: pokemon.sprites.main!)) { image in
                        Button{
                            self.showCard.toggle()
                        } label: {
                            
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: screenWidth / 2, height: screenHeight / 4)
                        }
                    } placeholder: {
                        HStack{
                            Spacer()

                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                        .padding(50)
                    }

                    Spacer()
                }
                //Text
                HStack{
                    VStack(alignment: .center){
                        //Name and Type
                        HStack{
                            Spacer()
                            VStack{
                                Text("\(pokemon.name)")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                    .fontWeight(.black)
                                    .padding(.horizontal)
                                    .padding(.top)

                                Text("\(pokemon.types[0].type.name)")
                                    .font(.title3)
                                    .foregroundColor(.black)
                                    .fontWeight(.black)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(.white)
                                    .cornerRadius(30)
                                    .offset(y: -20)
                            }

                            Spacer()
                        }

                        //Height and weight
                        HStack{
                            VStack(alignment: .leading){
                                HStack{
                                    Text("Height:")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                        .fontWeight(.bold)

                                    Text("\(pokemon.height)")
                                        .foregroundColor(.white)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                }
                                .padding(.vertical, 3)
                                HStack{
                                    Text("Weight:")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                        .fontWeight(.bold)

                                    Text("\(pokemon.weight)")
                                        .foregroundColor(.white)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                }
                            }

                            Spacer()
                        }
                        .padding()
                    }
                    Spacer()
                }

                HStack{
                    TabView{
                        //Front
                        AsyncImage(url: URL(string: pokemon.sprites.front_default)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: screenWidth / 3, height: screenHeight / 3)
                        } placeholder: {
                            HStack{
                                Spacer()

                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            .padding(50)
                        }
                        //Back
                        AsyncImage(url: URL(string: pokemon.sprites.back_default)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: screenWidth / 3, height: screenHeight / 3)
                        } placeholder: {
                            HStack{
                                Spacer()

                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            .padding(50)
                        }
                        //Front Shiny
                        AsyncImage(url: URL(string: pokemon.sprites.front_shiny)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: screenWidth / 3, height: screenHeight / 3)
                        } placeholder: {
                            HStack{
                                Spacer()

                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            .padding(50)
                        }
                        //Back Shiny
                        AsyncImage(url: URL(string: pokemon.sprites.back_shiny)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: screenWidth / 3, height: screenHeight / 3)
                        } placeholder: {
                            HStack{
                                Spacer()

                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            .padding(50)
                        }

                    }
                    .tabViewStyle(.page)
                    .frame(width: screenWidth - 100, height: screenHeight / 3)
                }
            }
            .frame(width: screenWidth, height: screenHeight)
            .background(.ultraThinMaterial)
        }
        .background(.black)
        
        .sheet(isPresented: self.$showCard) {
            SavingCard(pokemon: pokemon)
        }
    }
}

struct SavingCard : View{
    let pokemon : PokemonModel
    @State var screenWidth = UIScreen.main.bounds.width
    @State var screenHeight = UIScreen.main.bounds.height
    @State var download = false
    @State var showDone = false
    
    var body: some View {
        ZStack{
           OriginalPokeBall()
                
            ZStack{
                HStack{
                    VStack(alignment: .leading){
                        HStack{
                            Text("\(pokemon.name)")
                                .font(.largeTitle)
                                .fontWeight(.black)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.top, 30)
                            
                            Spacer()
                            
                            if(!self.download){
                                Button{
                                    withAnimation(.easeOut){
                                        self.download.toggle()
                                    }
                                    let image = body.snapshot()
                                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                                        withAnimation(.easeIn){
                                            self.showDone.toggle()
                                        }
                                    }
                                    
                                } label: {
                                    Image(systemName: "arrow.down.to.line")
                                        .font(.title3)
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                        .padding(.top, 30)
                                }
                            }
                            
                            if(self.showDone){
                                Image(systemName: "checkmark.circle")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                    .padding(.top, 30)
                            }
                        }
                        
                        
                        Text("\(pokemon.types[0].type.name)")
                            .font(.title3)
                            .fontWeight(.black)
                            .foregroundColor(.black)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(.white)
                            .cornerRadius(30)
                            .padding(.horizontal)
                            .offset(y: -17)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                VStack{
                    Spacer()
                    
                    HStack{
                        Spacer()
                        
                        WebImage(url: URL(string: pokemon.sprites.main!))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: screenWidth - 70, height: screenHeight / 3)
                            .padding()
                            .padding(.bottom)
                        
                        Spacer()
                    }
                }
            }
            .background(.ultraThinMaterial)
            
        }
        .frame(width: screenWidth - 50, height: screenHeight / 1.5)
        .background(.black)
        .cornerRadius(30)
        .shadow(color: .white, radius: 3)
    }
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .black

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

