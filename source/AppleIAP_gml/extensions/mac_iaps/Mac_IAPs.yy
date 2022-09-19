{
  "optionsFile": "options.json",
  "options": [],
  "exportToGame": true,
  "supportedTargets": 2,
  "extensionVersion": "1.0.6",
  "packageId": "",
  "productId": "",
  "author": "",
  "date": "2019-07-30T10:59:40",
  "license": "",
  "description": "",
  "helpfile": "",
  "iosProps": false,
  "tvosProps": false,
  "androidProps": false,
  "installdir": "",
  "files": [
    {"filename":"libMacIapExtension.dylib","origname":"","init":"mac_iap_Init","final":"mac_iap_Final","kind":1,"uncompress":false,"functions":[
        {"externalName":"mac_iap_Init","kind":1,"help":"mac_iap_Init()","hidden":false,"returnType":2,"argCount":0,"args":[],"resourceVersion":"1.0","name":"mac_iap_Init","tags":[],"resourceType":"GMExtensionFunction",},
        {"externalName":"mac_iap_IsAuthorisedForPayment","kind":1,"help":"mac_iap_IsAuthorisedForPayment()","hidden":false,"returnType":2,"argCount":0,"args":[],"resourceVersion":"1.0","name":"mac_iap_IsAuthorisedForPayment","tags":[],"resourceType":"GMExtensionFunction",},
        {"externalName":"mac_iap_AddProduct","kind":1,"help":"mac_iap_AddProduct(product_id)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
          ],"resourceVersion":"1.0","name":"mac_iap_AddProduct","tags":[],"resourceType":"GMExtensionFunction",},
        {"externalName":"mac_iap_QueryProducts","kind":1,"help":"mac_iap_QueryProducts()","hidden":false,"returnType":2,"argCount":0,"args":[],"resourceVersion":"1.0","name":"mac_iap_QueryProducts","tags":[],"resourceType":"GMExtensionFunction",},
        {"externalName":"mac_iap_QueryPurchases","kind":1,"help":"mac_iap_QueryPurchases()","hidden":false,"returnType":1,"argCount":0,"args":[],"resourceVersion":"1.0","name":"mac_iap_QueryPurchases","tags":[],"resourceType":"GMExtensionFunction",},
        {"externalName":"mac_iap_PurchaseProduct","kind":1,"help":"mac_iap_PurchaseProduct(product_id)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
          ],"resourceVersion":"1.0","name":"mac_iap_PurchaseProduct","tags":[],"resourceType":"GMExtensionFunction",},
        {"externalName":"mac_iap_RestorePurchases","kind":1,"help":"mac_iap_RestorePurchases()","hidden":false,"returnType":2,"argCount":0,"args":[],"resourceVersion":"1.0","name":"mac_iap_RestorePurchases","tags":[],"resourceType":"GMExtensionFunction",},
        {"externalName":"mac_iap_FinishTransaction","kind":1,"help":"mac_iap_FinishTransaction(purchase_token)","hidden":false,"returnType":2,"argCount":0,"args":[
            1,
          ],"resourceVersion":"1.0","name":"mac_iap_FinishTransaction","tags":[],"resourceType":"GMExtensionFunction",},
        {"externalName":"mac_iap_GetReceipt","kind":1,"help":"mac_iap_GetReceipt()","hidden":false,"returnType":1,"argCount":0,"args":[],"resourceVersion":"1.0","name":"mac_iap_GetReceipt","tags":[],"resourceType":"GMExtensionFunction",},
        {"externalName":"mac_iap_Final","kind":1,"help":"mac_iap_Final()","hidden":false,"returnType":2,"argCount":0,"args":[],"resourceVersion":"1.0","name":"mac_iap_Final","tags":[],"resourceType":"GMExtensionFunction",},
        {"externalName":"RegisterCallbacks","kind":1,"help":"Glue function, not required to be called.","hidden":false,"returnType":2,"argCount":0,"args":[],"resourceVersion":"1.0","name":"RegisterCallbacks","tags":[],"resourceType":"GMExtensionFunction",},
        {"externalName":"mac_iap_exit","kind":1,"help":"mac_iap_exit(exit_code)","hidden":false,"returnType":2,"argCount":0,"args":[
            2,
          ],"resourceVersion":"1.0","name":"mac_iap_exit","tags":[],"resourceType":"GMExtensionFunction",},
        {"externalName":"mac_iap_ValidateReceipt","kind":1,"help":"mac_iap_ValidateReceipt()","hidden":false,"returnType":2,"argCount":0,"args":[],"resourceVersion":"1.0","name":"mac_iap_ValidateReceipt","tags":[],"resourceType":"GMExtensionFunction",},
        {"externalName":"mac_iap_RefreshReceipt","kind":1,"help":"mac_iap_RefreshReceipt","hidden":false,"returnType":2,"argCount":0,"args":[],"resourceVersion":"1.0","name":"mac_iap_RefreshReceipt","tags":[],"resourceType":"GMExtensionFunction",},
      ],"constants":[
        {"value":"-1","hidden":false,"resourceVersion":"1.0","name":"mac_error_unknown","tags":[],"resourceType":"GMExtensionConstant",},
        {"value":"0","hidden":false,"resourceVersion":"1.0","name":"mac_no_error","tags":[],"resourceType":"GMExtensionConstant",},
        {"value":"1","hidden":false,"resourceVersion":"1.0","name":"mac_error_extension_not_initialised","tags":[],"resourceType":"GMExtensionConstant",},
        {"value":"2","hidden":false,"resourceVersion":"1.0","name":"mac_error_no_skus","tags":[],"resourceType":"GMExtensionConstant",},
        {"value":"3","hidden":false,"resourceVersion":"1.0","name":"mac_error_duplicate_product","tags":[],"resourceType":"GMExtensionConstant",},
        {"value":"33100","hidden":false,"resourceVersion":"1.0","name":"mac_payment_queue_update","tags":[],"resourceType":"GMExtensionConstant",},
        {"value":"33101","hidden":false,"resourceVersion":"1.0","name":"mac_purchase_success","tags":[],"resourceType":"GMExtensionConstant",},
        {"value":"33102","hidden":false,"resourceVersion":"1.0","name":"mac_purchase_failed","tags":[],"resourceType":"GMExtensionConstant",},
        {"value":"33103","hidden":false,"resourceVersion":"1.0","name":"mac_purchase_restored","tags":[],"resourceType":"GMExtensionConstant",},
        {"value":"33104","hidden":false,"resourceVersion":"1.0","name":"mac_product_update","tags":[],"resourceType":"GMExtensionConstant",},
        {"value":"32105","hidden":false,"resourceVersion":"1.0","name":"mac_product_period_unit_day","tags":[],"resourceType":"GMExtensionConstant",},
        {"value":"32106","hidden":false,"resourceVersion":"1.0","name":"mac_product_period_unit_week","tags":[],"resourceType":"GMExtensionConstant",},
        {"value":"32107","hidden":false,"resourceVersion":"1.0","name":"mac_product_period_unit_month","tags":[],"resourceType":"GMExtensionConstant",},
        {"value":"32108","hidden":false,"resourceVersion":"1.0","name":"mac_product_period_unit_year","tags":[],"resourceType":"GMExtensionConstant",},
        {"value":"173","hidden":false,"resourceVersion":"1.0","name":"mac_invalid_receipt_exit_code","tags":[],"resourceType":"GMExtensionConstant",},
        {"value":"33105","hidden":false,"resourceVersion":"1.0","name":"mac_receipt_refresh","tags":[],"resourceType":"GMExtensionConstant",},
        {"value":"32502","hidden":false,"resourceVersion":"1.0","name":"mac_receipt_refresh_success","tags":[],"resourceType":"GMExtensionConstant",},
        {"value":"32503","hidden":false,"resourceVersion":"1.0","name":"mac_receipt_refresh_failure","tags":[],"resourceType":"GMExtensionConstant",},
      ],"ProxyFiles":[],"copyToTargets":2,"order":[
        {"name":"mac_iap_Init","path":"extensions/Mac_IAPs/Mac_IAPs.yy",},
        {"name":"mac_iap_Final","path":"extensions/Mac_IAPs/Mac_IAPs.yy",},
        {"name":"mac_iap_IsAuthorisedForPayment","path":"extensions/Mac_IAPs/Mac_IAPs.yy",},
        {"name":"mac_iap_AddProduct","path":"extensions/Mac_IAPs/Mac_IAPs.yy",},
        {"name":"mac_iap_QueryProducts","path":"extensions/Mac_IAPs/Mac_IAPs.yy",},
        {"name":"mac_iap_QueryPurchases","path":"extensions/Mac_IAPs/Mac_IAPs.yy",},
        {"name":"mac_iap_PurchaseProduct","path":"extensions/Mac_IAPs/Mac_IAPs.yy",},
        {"name":"mac_iap_RestorePurchases","path":"extensions/Mac_IAPs/Mac_IAPs.yy",},
        {"name":"mac_iap_FinishTransaction","path":"extensions/Mac_IAPs/Mac_IAPs.yy",},
        {"name":"mac_iap_GetReceipt","path":"extensions/Mac_IAPs/Mac_IAPs.yy",},
        {"name":"mac_iap_exit","path":"extensions/Mac_IAPs/Mac_IAPs.yy",},
        {"name":"RegisterCallbacks","path":"extensions/Mac_IAPs/Mac_IAPs.yy",},
        {"name":"mac_iap_ValidateReceipt","path":"extensions/Mac_IAPs/Mac_IAPs.yy",},
        {"name":"mac_iap_RefreshReceipt","path":"extensions/Mac_IAPs/Mac_IAPs.yy",},
      ],"resourceVersion":"1.0","name":"","tags":[],"resourceType":"GMExtensionFile",},
  ],
  "classname": "",
  "tvosclassname": "",
  "tvosdelegatename": "",
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
  "tvoscodeinjection": "",
  "iosSystemFrameworkEntries": [],
  "tvosSystemFrameworkEntries": [],
  "iosThirdPartyFrameworkEntries": [],
  "tvosThirdPartyFrameworkEntries": [],
  "IncludedResources": [],
  "androidPermissions": [],
  "copyToTargets": 2,
  "iosCocoaPods": "",
  "tvosCocoaPods": "",
  "iosCocoaPodDependencies": "",
  "tvosCocoaPodDependencies": "",
  "parent": {
    "name": "Extensions",
    "path": "folders/IAPs/Extensions.yy",
  },
  "resourceVersion": "1.2",
  "name": "Mac_IAPs",
  "tags": [],
  "resourceType": "GMExtension",
}