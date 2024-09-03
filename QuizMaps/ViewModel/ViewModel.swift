//
//  ViewModel.swift
//  QuizMaps
//
//  Created by Andre Gerez Foratto on 25/08/24.
//

import Foundation

class ViewModel: ObservableObject {
    @Published var categories: [Categories] = []
    @Published var category: Categories?
    
    func loadData() {
        if let url = Bundle.main.url(forResource: "quiz_maps", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                self.category = nil
                self.categories = try decoder.decode([Categories].self, from: data)
            } catch {
                print("Error decoding JSON: \(error)")
            }
        } else {
            print("Could not find JSON file")
        }
    }
    
    func setaNota(card: Cards, nota: Double){
        let index = self.category!.cards.indices.filter {self.category!.cards[$0].nome == card.nome }
        self.category!.cards[index[0]].nota = nota
    }
}

class GlobalData: ObservableObject {
    @Published var counter: Int = 0
    static let shared = GlobalData()
}
