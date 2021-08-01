// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct Countries: Decodable {
    let countries: [Country]
}

struct Country: Decodable {
    let name: String
    let topLevelDomain: [String]
    let alpha2Code : String
    let alpha3Code: String
    let callingCodes: [String]
    let capital: String 
    let altSpellings: [String]
    let region : String
    let subregion: String
    let population: Int
    let latlng: [Double]
    let demonym: String
    let area: Int
    let gini: Double
    let timezones: [String]
    let borders: [String]
    let nativeName: String
    let numericCode: String
    let currencies: [Currency]
    let languages: [Language]
    let translations: Translations
    let flag: String
    let regionalBlocs: [RegionalBloc]
    let cioc: String
}

struct Currency: Codable {
    let code : String
    let name : String
    let symbol: String
}

struct RegionalBloc: Codable {
    let acronym, name: String
    let otherAcronyms, otherNames: [String]
}

struct Translations: Codable {
    let de, es, fr, ja: String
    let it, br, pt, nl: String
    let hr, fa: String
}

struct Language: Codable {
    let iso639_1 : String
    let iso639_2 : String
    let name : String
    let nativeName : String
}

