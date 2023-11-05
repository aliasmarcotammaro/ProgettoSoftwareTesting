//
//  Task.swift
//  ProgettoSoftwareTesting
//
//  Created by Marco Tammaro on 01/11/23.
//

import Foundation

extension Encodable {
    func toDict() throws -> [String:Any]? {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        return try JSONSerialization.jsonObject(with: data) as? [String:Any]
    }
}

extension Decodable {
    init<Key: Hashable>(dict: [Key: Any]) throws {
        let data = try JSONSerialization.data(withJSONObject: dict)
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}

class Task: Codable, Identifiable, ObservableObject {
    var id: UUID
    var name: String
    var completed: Bool
    
    init(name: String, completed: Bool) {
        self.id = UUID()
        self.name = name
        self.completed = completed
    }
}
