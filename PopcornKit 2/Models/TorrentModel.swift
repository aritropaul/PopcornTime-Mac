//
//  TorrentModel.swift
//  PopcornTime-Mac
//
//  Created by Aritro Paul on 09/07/20.
//  Copyright © 2020 Aritro Paul. All rights reserved.
//

import Foundation

struct Magnet : Codable {
    var xt: String?
    var dn: String?
    var tr: [String]?
    var name: String?
    var infoHash: String?
    var announce: [String]?
}
