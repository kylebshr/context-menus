//
//  Fixtures.swift
//  ContextMenu
//
//  Created by Kyle Bashour on 8/21/19.
//  Copyright © 2019 Kyle Bashour. All rights reserved.
//

import UIKit

enum Fixtures {
    static let lorem = [
            "Lorem ipsum",
            "dolor sit",
            "amet consectetur",
            "adipiscing elit",
            "sed do",
            "eiusmod tempor",
            "incididunt ut",
            "labore et",
            "dolore magna",
            "aliqua Ut",
            "enim ad",
            "minim veniam",
            "quis nostrud",
            "exercitation ullamco",
            "laboris nisi",
            "ut aliquip",
            "ex ea",
            "commodo consequat",
            "Duis aute",
            "irure dolor",
            "in reprehenderit",
            "in voluptate",
            "velit esse",
    ]

    static let cloudSymbols = [
        "cloud",
        "cloud.bolt",
        "cloud.bolt.fill",
        "cloud.bolt.rain",
        "cloud.bolt.rain.fill",
        "cloud.drizzle",
        "cloud.drizzle.fill",
        "cloud.fill",
        "cloud.fog",
        "cloud.fog.fill",
        "cloud.hail",
        "cloud.hail.fill",
        "cloud.heavyrain",
        "cloud.heavyrain.fill",
        "cloud.moon",
        "cloud.moon.bolt",
        "cloud.moon.bolt.fill",
        "cloud.moon.fill",
        "cloud.moon.rain",
        "cloud.moon.rain.fill",
        "cloud.rain",
        "cloud.rain.fill",
        "cloud.sleet",
        "cloud.sleet.fill",
        "cloud.snow",
        "cloud.snow.fill",
        "cloud.sun",
        "cloud.sun.bolt",
        "cloud.sun.bolt.fill",
        "cloud.sun.fill",
        "cloud.sun.rain",
        "cloud.sun.rain.fill",
    ]

    static let colors: [UIColor] = {
        return [
            UIColor.systemRed, .systemRed, .systemRed,
            .systemBlue, .systemBlue, .systemBlue,
            .systemPink, .systemPink, .systemPink,
            .systemGreen, .systemGreen, .systemGreen,
            .systemPurple, .systemPurple, .systemPurple,
            .systemTeal, .systemTeal, .systemTeal,
            .systemOrange, .systemOrange, .systemOrange
        ].shuffled()
    }()
}
