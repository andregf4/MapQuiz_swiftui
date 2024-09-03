//
//  Listagem.swift
//  QuizMaps
//
//  Created by Andre Gerez Foratto on 27/08/24.

import SwiftUI

struct Listagem: View {
    
    @Environment(\.presentationMode) var presentation
    
    @State var category: Categories
    @ObservedObject var viewModelInstance: ViewModel
    @ObservedObject var globalData = GlobalData.shared
    @State var animate: Bool = false
    @State var alertShow: Bool = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var totalNota: Double {
        viewModelInstance.category?.cards.reduce(0) { partialResult, card in
            return partialResult + (card.nota ?? 0.0)
        } ?? 0.0
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                CircleBackground(color: Color("greenCircle"))
                    .blur(radius: animate ? 30 : 100)
                    .offset(x: animate ? -50 : -130, y: animate ? -30 : -100)
                    .task {
                        withAnimation(.easeInOut(duration: 7).repeatForever()) {
                            animate.toggle()
                        }
                    }
                CircleBackground(color: Color("pinkCircle"))
                    .blur(radius: animate ? 30 : 100)
                    .offset(x: animate ? 100 : 130, y: animate ? 150 : 100)
                    .task {
                        withAnimation(.easeInOut(duration: 4).repeatForever()) {
                            animate.toggle()
                        }
                    }
                CircleBackground(color: Color(.darkBlue))
                    .blur(radius: animate ? 30 : 100)
                    .offset(x: animate ? -90 : 20, y: animate ? 120 : -50)
                    .task {
                        withAnimation(.easeInOut(duration: 4).repeatForever()) {
                            animate.toggle()
                        }
                    }
                
                VStack {
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            if(viewModelInstance.category != nil){
                                ForEach(viewModelInstance.category!.cards, id: \.self) { c in
                                    NavigationLink(destination: MapView(viewModelInstance: viewModelInstance, cardSelected: c)) {
                                        VStack {
                                            AsyncImage(url: URL(string: c.imagem)) { image in
                                                image
                                                    .resizable()
                                                    .clipShape(Capsule())
                                                    .frame(width: 150, height: 120)
                                            } placeholder: {
                                                Capsule()
                                                    .frame(width: 150, height: 120)
                                                    .foregroundStyle(.gray.opacity(0.3))
                                            }
                                            if(c.nota != nil) {
                                                Text("\(c.nota!, specifier: "%.2f") km")
                                                    .font(.custom("NerkoOne-Regular", size: 25))
                                                    .foregroundStyle(.white)
                                                    .padding(5)
                                                    .background(.blue)
                                                    .clipShape(Capsule())
                                            } else {
                                                Text("\(0, specifier: "%.2f")")
                                                    .font(.custom("NerkoOne-Regular", size: 25))
                                                    .foregroundStyle(.white)
                                                    .padding(5)
                                                    .background(.gray.opacity(0.5))
                                                    .clipShape(Capsule())
                                            }
                                        }
                                    }
                                    .foregroundStyle(.black)
                                    .onAppear() {
                                        if globalData.counter == viewModelInstance.category!.cards.count {
                                            alertShow = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                    HStack {
                        Capsule()
                            .stroke(Color.green)
                            .frame(width: 200, height: 55)
                            .overlay(
                                Text("\(totalNota, specifier: "%.2f") km")
                                    .foregroundStyle(.white)
                                    .font(.custom("NerkoOne-Regular", size: 35))
                                    .padding(5)
                            )
                        if(totalNota != 0) {
                            Text("\(((Double(1000*viewModelInstance.category!.cards.count))/(totalNota)), specifier: "%.2f") pts")
                                .foregroundStyle(.white)
                                .font(.custom("NerkoOne-Regular", size: 35))
                                .padding(5)
                                .background(.green)
                                .clipShape(Capsule())
                        } else {
                            Text("0 pts")
                                .foregroundStyle(.white)
                                .font(.custom("NerkoOne-Regular", size: 35))
                                .padding(5)
                                .background(.green)
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(.top, 20)
                .onAppear() {
                    if(viewModelInstance.category == nil){
                        viewModelInstance.category = category
                    }
                }
                .alert(isPresented: $alertShow) {
                    Alert(title: Text("Fim de Jogo!"), message: Text("Você marcou \(((Double(1000*viewModelInstance.category!.cards.count))/totalNota), specifier: "%.2f") pontos nesse baralho."), dismissButton: .default(Text("VOLTAR"), action: {
                        self.presentation.wrappedValue.dismiss()
                    }))
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(category.nome)
                    .foregroundStyle(.white)
                    .bold()
            }
        }
    }
}

#Preview {
    Listagem(category: Categories(nome: "Maravilhas do Mundo Moderno", cards: [Cards(nome: "Cristo Redentor", latitude: 0, longitude: 0, imagem: "https://upload.wikimedia.org/wikipedia/commons/9/98/Cidade_Maravilhosa.jpg")]), viewModelInstance: ViewModel(), globalData: GlobalData.shared, animate: false, alertShow: false)
}
