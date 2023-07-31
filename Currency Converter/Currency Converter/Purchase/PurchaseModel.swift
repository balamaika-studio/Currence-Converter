//
//  SplashModel.swift
//  Currency Converter
//
//  Created by Vlad Sys on 15.05.23.
//  Copyright © 2023 Kiryl Klimiankou. All rights reserved.
//

import StoreKit

enum Purchase {
    
    enum Model {
        struct Request {
            enum RequestType {
                case purchases
            }
        }
        struct Response {
            enum ResponseType {
                case products(_ products: [SKProduct])
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case products(_ products: [SKProduct])
            }
        }
    }
    
}

struct PurchaseArray {
    static let values: [PurchaseDescriptionModel] = [
        PurchaseDescriptionModel(
            title: R.string.localizable.purchaseArrayTitle1(),
            subTitle: R.string.localizable.purchaseArraySubtitle1(),
            image: R.image.purchase1()!
        ),
        PurchaseDescriptionModel(
            title: R.string.localizable.purchaseArrayTitle2(),
            subTitle: R.string.localizable.purchaseArraySubtitle2(),
            image: R.image.purchase2()!
        ),
        PurchaseDescriptionModel(
            title: R.string.localizable.purchaseArrayTitle3(),
            subTitle: R.string.localizable.purchaseArraySubtitle3(),
            image: R.image.purchase3()!
        ),
        PurchaseDescriptionModel(
            title: R.string.localizable.purchaseArrayTitle4(),
            subTitle: R.string.localizable.purchaseArraySubtitle4(),
            image: R.image.purchase4()!
        ),
        PurchaseDescriptionModel(
            title: R.string.localizable.purchaseArrayTitle5(),
            subTitle: R.string.localizable.purchaseArraySubtitle5(),
            image: R.image.purchase5()!
        )
    ]
}
