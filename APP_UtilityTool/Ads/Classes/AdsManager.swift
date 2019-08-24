//
//  AdsManager.swift
//  APP_Utility
//
//  Created by Alex Cheng on 2019/8/22.
//  Copyright © 2019 Chien-Tai Cheng. All rights reserved.
//

import Foundation
import GoogleMobileAds

public class AdsManager: NSObject {

    public typealias Completion = ((GADRequestError?) -> ())
    private var completion: Completion?
    private var bannerView: GADBannerView?

    public enum AdsPosition {
        case Top
        case Bottom
    }

    public static let shared = AdsManager()

    private override init(){}

    public func createAds(adsUnitID: String, position: AdsPosition, targetVC: UIViewController){
        self.createAds(adsUnitID: adsUnitID, position: position, targetVC: targetVC, completion: nil)
    }

    public func createAds(adsUnitID: String, position: AdsPosition, targetVC: UIViewController, completion: Completion?){
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView!.adUnitID = adsUnitID
        bannerView!.rootViewController = targetVC
        bannerView!.load(GADRequest())
        bannerView!.delegate = self

        targetVC.view.addSubview(bannerView!)
        bannerView!.translatesAutoresizingMaskIntoConstraints = false

        switch position {
        case .Top:
            NSLayoutConstraint.activate([
                bannerView!.topAnchor.constraint(equalTo: targetVC.view.safeAreaLayoutGuide.topAnchor),
                bannerView!.leadingAnchor.constraint(equalTo: targetVC.view.leadingAnchor),
                bannerView!.trailingAnchor.constraint(equalTo: targetVC.view.trailingAnchor),
                ])
        case .Bottom:
            NSLayoutConstraint.activate([
                bannerView!.bottomAnchor.constraint(equalTo: targetVC.view.safeAreaLayoutGuide.bottomAnchor),
                bannerView!.leadingAnchor.constraint(equalTo: targetVC.view.leadingAnchor),
                bannerView!.trailingAnchor.constraint(equalTo: targetVC.view.trailingAnchor),
                ])
        }

        guard let completion = completion else { return }

        self.completion = completion
    }

    public func removeAds() {
        guard let bannerView = self.bannerView else { return }
        bannerView.removeFromSuperview()
    }

}

extension AdsManager: GADBannerViewDelegate {

    // MARK: GADBannerViewDelegate

    public func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        guard let completion = self.completion else { return }
        completion(nil)
    }

    public func adView(_ bannerView: GADBannerView,
                       didFailToReceiveAdWithError error: GADRequestError) {
        guard let completion = self.completion else { return }
        completion(error)
    }

}
