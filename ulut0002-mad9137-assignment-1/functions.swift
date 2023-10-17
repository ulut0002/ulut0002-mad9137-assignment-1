//
//  functions.swift
//  RGBColorApp
//
//  Created by Adesh Shah on 2023-10-05.
//

import Foundation


func getRGBAColor(rgba: String) -> (UInt8,UInt8,UInt8,UInt8){
    
    var red: UInt8 = 0
    var green: UInt8 = 0
    var blue: UInt8 = 0
    var alpha: UInt8 = 255
    
    var hexColor = rgba //String(rgba[rgba.startIndex...])
    
    // 3 or 4 characters are treated as 3 and 4 digit CSS color values
    if hexColor.count == 3 || hexColor.count == 4  {
        var colorCharacterArray = Array(hexColor)
        colorCharacterArray.insert(colorCharacterArray[0], at: 1)
        colorCharacterArray.insert(colorCharacterArray[2], at: 3)
        colorCharacterArray.insert(colorCharacterArray[4], at: 5)
        if colorCharacterArray.count == 7 { // if we started with a 4 digit CSS hex color
            colorCharacterArray.insert(colorCharacterArray[6], at: 7 )
        }
        print(colorCharacterArray)
        hexColor = String(colorCharacterArray)
    }
    
    let scanner = Scanner(string: hexColor)
    var hexNumber: UInt64 = 0
    
    // 8 characters are treated as 8 digit RRGGBBAA values
    if hexColor.count == 8 {
        if scanner.scanHexInt64(&hexNumber) {
            red = UInt8((hexNumber & 0xff000000) >> 24)
            green = UInt8((hexNumber & 0x00ff0000) >> 16)
            blue = UInt8((hexNumber & 0x0000ff00) >> 8)
            alpha = UInt8(hexNumber & 0x000000ff)
        }
        // 6 characters are treated as 6 digit RRGGBB values
    } else if hexColor.count == 6 { // assume no alpha value
        
        if scanner.scanHexInt64(&hexNumber) {
            red = UInt8((hexNumber & 0xff0000) >> 16)
            green = UInt8((hexNumber & 0x00ff00) >> 8)
            blue = UInt8((hexNumber & 0x0000ff))
            alpha = 255 // set to max
        }
    }
    return (red,green,blue,alpha)
}


