## SPLocalizedString

SPLocalizedString is a library to help iOS developers to localize their apps.

Features:

* Context-based keys
* Plural strings
* Customized ```genstrings``` tool (called ```spgenstrings```) to extract all localizable text from your source code

Features of ```spgenstrings```:

* Based on the work of [Cocoanetics](http://www.cocoanetics.com/) on [DTLocalizableStringScanner](https://github.com/Cocoanetics/DTLocalizableStringScanner)
* Works with ```SPLocalizedString```
* Merges the extracted localized strings with the ones that you already had (probably already translated)
* Removes unused strings and tables if you wish

## Why?

Let's face the truth: ```genstrings``` and the key-based NSLocalizedString with comments are not the best tools to localize your apps. Some reasons:

* ```genstrings``` overrides old files with the new ones (with some translations probably). Therefore you have to manage merging them.
* Adding comments with ```NSLocalizedString``` gives the translator a hint about the context, but two strings with the same key and different comments cannot be referenced from your code separately.
* A key-per-context approach forces you to provide default values for your localized strings or create a strings file during the development cycle.
* It's a closed system: you cannot alter the way these two tools work together because they're not open source. If you don't like SPLocalizedString, fork it and make pull requests or build your own tools :)

## Install SPLocalizedString

1. **Using CocoaPods**

  Add SPLocalizedString to your Podfile:

  ```
  platform :ios, "6.0"
  pod 'SPLocalizedString'
  ```

  Run the following command:

  ```
  pod install
  ```

2. **Static Library**

    Clone the project or add it as a submodule. Drag *SPLocalizedString.xcodeproj* to your project, add it as a target dependency and link *libSPLocalizedString.a*.
    Then, you can simply do:

    ```
    #import <SPLocalizedString/SPLocalizedString.h>
    ```

3. **Manually**

  Clone the project or add it as a submodule. Drag the whole SPLocalizedString folder to your project.

## Usage of SPLocalizedString

Its usage is very similar to NSLocalizedString, but with a fundamental change: aside from the key you don't provide a comment, you provide a *context*. Example:

```objective-c
someLabel.text = SPLocalizedString(@"Name", @"Name label in login screen")
...
otherLabel.text = SPLocalizedString(@"Name", @"Name label in registration screen")
```

Depending on your UI layout, the target languages and other factors, you may need different texts for those two labels even if they have the same text in the beginning. Therefore, SPLocalizedString considers the *context* as part of the key.

In order to fulfill these strings properly, you'll need a Localizable.strings file with the following lines:

```
"(Name label in login screen)Name" = "Name";
"(Name label in registration screen)Name" = "Name";
```

As you can see, for each string the actual key is made of the context and the key you specified with SPLocalizedString.

This file can be automatically generated with ```spgenstrings```. If you don't have a strings file yet, the default value will be the given key (in this case _Name_).

### Plurals

SPLocalizedString provides some useful functions to manage plurals: *SPLocalizedStringPlural*, which accepts an additional parameter after the context indicating the _number_ of elements referenced in the string. For example:

```objective-c
NSString *formatString = SPLocalizedStringPlural(@"You have %d followers.", @"Number of followers label", numberOfFollowers);
followersLabel.text = [NSString stringWithFormat:formatString, numberOfFollowers];
```

In order to fulfill these strings properly, you'll need a Localizable.strings file with the following lines:

```
"(Number of followers label##one)You have %d followers." = "You have %d followers.";
"(Number of followers label##other)You have %d followers." = "You have %d followers.";
```

Again, this file can be automatically generated with ```spgenstrings```. If you don't have a strings file yet, the default value will be the given key (in this case _You have %d followers._).

If you look closely, for one key and context you need 2 strings: one when you have 1 follower (with the *##one* suffix in the context), another one for the rest of cases (with the *##other* suffix in the context). An example would be:

```
"(Number of followers label##one)You have %d followers." = "You have just one follower.";
"(Number of followers label##other)You have %d followers." = "You have %d followers.";
```

## Install spgenstrings

1. Open the spgenstrings.xcodeproj project with Xcode
2. Click on _Product > Archive_
3. In the _Organizer > Archives_, you'll se the list of archives of spgenstrings. Right-click the most recent one and select _Show in Finder_.
4. Right-click on the xcarchive file and click on _Show Package Contents_.
5. Finally go into _Products/usr/local/bin_ and there you'll find the ```spgenstrings``` executable file.

Place that file wherever you need it :)

## Usage of spgenstrings

```spgenstrings``` is a command line tool. It's based on [genstrings2](https://github.com/Cocoanetics/DTLocalizableStringScanner) (an open source implementation of ```genstrings``` by [Cocoanetics](http://www.cocoanetics.com/)), so it shares most of the options with the original ```genstrings```.

The most common way to use it is:
```bash
spgenstrings -deleteUnusedEntries -deleteUnusedTables -o <output dir> <source files to process...>
```

The ```-deleteUnusedEntries``` and ```-deleteUnusedTables``` options removes old entries and strings files that are not referenced anymore in your source code.

## Contact

SPLocalizedString was created by Sergio Padrino: [@sergiou87](https://twitter.com/sergiou87), based on the work of [Cocoanetics](http://www.cocoanetics.com/) on [DTLocalizableStringScanner](https://github.com/Cocoanetics/DTLocalizableStringScanner).

## Contributing

If you want to contribute to the project just follow this steps:

1. Fork the repository.
2. Clone your fork to your local machine.
3. Create your feature branch.
4. Commit your changes, push to your fork and submit a pull request.

## Apps using SPLocalizedString and spgenstrings

* [Fever](https://itunes.apple.com/us/app/fever-event-discovery-app/id497702817?mt=8)
* [Fon Utility App](https://itunes.apple.com/us/app/utility-app/id737828006?mt=8)
* [Plex](https://itunes.apple.com/en/app/plex/id383457673?mt=8)

## Contributions
* [Daniel Martín](http://github.com/danielmartin): Add support for non-literal strings ([#2](https://github.com/sergiou87/SPLocalizedString/pull/2)).
* [James Clarke](http://github.com/jam): Allow opting out of the context-prefixing behaviour ([#3](https://github.com/sergiou87/SPLocalizedString/pull/3)).

## License

SPLocalizedString is available under the MIT license. See the [LICENSE file](https://github.com/sergiou87/SPLocalizedString/blob/master/LICENSE) for more info.
