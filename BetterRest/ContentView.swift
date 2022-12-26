//
//  ContentView.swift
//  BetterRest
//
//  Created by Ярослав Грогуль on 23.12.2022.
//

import SwiftUI
import CoreML

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var test3 : String {
        return "\(coffeeAmount) cupsss"
    }
    
    static var defaultWakeTime : Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("When to wake up?")
                                .font(.headline)
                            DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        }



                        VStack(alignment: .leading, spacing: 0) {
                            Text("Desired amount of sleep")
                                .font(.headline)
                            Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                        }


                        VStack(alignment: .leading, spacing: 0) {
                            Text("Daily coffee intake")
                                .font(.headline)
        //                    Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                            Picker(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", selection: $coffeeAmount) {
                                ForEach(1...20, id: \.self) {
                                    Text("\($0)")
                                }
                            }
                        }
                    } header: {
                        Text("Enter you data")
                    }
                    
                    
                    
                    Section {
                        HStack {
                            Spacer()
                            Text("😴")
                                .font(.system(size: 35))
                            Spacer()
                            Text("\(result.message)")
//                                .fontDesign(.rounded)
                                .fontWeight(.light)
                                .font(.system(size: 45))
                            Spacer()
                            Text("😴")
                                .font(.system(size: 35))
                                
                            Spacer()
                        }
                    } header: {
                        Text(result.title)
                            .font(.headline)
                    }
                    
                }
                
                
                
            }
            
            .navigationTitle("BetterSleep")
//            .toolbar {
//                Button("Calculate",  action: calculateBedtime)
//            }
//            .alert(alertTitle, isPresented: $showingAlert) {
//                Button("OK") { }
//            } message: {
//                Text(alertMessage)
//            }
        }
    }
    
    
//    func calculateBedtime() -> String  {
    var result : (title: String, message: String) {
        var title = ""
        var message = ""
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour+minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            title = "Your ideal bedtime is..."
            message = sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            //Error
            title = "Error"
            message = "Sorry, there was a problem calculating your ideal bedtime 😢"
        }
        
        return (title, message)
        
//        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
