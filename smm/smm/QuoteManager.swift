//
//  QuoteManager.swift
//  smm
//
//  Created by Vishnu Pradeep on 11/07/2020.
//  Copyright © 2020 Maven Intel. All rights reserved.
//

import Foundation
import Firebase

class QuoteManager: ObservableObject {
    @Published var quote: Quote = Quote(quote: "", quoteBy: "")
//    @Published var quote: String = "Train to bring awareness back every time it drifts away. Be relentless with this practice."
//    @Published var quoteBy: String = "Dandapani"
    
    init() {
        if let localData = self.readLocalFile(forName: "quotes") {
            self.parse(jsonData: localData)
        }
        else {
            print("Setting failsafe quote.")
            self.quote = Quote(quote: "Train to bring awareness back every time it drifts away. Be relentless with this practice.", quoteBy: "Dandapani")
        }
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func loadJson(fromURLString urlString: String,
                          completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let data = data {
                    completion(.success(data))
                }
            }
            
            urlSession.resume()
        }
    }
    
    private func parse(jsonData: Data) {
        do {
            let quotes = try JSONDecoder().decode(Array<Quote>.self, from: jsonData)
            let randomQuote = quotes.randomElement()
            
            if randomQuote != nil {
                print("Setting random quote.")
                self.quote = randomQuote!
            }
        } catch {
            print("decode error")
            print("Error info: \(error)")
        }
    }
}
