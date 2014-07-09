# Setting Up Continuous Integration

[ ] = needs per-developer set up
[√] = needs per-project set up

- [ ] Install Travis
```
> sudo gem install travis
```

- [√] Create .travis.yml file and put in project root
```
> touch .travis.yml
```

- [√] Create basic .travis.yml (see in current repo)

- [√] Create scripts folder with associated scripts (see in current repo)

- [ ] Export developer identity
  - Open Keychain Access
  - In the Category pane, select All Items
  - In the search field type, 'Distribution'
  - If you don't have a Distribution certificate, create one with [Apple](http://developer.apple.com) and add to KeyChain (important because otherwise, TestFlight users must have developer access enabled on their devices)
  - Select the iPhone Distribution certificate for your developer account
  - Hold ⌘ and select the iOS Distribution private key for your developer account
  - With both items selected, select File -> Export items
  - In the Save As sheet,
    - Save As: dist
    - Where: {local repository}/scripts/certs/
    - File Format: Personal Information Exchange (.p12)
    - Select Save
    - Password: Type a strong password; this will be KEY_PASSWORD used later on
    - Verify: Type password again
    - Select OK
  - Before closing Keychain Access, open the Distribution certificate and copy the Common Name under Details.
  - Replace CERT\_COMMON\_NAME with the Distribution certificate's Common Name in .travis.yml
  - Now select only the certificate and save as Certificate format (.cert) in the same directory

- [ ] Export provisioning profile
  - Open Xcode
  - Select Window -> Organizer
  - Plug in your development device
  - Under your device in the left navigation pane, select Provisioning Profiles.
  - Select the provisioning profile for the app
  - Select Editor -> Provisioning Profiles -> Export Profile...
  - Rename as [UUID].mobileprovision and save to {local repository}/scripts/travis/profile/
  - Replace PROVISIONING\_PROFILE\_UUID with the copied UUID in .travis.yml

- [ ] Add encrypted environment variables to .travis.yml

The TestFlight Upload API requires two tokens: team and api. The team token can be found on the [Edit Team Info](https://testflightapp.com/dashboard/team/edit/) page. The api token can be found under Account Settings on the [Upload API](https://testflightapp.com/account/#api) page. Please keep these tokens private. If KEY_PASSWORD contains specials characters, you can enclose it in single quotes or escape the special characters with a single \ character.

  - Open Terminal
  - Execute: gem install travis
  - cd to local repository
  - Execute: travis encrypt "KEY\_PASSWORD=YOUR\_KEY\_PASSWORD" --add
  - Execute: travis encrypt "TEAM\_TOKEN=TESTFLIGHT\_TEAM\_TOKEN" --add
  - Execute: travis encrypt "API\_TOKEN=TESTFLIGHT\_API\_TOKEN" --add
  - cd scripts/travis
  - Make the scripts executable so they can run on Travis CI, execute: chmod a+x *.sh
  - Fill out in .travis.yml TF\_DISTRIBUTION\_LISTS, DEVELOPER\_NAME, and PROFILE\_NAME as listed in the example .travis.yml
