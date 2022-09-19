In order to sign the maciap dylib correctly:

1. Build the project: 
    xcodebuild project=maciapextension.xcodeproj/ archs=arm64

1b. Verify the result of the build, at the time of writing this is created in maciapextension/build/Release/libMacIapExtension.dylib this lib is compatible with Apple Silicon needs to be combined into universal binary using:
    lipo path_to_x86_64.dylib path_to_arm64.dylib -output combined.dylib -create

2. Codesign the result with the entitlements file
*******************************************************************************************************************************************************************
If any customer wants to rebuild this lib, they'll need to use their own "Mac Developer" or other suitable keypair to sign this lib with the correct entitlements.
Otherwise, all binaries will be resigned by the mac app store. IAPs cannot exist outwith the mac app store on macOS.
*******************************************************************************************************************************************************************
    codesign -f -s 60FD4576A3CFC92F4DDC6BFE50A555C13B728048 libMacIapExtension.dylib --entitlements ../../maciapextension/maciaps.entitlements
