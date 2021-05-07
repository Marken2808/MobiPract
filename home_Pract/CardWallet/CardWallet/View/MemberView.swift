//
//  MemberView.swift
//  Payment
//
//  Created by Tuan on 26/03/2021.
//

import SwiftUI

struct MemberView: View {
    
    
    @State var create = ""
    @ObservedObject var memberList = MemberViewModel()
    @State var cartList : [Cart] = []
    
    var body: some View {
        
        VStack(spacing: 20){
            ScrollView(.vertical, showsIndicators: false){
                LazyVStack(alignment: .center, spacing: 10){
                    ForEach(memberList.memberData){ member in
                        HStack(spacing: 0){
                            Text(member.name)
                                .padding(.horizontal, 5)
                            Button(action: {
                                if !memberList.memberData.isEmpty{
                                    memberList.memberData.remove(at: indexMember(mem: member))
                                }
//                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }, label: {
                                Image(systemName: "xmark.circle.fill")
                                    .padding(.all, 5)
                            })
                        }
                        .background(Capsule().stroke(Color.gray.opacity(0.5), lineWidth: 1))
                    }
                }
                .padding()
                
            }
            .frame(width: UIScreen.main.bounds.width - 30 ,height: UIScreen.main.bounds.height / 2)
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5),lineWidth: 1.5))
            .background(Color.white.clipShape(RoundedRectangle(cornerRadius: 10)))


            TextField("Create new member", text: $create, onCommit: onAdd)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5),lineWidth: 1.5))
                .background(Color.white.clipShape(RoundedRectangle(cornerRadius: 10)))
            
            Button(action: { onAdd() }, label: {
                Text("Add member")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.cornerRadius(10))
                    .foregroundColor(Color.white)
            })
            .disabled(create == "")
            .opacity(create == "" ? 0.5 : 1)
            
            
            NavigationLink(destination: ScanningView(memberList: memberList), label: {
                Text("Let's Start")
                    .frame(maxWidth: .infinity)
            })
            .padding()
//            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5),lineWidth: 1.5))
        }
        .padding()
    }
    
    func onAdd() {
        if memberList.memberData.isEmpty{
            memberList.memberData.append(contentsOf: [])
        }
        withAnimation(.default){
            memberList.memberData.append(Member(name: create, total: 0.0, cart: cartList))
            create = ""
        }
    }
    
    func indexMember(mem : Member) -> Int {
        return memberList.memberData.firstIndex{ (mem1) -> Bool in
            return mem.id == mem1.id
        } ?? 0
    }

}

