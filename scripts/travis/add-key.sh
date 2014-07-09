# Create and configure keychain
security create-keychain -p travis ios-build.keychain
security default-keychain -s ios-build.keychain
security unlock-keychain -p travis ios-build.keychain
security -v set-keychain-settings -lut 86400 ios-build.keychain

# Import Apple Worldwide Developer Relations Certification Authority certificate
security import scripts/certs/AppleWWDRCA.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign

# Import development certificate
security import scripts/certs/dev.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign

# Import development certificate private key (use password stored in KEY_PASSWORD variable)
security import scripts/certs/dev.p12 -k ~/Library/Keychains/ios-build.keychain -P $KEY_PASSWORD -T /usr/bin/codesign

# Import mobile provisioning profile files
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp scripts/profile/* ~/Library/MobileDevice/Provisioning\ Profiles/
