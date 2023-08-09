//
//  GADNatvieAdFactory.swift
//  Runner
//
//  Created by yangjian on 2023/8/3.
//

import UIKit
import google_mobile_ads

class GADNatvieAdFactory: NSObject {
    
}

extension GADNatvieAdFactory: FLTNativeAdFactory {
    func createNativeAd(_ nativeAd: GADNativeAd, customOptions: [AnyHashable : Any]? = nil) -> GADNativeAdView? {
        if let adView = Bundle.main.loadNibNamed("GADNativeView", owner: self)?.first as? GADNativeAdView {
            print("----------------------哈哈哈\(nativeAd.body) \(nativeAd.responseInfo.responseIdentifier)")
            DispatchQueue.main.async {
                adView.nativeAd = nativeAd
            }
            return adView
        }
        return nil
    }
}
