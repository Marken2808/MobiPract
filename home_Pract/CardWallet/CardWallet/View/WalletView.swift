//
//  WalletView.swift
//  CardWallet
//
//  Created by Tuan on 09/03/2021.
//

import SwiftUI

struct WalletView : View {
    
    
    @Binding var hide : Bool
    
    @State var data = CardViewModel()
    @State var search : String = ""
    
    var body: some View {
         
        VStack{
            BodyWalletView (data: $data.brands, hide: $hide, search: $search)
        }
        .overlay(
            VStack{
                if !hide {
                    TopWalletView(data: $data.brands, search: $search)
                        .padding(.horizontal,8)
                }
            }
            , alignment: .top
                
        )
        
    }
}

struct TopWalletView : View {
    @Environment(\.colorScheme) var scheme
    @Binding var data : [Card]
    @Binding var search : String
    
    var body: some View {
        
        HStack (spacing: 0) {
        
            SearchBar(text: $search)
                .border(scheme == .dark ? Color.black : Color.white)
            Button(action: {

            }, label: {
                Image(systemName: "barcode.viewfinder")
                    .resizable()
                    .frame(width: 30, height: 25)
                    .padding(.trailing, 10)
            })
        }
        .frame(height: 50)
        .background(scheme == .dark ? Color.black : Color.white)
        .cornerRadius(20)
        .shadow(radius: 50)
        
    }
    
    
}

struct BodyWalletView : View{
    
    @State var scrolled = 1
    @Binding var data : [Card]
    @Binding var hide : Bool
    @Binding var search : String
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false){
            
            VStack(spacing: 0) {
                
                ForEach(data.filter({
                    search.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(search)
                })) { card in
                
                    GeometryReader{ geo in
                            
                        DetailCardView(data: card, hide: $hide, dimens: geo)
                            
                            .offset(y: card.expand ? -geo.frame(in: .global).minY : 0)
                            .opacity(hide ? (card.expand ? 1 : 0) : 1)
                            .onTapGesture {
                                
                                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)){
                                    print(card.name)
                                    if !card.expand {
                                        hide.toggle()
                                        card.expand.toggle()
                                    }
                                }
                            }
                    }
                    .frame(height: UIScreen.main.bounds.height / (
                            card.expand ? 1 : (UIScreen.main.bounds.height < 750 ? 2.8 : 3.5) )
                    )
                    .simultaneousGesture(DragGesture(minimumDistance: card.expand ? 0 : 500).onChanged({ (_) in
                        print("dragging")
                        
                    }))
                }
            }
        }
        
    }
    
}

struct DetailCardView : View {    // clickable
    
    @State var data : Card
    @Binding var hide   : Bool
    @State   var dimens : GeometryProxy
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
            
            VStack {
                
                Image(data.image)               // front card
                    .resizable()
                    .frame( height: dimens.size.height / (
                                data.expand ? (UIScreen.main.bounds.height < 750 ? 2.8  : 3.5) :  1.1)
                    )
                    .cornerRadius(data.expand ? 30 : 30)
                    .shadow(radius: 10)
                
                if data.expand {                // back card
                    Image(data.image)
                        .resizable()
                        .frame(height: dimens.size.height / 3)
                        .cornerRadius(25)
                        .shadow(radius: 10)
                }
            }
            .padding(.horizontal, data.expand ? 0 : 15 )
            .padding(.vertical, dimens.size.height / 25)
            .contentShape(Rectangle())
            
            if data.expand {
                
                Button(action: {
                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)){
                        data.expand.toggle()
                        hide.toggle()
                    }
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .clipShape(Circle())
                }
                .padding()
            }
        }
        
    }
}
