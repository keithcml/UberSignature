project="Examples/Swift/UberSignatureDemo.xcodeproj"
scheme="UberSignature"
name="UberSignature"

# clean existing xcframework
rm -rf $name.xcframework

# build simulator
xcodebuild archive \
  -project $project \
  -scheme $scheme \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "build/$name/ios_sim" \
  -derivedDataPath build \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  | xcpretty

# build ios device
xcodebuild archive \
  -project $project \
  -scheme $scheme \
  -destination "generic/platform=iOS" \
  -archivePath "build/$name/ios" \
  -derivedDataPath build \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  | xcpretty

xcodebuild \
  -create-xcframework \
  -framework build/$name/ios.xcarchive/Products/Library/Frameworks/$name.framework \
  -debug-symbols "$PWD/build/$name/ios.xcarchive/dSYMs/$name.framework.dSYM" \
  -framework build/$name/ios_sim.xcarchive/Products/Library/Frameworks/$name.framework \
  -debug-symbols "$PWD/build/$name/ios_sim.xcarchive/dSYMs/$name.framework.dSYM" \
  -output $name.xcframework \
  | xcpretty
