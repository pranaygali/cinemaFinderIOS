//
//  MovieModel.swift


import Foundation

class MovieModel {
    
    var name: String
    var docID: String
    var starCast: String
    var dName: String
    
    init(docID: String,name:String,starCast:String,dName:String) {
        self.name = name
        self.docID = docID
        self.starCast = starCast
        self.dName = dName
    }
}
