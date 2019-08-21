//
//  IndexPath+NSIndexPath.swift
//  ContextMenu
//
//  Created by Kyle Bashour on 8/20/19.
//  Copyright © 2019 Kyle Bashour. All rights reserved.
//

import Foundation

extension IndexPath {

    /// An NSIndexPath with the same row and section of the receiver.
    var nsIndexPath: NSIndexPath { return .init(row: row, section: section) }
}
