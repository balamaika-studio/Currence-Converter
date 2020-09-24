//
//  ConverterProducts.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 9/4/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import Foundation

public struct ConverterProducts {
    
    public static let SwiftShopping = "Maksim.Haroshka.CurrencyConverter.NoAds"
    
    private static let productIdentifiers: Set<ProductIdentifier> = [ConverterProducts.SwiftShopping]
    
    public static let store = IAPHelper(productIds: ConverterProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
