//
//  ConversionData.swift
//  bonanza
//
//  Created by Evhen Lukhtan on 24.05.2023.
//

import Foundation

// MARK: - ConversionData
struct ConversionData: Codable {
    let redirectResponseData, adgroupID, engmntSource, retargetingConversionType: String
    let isIncentivized: String
    let origCost: Int
    let isFirstLaunch: Bool
    let afClickLookback: String
    let cbPreloadEqualPriorityEnabled: Bool
    let afCpi: String
    let iscache: Bool
    let clickTime, afFPLookbackWindow, isBrandedLink, matchType: String
    let adset, campaignID, installTime, mediaSource: String
    let agency, advertisingID, afSiteid, afStatus: String
    let afSub1: String
    let costCentsUSD: Int
    let afSub5, afSub4, afSub3, afSub2: String
    let adsetID, espName, campaign, httpReferrer: String
    let isUniversalLink: String
    let isRetargeting: Bool
    let adgroup: String
    
    enum CodingKeys: String, CodingKey {
        case redirectResponseData = "redirect_response_data"
        case adgroupID = "adgroup_id"
        case engmntSource = "engmnt_source"
        case retargetingConversionType = "retargeting_conversion_type"
        case isIncentivized = "is_incentivized"
        case origCost = "orig_cost"
        case isFirstLaunch = "is_first_launch"
        case afClickLookback = "af_click_lookback"
        case cbPreloadEqualPriorityEnabled = "CB_preload_equal_priority_enabled"
        case afCpi = "af_cpi"
        case iscache
        case clickTime = "click_time"
        case afFPLookbackWindow = "af_fp_lookback_window"
        case isBrandedLink = "is_branded_link"
        case matchType = "match_type"
        case adset
        case campaignID = "campaign_id"
        case installTime = "install_time"
        case mediaSource = "media_source"
        case agency
        case advertisingID = "advertising_id"
        case afSiteid = "af_siteid"
        case afStatus = "af_status"
        case afSub1 = "af_sub1"
        case costCentsUSD = "cost_cents_USD"
        case afSub5 = "af_sub5"
        case afSub4 = "af_sub4"
        case afSub3 = "af_sub3"
        case afSub2 = "af_sub2"
        case adsetID = "adset_id"
        case espName = "esp_name"
        case campaign
        case httpReferrer = "http_referrer"
        case isUniversalLink = "is_universal_link"
        case isRetargeting = "is_retargeting"
        case adgroup
    }
}

