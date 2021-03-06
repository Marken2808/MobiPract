//
//  CustomSearch.swift
//  CardWallet
//
//  Created by Tuan on 07/05/2021.
//

import SwiftUI

struct CustomSearch: UIViewControllerRepresentable {
    
    func makeCoordinator() -> Coordinator {
        return CustomSearch.Coordinator(parent: self)
    }
    
   
    var view: AnyView
    
    var isLargeTitle: Bool
    
    var title: String
    
    var placeHolder: String
    
    var onSearch: (String)->()
    
    var onCancel: ()->()
    
    init(view: AnyView, placeHolder: String? = "Search", isLargeTitle: Bool? = true, title: String,
         onSearch: @escaping (String)->(), onCancel: @escaping ()->()) {
        
        self.title = title
        self.isLargeTitle = isLargeTitle!
        self.placeHolder = placeHolder!
        self.view = view
        self.onSearch = onSearch
        self.onCancel = onCancel
        
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        
        let childView = UIHostingController(rootView: view)
        
        let controller = UINavigationController(rootViewController: childView)
        
        controller.navigationBar.topItem?.title = title
        
        controller.navigationBar.prefersLargeTitles = isLargeTitle
        
        let searchController = UISearchController()
        
        searchController.searchBar.placeholder = placeHolder
        
        searchController.searchBar.delegate = context.coordinator
        
        searchController.obscuresBackgroundDuringPresentation = false
        
        controller.navigationBar.topItem?.hidesSearchBarWhenScrolling = false
        controller.navigationBar.topItem?.searchController = searchController
        
        return controller
        
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
       
        uiViewController.navigationBar.topItem?.title = title
        uiViewController.navigationBar.prefersLargeTitles = isLargeTitle
        uiViewController.navigationBar.topItem?.searchController?.searchBar.placeholder = placeHolder
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        
        var parent: CustomSearch
        
        init(parent: CustomSearch) {
            self.parent = parent
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.parent.onSearch(searchText)
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            self.parent.onCancel()
        }
        
    }
    
}

