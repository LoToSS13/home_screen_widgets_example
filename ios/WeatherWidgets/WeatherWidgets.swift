//
//  WeatherWidgets.swift
//  WeatherWidgets
//
//  Created by Aleksei Zubankov on 04.02.2024.
//

import WidgetKit
import SwiftUI

struct WeatherDataEntry: TimelineEntry {
    let date: Date
    let cityName: String
    let currentWeather: String
    let description: String
    let filename: String
    let displaySize: CGSize
}


struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WeatherDataEntry {
        WeatherDataEntry(date: Date(), cityName: "Прекрасный город", currentWeather: "21.5", description: "Ясно",filename: "No screenshot available",  displaySize: context.displaySize )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WeatherDataEntry) -> ()) {
        let entry: WeatherDataEntry
        if context.isPreview{
            entry = placeholder(in: context)
        } else {
            //  Get the data from the user defaults to display
            let userDefaults = UserDefaults(suiteName: "group.example.testHomeScreenWidgets")
            let cityName = userDefaults?.string(forKey: "city_name") ?? "No City Name Set"
            let stringDate = userDefaults?.string(forKey: "date") ?? "No Date set"
            let currentWeather = userDefaults?.string(forKey: "current_weather") ?? "No Weather Set"
            let description = userDefaults?.string(forKey: "description") ?? "No Description Set"
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
            let date = dateFormatter.date(from:stringDate) ?? Date()
            
            let filename = userDefaults?.string(forKey: "filename") ?? "No screenshot available"
            
            entry = WeatherDataEntry(date: date, cityName: cityName, currentWeather: currentWeather, description: description, filename: filename, displaySize: context.displaySize)
        }
        completion(entry)
    }
    
    //getTimeline is called for the current and optionally future times to update the widget
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        //This just uses the snapshot function you defined earlier
        getSnapshot(in: context) { (entry) in
            // atEnd policy tells widgetkit to request a new entry after the date has passed
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}
    
    struct WeatherWidgetsEntryView : View {
        var entry: Provider.Entry
        
        var ChartImage: some View {
               if let uiImage = UIImage(contentsOfFile: entry.filename) {
                   let image = Image(uiImage: uiImage)
                       .resizable()
                       .frame(width: entry.displaySize.height*0.2, height: entry.displaySize.height*0.2, alignment: .center)
                   return AnyView(image)
               }
               print("The image file could not be loaded")
               return AnyView(EmptyView())
           }
        
        var body: some View {
            VStack {
                Text("Последнее обновление:")
                Text(entry.date, style: .time)
                Text(entry.cityName)
                Text(entry.currentWeather)
                HStack {
                    Text(entry.description)
                    ChartImage
                }
                
            }
        }
    }
    
    struct WeatherWidgets: Widget {
        let kind: String = "TestWidgets"
        
        var body: some WidgetConfiguration {
            StaticConfiguration(kind: kind, provider: Provider()) { entry in
                if #available(iOS 17.0, *) {
                    WeatherWidgetsEntryView(entry: entry)
                        .containerBackground(.fill.tertiary, for: .widget)
                } else {
                    WeatherWidgetsEntryView(entry: entry)
                        .padding()
                        .background()
                }
            }
            .configurationDisplayName("My Widget")
            .description("This is an example widget.")
        }
    }
    

