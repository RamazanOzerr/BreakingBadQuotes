//
//  ContentView.swift
//  BreakingBadQuotes
//
//  Created by Ramazan Ozer on 11.04.2024.
//

import SwiftUI


struct Quote: Codable{
    var quote: String
    var author: String
}

struct ContentView: View {
    
    @State private var quotes = [Quote]()
    
    
    var body: some View {
        
        NavigationView {
                if quotes.isEmpty {
                    ProgressView("Loading...")
                } else {
                    List(quotes, id: \.author) { quote in
                        VStack(alignment: .leading) {
                            Text(quote.author)
                                .font(.headline)
                            Text(quote.quote)
                                .font(.body)
                        }
                        .padding()
                        .background(Rectangle()
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                                    
                                )
                    }
                }
            }
        .navigationBarTitle("Quotes")
        .navigationBarTitleDisplayMode(.large)
            .task {
                await fetchData()
            }
    }
    
    func fetchData() async{
        // create url
        guard let url = URL(string: "https://api.breakingbadquotes.xyz/v1/quotes/170") else {
            print("something is wrong")
            return
        }
        
        // fetch data from that url
        do{
            let(data, _) = try await URLSession.shared.data(from: url)
            
            // decode that data
            if let decodedResponse = try? JSONDecoder().decode([Quote].self ,from: data){
                quotes = decodedResponse
            }
        } catch{
            print("data is not valid")
        }
        
        
        
    }
}

#Preview {
    ContentView()
}
