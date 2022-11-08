//
//  ContentView.swift
//  Shared
//
//  Created by Chunwei Shi on 2022/9/2.
//

import SwiftUI


struct ContentView: View {
    @State private var checkAmount = 0.00
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var body: some View {
        NavigationView{ // the navigation view is very important here because the picker will be gray if not included
        //the navigationview also made it possible for iOS to slide in new views as well as the title "WeSplit"
            Form{
                Section{
                    TextField("Amount", value:$checkAmount,format:.currency(code:Locale.current.currencyCode ?? "USD"))
                        .keyboardType(.decimalPad)
                        //the decimalPad automatically starts with the number pad instead of alphabetical one
                
                    Picker("Number of people", selection: $numberOfPeople){
                        ForEach(2..<100){
                            Text("\($0) people")
                        }
                    }
                }
                
                Section{
                    Picker("Tip percentage", selection: tipPercentage){
                        ForEach(tipPercentage, id: \.self){
                            Text($0)
                        }
                    }
                }
                
                Section{
                    Text(checkAmount, format : .currency(code: Locale.current.currencyCode ?? "USD"))
                }
            }
            .navigationTitle("WeSplit")
        }
        
}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

