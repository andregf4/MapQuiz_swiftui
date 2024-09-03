//
//  MapView.swift
//  QuizMaps
//
//  Created by Andre Gerez Foratto on 27/08/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var viewModelInstance: ViewModel
    @ObservedObject var globalData = GlobalData.shared
    
    @State private var position = MapCameraPosition.region(MKCoordinateRegion(
        center:  CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 40)))
    
    @State var pinLocation: CLLocationCoordinate2D?
    @State var cardSelected: Cards
    @State var latAnswer: Double = 0
    @State var longAnswer: Double = 0
    @State var spanLat: Double = 0
    @State var spanLong: Double = 0
    @State var actualName: String = ""
    @State var pontuacao: Double = 0
    @State var showAlert: Bool = false
    @State var route: [CLLocationCoordinate2D] = []
    
    var body: some View {
        ZStack {
            Color.black
            VStack {
                Text(cardSelected.nome)
                    .font(.custom("NerkoOne-Regular", size: 30))
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .padding([.leading, .trailing], 7)
                MapReader { reader in
                    Map(position: $position) {
                        Annotation("\(actualName)", coordinate: CLLocationCoordinate2D(latitude: latAnswer, longitude: longAnswer)) {
                            AsyncImage(url: URL(string: cardSelected.imagem)) { image in
                                image
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 30, height: 30)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        if pinLocation != nil {
                            Annotation("", coordinate: CLLocationCoordinate2D(latitude: pinLocation!.latitude, longitude: pinLocation!.longitude)) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundStyle(.red)
                            }
                            MapPolyline(coordinates: route)
                                .stroke(.black, style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round, dash: [5,5]))
                        }
                    }
                    .frame(width: 350, height: 600)
                    .cornerRadius(10)
                    .onTapGesture(perform: { screenCoord in
                        if pinLocation == nil {
                            pinLocation = reader.convert(screenCoord, from: .local)!
                            latAnswer = cardSelected.latitude
                            longAnswer = cardSelected.longitude
                            actualName = cardSelected.nome
                            pontuacao = sqrt((pow((111.11*latAnswer) - (111.11*pinLocation!.latitude), 2) + (pow((111.11*longAnswer) - (111.11*pinLocation!.longitude), 2))))
                            spanLat = spanDifference(A: latAnswer, P: pinLocation!.latitude)
                            spanLong = spanDifference(A: longAnswer, P: pinLocation!.longitude)
                            withAnimation {
                                position = MapCameraPosition.region(MKCoordinateRegion(
                                    center:  CLLocationCoordinate2D(latitude: centerDifference(A: latAnswer, P: pinLocation!.latitude), longitude: centerDifference(A: longAnswer, P: pinLocation!.longitude)),
                                    span: MKCoordinateSpan(latitudeDelta: spanLat, longitudeDelta: spanLong)))
                            }
                            route.append(CLLocationCoordinate2D(latitude: latAnswer, longitude: longAnswer))
                            route.append(CLLocationCoordinate2D(latitude: pinLocation!.latitude, longitude: pinLocation!.longitude))
                        } else {
                            showAlert = true
                        }
                    })
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Você já teve sua chance :)"))
                    }
                }
                withAnimation(.easeInOut(duration: 2)) {
                    HStack {
                        if pontuacao == 0 {
                            Text("?")
                                .foregroundStyle(.yellow)
                                .padding(.leading, 15)
                        } else {
                            Text("\(pontuacao, specifier: "%.2f") km")
                                .foregroundStyle(.white)
                                .padding(.leading, 15)
                        }
                        Spacer()
                        Button {
                            viewModelInstance.setaNota(card: cardSelected, nota: pontuacao)
                            globalData.counter += 1
                            presentation.wrappedValue.dismiss()
                        } label: {
                            Text("Voltar")
                                .foregroundStyle(.lightCyan)
                                .padding(.trailing, 25)
                        }
                    }
                    .font(.custom("NerkoOne-Regular", size: 30))
                    .padding([.top, .bottom])
                    .frame(width: 300)
                    .background(.yellow.opacity(0.4))
                    .clipShape(Capsule())
                }
            }
        }
        .ignoresSafeArea()
        .toolbar(.hidden)
    }
}

#Preview {
    MapView(viewModelInstance: ViewModel(), globalData: GlobalData.shared, cardSelected: Cards(nome: "Cristo Redentor", latitude: 0, longitude: 0, imagem: "https://upload.wikimedia.org/wikipedia/commons/9/98/Cidade_Maravilhosa.jpg"), latAnswer: 0, longAnswer: 0, spanLat: 10, spanLong: 10, actualName: "Cristo Redentor", pontuacao: 20, showAlert: false, route: [CLLocationCoordinate2D(latitude: 0, longitude: 0)])
}
