{
  "resourceType": "GMExtension",
  "resourceVersion": "1.2",
  "name": "AppleIAP",
  "optionsFile": "options.json",
  "options": [
    {"resourceType":"GMExtensionOption","resourceVersion":"1.0","name":"__extOptLabel","extensionId":null,"guid":"2730301d-9b83-48a0-9b16-1c39b365bafb","displayName":"","listItems":[],"description":"","defaultValue":"EXTRA OPTIONS:","exportToINI":false,"hidden":false,"optType":5,},
    {"resourceType":"GMExtensionOption","resourceVersion":"1.0","name":"logLevel","extensionId":null,"guid":"8481187c-e158-4799-9152-c56eb9f7ec31","displayName":"Log Level","listItems":[
        "0",
        "1",
        "2",
      ],"description":"The log level to be used by the script file.\n0: Show only errors\n1: Show errors and warnings (recommended)\n2: Show everything (use before submitting a bug)","defaultValue":"1","exportToINI":false,"hidden":false,"optType":6,},
    {"resourceType":"GMExtensionOption","resourceVersion":"1.0","name":"versionStable","extensionId":null,"guid":"e0ca7ac0-f7b6-4a22-b40e-7196a20beb11","displayName":"","listItems":[],"description":"","defaultValue":"2023.8.1.0","exportToINI":false,"hidden":false,"optType":2,},
    {"resourceType":"GMExtensionOption","resourceVersion":"1.0","name":"versionBeta","extensionId":null,"guid":"33ee7986-9d81-4c17-bc11-d7e601c7a840","displayName":"","listItems":[],"description":"","defaultValue":"2023.800.1.0","exportToINI":false,"hidden":false,"optType":2,},
    {"resourceType":"GMExtensionOption","resourceVersion":"1.0","name":"versionDev","extensionId":null,"guid":"5e8b249e-d1f2-4396-930f-8c5af0459fa4","displayName":"","listItems":[],"description":"","defaultValue":"9.9.1.436","exportToINI":false,"hidden":false,"optType":2,},
    {"resourceType":"GMExtensionOption","resourceVersion":"1.0","name":"versionLTS","extensionId":null,"guid":"a5270933-c4d2-4b3f-a534-5d1f6d8fa6be","displayName":"","listItems":[],"description":"","defaultValue":"2022.0.2.0","exportToINI":false,"hidden":false,"optType":2,},
  ],
  "exportToGame": true,
  "supportedTargets": 9007199254740996,
  "extensionVersion": "1.2.1",
  "packageId": "",
  "productId": "",
  "author": "",
  "date": "2019-07-23T02:12:12",
  "license": "",
  "description": "",
  "helpfile": "",
  "iosProps": true,
  "tvosProps": true,
  "androidProps": false,
  "html5Props": false,
  "installdir": "",
  "files": [
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","filename":"AppleIAP.ext","origname":"","init":"","final":"","kind":4,"uncompress":false,"functions":[
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"iap_Init","externalName":"iap_Init","kind":4,"help":"iap_Init()","hidden":false,"returnType":2,"argCount":0,"args":[],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"iap_QueryProducts","externalName":"iap_QueryProducts","kind":4,"help":"iap_QueryProducts()","hidden":false,"returnType":2,"argCount":0,"args":[],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"iap_IsAuthorisedForPayment","externalName":"iap_IsAuthorisedForPayment","kind":4,"help":"iap_IsAuthorisedForPayment()","hidden":false,"returnType":2,"argCount":0,"args":[],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"iap_AddProduct","externalName":"iap_AddProduct","kind":4,"help":"iap_AddProduct(product_id)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"iap_PurchaseProduct","externalName":"iap_PurchaseProduct","kind":4,"help":"iap_PurchaseProduct(product_id)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"iap_RestorePurchases","externalName":"iap_RestorePurchases","kind":4,"help":"iap_RestorePurchases()","hidden":false,"returnType":2,"argCount":0,"args":[],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"iap_FinishTransaction","externalName":"iap_FinishTransaction","kind":4,"help":"iap_FinishTransaction(purchase_token)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
          ],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"iap_QueryPurchases","externalName":"iap_QueryPurchases","kind":4,"help":"iap_QueryPurchases()","hidden":false,"returnType":1,"argCount":0,"args":[],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"iap_GetReceipt","externalName":"iap_GetReceipt","kind":4,"help":"iap_GetReceipt()","hidden":false,"returnType":1,"argCount":0,"args":[],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"iap_RefreshReceipt","externalName":"iap_RefreshReceipt","kind":4,"help":"iap_RefreshReceipt()","hidden":false,"returnType":2,"argCount":0,"args":[],"documentation":"",},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"iap_ValidateReceipt","externalName":"iap_ValidateReceipt","kind":4,"help":"iap_ValidateReceipt()","hidden":false,"returnType":2,"argCount":0,"args":[],"documentation":"",},
      ],"constants":[
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"ios_error_unknown","value":"-1","hidden":false,},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"ios_no_error","value":"0","hidden":false,},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"ios_error_extension_not_initialised","value":"1","hidden":false,},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"ios_error_no_skus","value":"2","hidden":false,},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"ios_error_duplicate_product","value":"3","hidden":false,},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"ios_payment_queue_update","value":"23000","hidden":false,},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"ios_purchase_success","value":"23001","hidden":false,},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"ios_purchase_failed","value":"23002","hidden":false,},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"ios_purchase_restored","value":"23003","hidden":false,},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"ios_product_update","value":"23004","hidden":false,},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"ios_receipt_refresh","value":"23005","hidden":false,},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"ios_product_period_unit_day","value":"22101","hidden":false,},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"ios_product_period_unit_week","value":"22102","hidden":false,},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"ios_product_period_unit_month","value":"22103","hidden":false,},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"ios_product_period_unit_year","value":"22104","hidden":false,},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"ios_receipt_refresh_success","value":"22500","hidden":false,},
        {"resourceType":"GMExtensionConstant","resourceVersion":"1.0","name":"ios_receipt_refresh_failure","value":"22501","hidden":false,},
      ],"ProxyFiles":[
        {"resourceType":"GMProxyFile","resourceVersion":"1.0","name":"libMacIapExtension.dylib","TargetMask":1,},
      ],"copyToTargets":9007199254740998,"usesRunnerInterface":false,"order":[
        {"name":"iap_Init","path":"extensions/AppleIAP/AppleIAP.yy",},
        {"name":"iap_IsAuthorisedForPayment","path":"extensions/AppleIAP/AppleIAP.yy",},
        {"name":"iap_AddProduct","path":"extensions/AppleIAP/AppleIAP.yy",},
        {"name":"iap_QueryProducts","path":"extensions/AppleIAP/AppleIAP.yy",},
        {"name":"iap_QueryPurchases","path":"extensions/AppleIAP/AppleIAP.yy",},
        {"name":"iap_PurchaseProduct","path":"extensions/AppleIAP/AppleIAP.yy",},
        {"name":"iap_RestorePurchases","path":"extensions/AppleIAP/AppleIAP.yy",},
        {"name":"iap_FinishTransaction","path":"extensions/AppleIAP/AppleIAP.yy",},
        {"name":"iap_GetReceipt","path":"extensions/AppleIAP/AppleIAP.yy",},
        {"name":"iap_ValidateReceipt","path":"extensions/AppleIAP/AppleIAP.yy",},
        {"name":"iap_RefreshReceipt","path":"extensions/AppleIAP/AppleIAP.yy",},
      ],},
  ],
  "HTML5CodeInjection": "",
  "classname": "iOS_InAppPurchase",
  "tvosclassname": "tvOS_InAppPurchase",
  "tvosdelegatename": "tvOS_InAppPurchaseAppDelegate",
  "iosdelegatename": "",
  "androidclassname": "",
  "sourcedir": "",
  "androidsourcedir": "",
  "macsourcedir": "",
  "maccompilerflags": "",
  "tvosmaccompilerflags": "",
  "maclinkerflags": "",
  "tvosmaclinkerflags": "",
  "iosplistinject": "",
  "tvosplistinject": "",
  "androidinject": "",
  "androidmanifestinject": "",
  "androidactivityinject": "",
  "gradleinject": "",
  "androidcodeinjection": "",
  "hasConvertedCodeInjection": true,
  "ioscodeinjection": "",
  "tvoscodeinjection": "\r\n\r\n<YYTvOsPBXBuildFileSection>\r\n7AD06C1017A9100F00B37894 /* StoreKit.framework in Frameworks */ = {isa = PBXBuildFile; fileRef = 7AD06C0F17A9100F00B37894 /* StoreKit.framework */; };\r\n</YYTvOsPBXBuildFileSection>\r\n\r\n<YYTvOsPBXFileReferenceSection>\r\n7AD06C0F17A9100F00B37894 /* StoreKit.framework */ = {isa = PBXFileReference; lastKnownFileType = wrapper.framework; name = StoreKit.framework; path = System/Library/Frameworks/StoreKit.framework; sourceTree = SDKROOT; };\r\n</YYTvOsPBXFileReferenceSection>\r\n\r\n<YYTvOsPBXFrameworksBuildPhaseSection>\r\n7AD06C1017A9100F00B37894 /* StoreKit.framework in Frameworks */,\r\n</YYTvOsPBXFrameworksBuildPhaseSection>\r\n\r\n<YYTvOsFrameworksSection>\r\n7AD06C0F17A9100F00B37894 /* StoreKit.framework */,\r\n</YYTvOsFrameworksSection>\r\n\r\n\r\n",
  "iosSystemFrameworkEntries": [
    {"resourceType":"GMExtensionFrameworkEntry","resourceVersion":"1.0","name":"StoreKit.framework","weakReference":false,"embed":0,},
  ],
  "tvosSystemFrameworkEntries": [],
  "iosThirdPartyFrameworkEntries": [],
  "tvosThirdPartyFrameworkEntries": [],
  "IncludedResources": [],
  "androidPermissions": [],
  "copyToTargets": 9007199254740998,
  "iosCocoaPods": "",
  "tvosCocoaPods": "",
  "iosCocoaPodDependencies": "",
  "tvosCocoaPodDependencies": "",
  "parent": {
    "name": "Extensions",
    "path": "folders/IAPs/Extensions.yy",
  },
}