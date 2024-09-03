//
//  ContentView.swift
//  QuizMaps
//
//  Created by Andre Gerez Foratto on 25/08/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    @State var degreesRotating: Double = 0
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                Image("Globe")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(CGSize(width: 3, height: 3))
                    .opacity(0.3)
                    .rotationEffect(.degrees(degreesRotating))
                    .onAppear {
                        withAnimation(.linear(duration: 1)
                            .speed(0.05).repeatForever(autoreverses: false)) {
                                degreesRotating = 360.0
                            }
                    }
                VStack {
                    Text("MapQuiz")
                        .font(.custom("NerkoOne-Regular", size: 100))
                        .foregroundStyle(.white)
                        .shadow(color: .blue, radius: 5)
                        .padding(.top, 30)
                        .padding(.bottom, 10)
                    Text("Escolha um baralho:")
                        .foregroundStyle(.white)
                        .font(.custom("NerkoOne-Regular", size: 30))
                    Spacer()
                    ScrollViewReader { v in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                LazyVGrid(columns: columns) {
                                    ForEach(Array(viewModel.categories.enumerated()), id: \.offset) { i, c in
                                        NavigationLink(destination: Listagem(category: c, viewModelInstance: viewModel)) {
                                            Rectangle()
                                                .id(i)
                                                .frame(width: 250, height: 250)
                                                .blur(radius: 10)
                                                .overlay(
                                                    ZStack {
                                                        AsyncImage(url: URL(string: c.cards.first!.imagem)) { image in
                                                            image
                                                                .resizable()
                                                                .opacity(0.5)
                                                        } placeholder: {
                                                            Rectangle()
                                                                .frame(width: 350, height: 350)
                                                        }
                                                        VStack {
                                                            Spacer()
                                                            Text(c.nome)
                                                                .foregroundStyle(.white)
                                                                .font(.custom("NerkoOne-Regular", size: 25))
                                                                .padding(10)
                                                                .shadow(color: .black, radius: 5)
                                                        }
                                                    }
                                                )
                                                .cornerRadius(20)
                                                .padding(5)
                                        }
                                        .tint(LinearGradient(colors: [.black, .white], startPoint: .bottom, endPoint: .top))
                                    }
                                }
                            }
                            .onAppear() {
                                v.scrollTo(1, anchor: .leading)
                            }
                        }.padding(5)
                    }
                }
            }
            .onAppear() {
                viewModel.loadData()
            }
        }.accentColor(.white)
    }
}

#Preview {
    ContentView()
}
