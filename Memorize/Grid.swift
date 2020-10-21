//
//  Grid.swift
//  Memorize
//
//  Created by Andrey Mosolov on 24.09.2020.
//  Copyright © 2020 Andrey Mosolov. All rights reserved.
//

import SwiftUI

//MARK: custom grid as view
struct Grid <Item,ItemView>: View where Item: Identifiable, ItemView: View{
    private var items: [Item]
    private var viewForItem: (Item) -> ItemView
    
    //define array of items
    init (_ items: [Item], viewForItem: @escaping (Item) -> ItemView){
        self.items = items
        self.viewForItem = viewForItem
    }
    
    //draw items in grid
    var body: some View {
        GeometryReader {geometry in
            let layout = GridLayout(itemCount: items.count, in: geometry.size)
            ForEach(items) {item in
                self.body(for: item, in: layout)
            }
        }
    }
    
    //
    private func body (for item: Item, in layout: GridLayout) -> some View{
        /*
        //let index = self.index(of: item)
        let index = items.firstIndex(matching: item)
         //Group returns view or empty view
        return Group{
            if index != nil {
                viewForItem(item)
                .frame(width: layout.itemSize.width, height: layout.itemSize.height)
                .position(layout.location(ofItemAt: index!))
            }
        }*/
        //simplify because should never crash on: index!
        let index = items.firstIndex(matching: item)!
        return viewForItem(item)
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            .position(layout.location(ofItemAt: index))
    }
    
    /*
    func index (of item: Item) -> Int {
        for index in 0..<items.count{
            if items[index].id == item.id {
                return index
            }
        }
        return 0 // TODO: bogus
    }*/
}
