//
//  main.swift
//  Parsing JSON
//
//  Created by Huy Ong on 3/24/21.
//

import Foundation

let json = """
[
    {
        "name": "Taylor Swift",
        "company": "Taytay Inc",
        "age": 26,
        "address": {
            "street": "555 Taylor Swift Avenue",
            "city": "Nashville",
            "state": "Tennessee",
            "gps": {
                "lat": 36.1868667,
                "lon": -87.0661223
            }
        }
    },
    {
        "title": "1989",
        "type": "studio",
        "year": "2014",
        "singles": 7
    },
    {
        "title": "Shake it Off",
        "awards": 10,
        "hasVideo": true
    }
]
"""

extension Dictionary where Key == String {
    func bool(for key: String) -> Bool? {
        self[key] as? Bool
    }
    
    func string(for key: String) -> String? {
        self[key] as? String
    }
    
    func int(for key: String) -> Int? {
        self[key] as? Int
    }
    
    func double(for key: String) -> Double? {
        self[key] as? Double
    }
}

struct JSON: RandomAccessCollection {
    var value: Any?
    var startIndex: Int { array.startIndex }
    var endIndex: Int { array.endIndex }
    
    init(string: String) throws {
        let data = Data(string.utf8)
        value = try JSONSerialization.jsonObject(with: data)
    }
    
    init(value: Any?) {
        self.value = value
    }
    
    var optionalBool: Bool? {
        value as? Bool
    }
    
    var optionalString: String? {
        value as? String
    }
    
    var optionalInt: Int? {
        value as? Int
    }
    
    var optionalDouble: Double? {
        value as? Double
    }
    
    var bool: Bool {
        optionalBool ?? false
    }
    
    var double: Double {
        optionalDouble ?? 0
    }
    
    var int: Int {
        optionalInt ?? 0
    }
    
    var string: String {
        optionalString ?? ""
    }
    
    var optionalArray: [JSON]? {
        let converted = value as? [Any]
        return converted?.map { JSON(value: $0) }
    }
    
    var array: [JSON] {
        optionalArray ?? []
    }
    
    var optionalDictionary: [String: JSON]? {
        let converted = value as? [String: Any]
        return converted?.mapValues { JSON(value: $0) }
    }
    
    var dictionary: [String: JSON] {
        optionalDictionary ?? [:]
    }
    
    subscript(index: Int) -> JSON {
        optionalArray?[index] ?? JSON(value: nil)
    }

    subscript(key: String) -> JSON {
        optionalDictionary?[key] ?? JSON(value: nil)
    }
//
//    subscript(dynamicMember key: String) -> JSON {
//        optionalDictionary?[key] ?? JSON(value: nil)
//    }
}


let object = try JSON(string: json)
for item in object {
    print(item["title"].optionalString ?? "Anonymous")
}
