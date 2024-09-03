//
//  Model.swift
//  QuizMaps
//
//  Created by Andre Gerez Foratto on 25/08/24.
//

import Foundation

struct Categories: Decodable, Hashable {
    var nome: String
    var cards: [Cards]
}

struct Cards: Decodable, Hashable {
    var nome: String
    var latitude: Double
    var longitude: Double
    var imagem: String
    var nota: Double?
}

func spanDifference(A: Double, P: Double) -> Double {
    if ((A>=0 && P>=0 && A>=P) || (A<0 && P<0 && A>=P)) {
        return (A-P)+((A-P)*0.1)
    } else if ((A>=0 && P>=0 && P>=A) || (A<0 && P<0 && A<P)){
        return (P-A)+((P-A)*0.1)
    } else if (A>=0 && P<0){
        return (A-P)+((A-P)*0.1)
    } else {
        return (P-A)+((P-A)*0.1)
    }
}

func centerDifference(A: Double, P: Double) -> Double {
    return (A+P)/2
}
