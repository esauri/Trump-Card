//
//  DraggableViewDelegate.swift
//  TrumpCard
//
//  Created by Erick Sauri on 12/10/16.
//  Copyright © 2016 Erick Sauri. All rights reserved.
//

import Foundation

protocol DraggableViewDelegate {
    func cardSwipedLeft(_ _card: DraggableView)
    func cardSwipedRight(_ _card: DraggableView)
}
