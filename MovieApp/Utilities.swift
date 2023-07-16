//
//  Utilities.swift
//  MovieApp
//
//  Created by emirhan Acısu on 17.07.2023.
//

import Foundation

typealias VoidClosure = (() -> ())
typealias BoolClosure = ((Bool) -> ())
typealias ReloadDataClosure = ((ReloadDataType) -> ())

enum ReloadDataType {
    case tableView
    case collectionView
    case all
}
