//
//  NetworkManager.swift
//  GnomeTown
//
//  Created by Waseem Tabrez on 17/07/20.
//  Copyright © 2020 Waseem Tabrez. All rights reserved.
//

import Foundation

struct NetworkManager {
   
   private init() {}
   static let shared = NetworkManager()
   
   private let urlSession = URLSession.shared
   private let baseURL = URL(string: "https://raw.githubusercontent.com/rrafols/mobile_test/master/data.json")!
   
   func getGnomes(completion: @escaping(_ gnomes: [GnomeModel]?, _ error: Error?) -> ()) {
      let filmURL = baseURL//.appendingPathComponent("films")
      urlSession.dataTask(with: filmURL) { (data, response, error) in
         if let error = error {
            completion(nil, error)
            return
         }
         
         guard let data = data else {
            let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
            completion(nil, error)
            return
         }
         
         do {
            let result = try JSONDecoder().decode(BrastlewarkApiResponse.self, from: data).brastlewark
            completion(result, nil)
         } catch {
            print("Error parsing the JSON: \(error)")
            completion(nil, error)
         }
      }.resume()
   }
}

let dataErrorDomain = "dataErrorDomain"

enum DataErrorCode: NSInteger {
   case networkUnavailable = 101
   case wrongDataFormat = 102
}

struct BrastlewarkApiResponse: Codable {
   var brastlewark: [GnomeModel]?
   enum CodingKeys: String, CodingKey {
      case brastlewark = "Brastlewark"
   }
}
