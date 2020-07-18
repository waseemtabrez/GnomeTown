//
//  NetworkManager.swift
//  GnomeTown
//
//  Created by 837676 on 17/07/20.
//  Copyright © 2020 Syed Developers. All rights reserved.
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
   
//   func parseArticlesFromData(data: Data) -> [GnomeModel] {
//      var response: BrastlewarkApiResponse
//      do {
//         response = try JSONDecoder().decode(BrastlewarkApiResponse.self, from: data)
//      } catch {
//         print("Error parsing the JSON: \(error)")
//         return []
//      }
//
//      //        if response.status != "ok" {
//      //            print("Status is not ok: \(response.status)")
//      //            return []
//      //        }
//      print("Downloaded results: \(response.brastlewark?.count ?? 0)")
//      return response.brastlewark ?? []
//   }
   
}

let dataErrorDomain = "dataErrorDomain"

enum DataErrorCode: NSInteger {
   case networkUnavailable = 101
   case wrongDataFormat = 102
}

struct BrastlewarkApiResponse: Codable {
   //    var status: String
   var brastlewark: [GnomeModel]?
   enum CodingKeys: String, CodingKey {
      case brastlewark = "Brastlewark"
   }
}
