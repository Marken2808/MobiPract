//
//  ProspectsView.swift
//  TabView
//
//  Created by Tuan on 12/02/2021.
//

import SwiftUI

struct ProspectsView: View {
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    @EnvironmentObject var prospects: Prospects
    let filter:FilterType
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter{ $0.isContacted}
        case .uncontacted:
            return prospects.people.filter{ !$0.isContacted}
        }
    }
    
    var body: some View {
        NavigationView{
            List{
                ForEach(filteredProspects) {
                    prospect in VStack(alignment: .leading) {
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.emailAddress)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationBarTitle(title)
            .navigationBarItems( trailing: Button(action: {
                let prospect = Prospect()
                prospect.name = "TUAN"
                prospect.emailAddress = "TUAN@mail.com"
                self.prospects.people.append(prospect)
            }) {
                Image(systemName: "qrcode.viewfinder")
                Text("Scan")
            })

        }
        
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
