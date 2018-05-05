# Differific

[![CI Status](https://travis-ci.org/zenangst/Differific.svg?branch=master)](https://travis-ci.org/zenangst/Differific)
[![Version](https://img.shields.io/cocoapods/v/Differific.svg?style=flat)](http://cocoadocs.org/docsets/Differific)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/Differific.svg?style=flat)](http://cocoadocs.org/docsets/Differific)
[![Platform](https://img.shields.io/cocoapods/p/Differific.svg?style=flat)](http://cocoadocs.org/docsets/Differific)
![Swift](https://img.shields.io/badge/%20in-swift%204.0-orange.svg)

## Description

<img src="https://github.com/zenangst/Differific/blob/master/Images/Differific-icon.png?raw=true" alt="Differific Icon" align="right" />

**Differific** is a diffing tool that helps you compare Hashable objects using the Paul Heckel's diffing algorithm. Creating a changeset is seamless for all your diffing needs. The library also includes some convenience extensions to make life easier when updating data sources.

The library is based and highly influenced by Khoa Pham's ([@onmyway133](https://github.com/onmyway133)) [DeepDiff](https://github.com/onmyway133/DeepDiff) library that aims to solve the same issue. For more information about how the algorithm works and the performance of the algorithm, head over to [DeepDiff](https://github.com/onmyway133/DeepDiff/blob/master/README.md#among-different-frameworks). For the time being, both frameworks are very similar; this is subject to change when the frameworks evolve.

## Features

- [x] 🍩Built-in extensions for updating table & collection views.
- [x] 🏎High performance.
- [x] 📱iOS support.
- [x] 💻macOS support.
- [x] 📺tvOS support.

## Usage

### Diffing two collections

```swift
let old = ["Foo", "Bar"]
let new = ["Foo", "Bar", "Baz"]
let manager = DiffManager()
let changes = manager.diff(old, new)
```

### Updating a table or collection view

```swift
// uiElement is either your table view or collection view.
let old = dataSource.models
let new = newCollection
let changes = DiffManager().diff(old, new)
uiElement.reload(with: changes, before: { dataSource.models = new })
```


## Installation

**Differific** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Differific'
```

**Differific** is also available through [Carthage](https://github.com/Carthage/Carthage).
To install just write into your Cartfile:

```ruby
github "zenangst/Differific"
```

**Differific** can also be installed manually. Just download and drop `Sources` folders in your project.

## Author

- Christoffer Winterkvist, christoffer@winterkvist.com
- Khoa Pham, onmyway133@gmail.com

## Contributing

We would love you to contribute to **Differific**, check the [CONTRIBUTING](https://github.com/zenangst/Differific/blob/master/CONTRIBUTING.md) file for more info.

## License

**Differific** is available under the MIT license. See the [LICENSE](https://github.com/zenangst/Differific/blob/master/LICENSE.md) file for more info.
