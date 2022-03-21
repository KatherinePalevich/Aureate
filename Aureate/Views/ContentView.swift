//
//  ContentView.swift
//  Aureate
//
//  Created by Katherine Palevich on 9/20/21.
//

import Foundation
import SwiftUI
import CoreData

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            MenuView()
            WelcomeView()
        }
    }
}

struct WelcomeView : View{
    let date = Date()
    
    var body: some View {
        VStack{
            Text("Welcome to Aureate").font(.system(size: 20))
            Text("Today's Date:")
            Text(date, style: .date)
            Text(date, style: .time)
            Spacer()
        }
    }
}


struct MenuView: View {
    var body: some View {
        List{
            NavigationLink(destination: EntryList()) {
                Image(systemName: "text.book.closed")
                    .foregroundColor(.black)
                    .imageScale(.large)
                Text("Journal")
                    .foregroundColor(.black)
                    .font(.headline)
            }
            NavigationLink(destination: PlannerView()) {
                Image(systemName: "calendar")
                    .foregroundColor(.black)
                    .imageScale(.large)
                Text("Planner")
                    .foregroundColor(.black)
                    .font(.headline)
            }
            NavigationLink(destination: ToDoView()) {
                Image(systemName: "list.bullet")
                    .foregroundColor(.black)
                    .imageScale(.large)
                Text("To-Do")
                    .foregroundColor(.black)
                    .font(.headline)
            }
            NavigationLink(destination: HabitTrackerView()) {
                Image(systemName: "square.grid.3x3.topleft.fill")
                    .foregroundColor(.black)
                    .imageScale(.large)
                Text("Habit Tracker")
                    .foregroundColor(.black)
                    .font(.headline)
            }
//            NavigationLink(destination: DreamTrackerView()) {
//                Image(systemName: "moon.stars")
//                    .foregroundColor(.black)
//                    .imageScale(.large)
//                Text("Dream Tracker")
//                    .foregroundColor(.black)
//                    .font(.headline)
//            }
        }.navigationTitle("❀ Menu")
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

