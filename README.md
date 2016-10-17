[![header](https://raw.githubusercontent.com/Ramotion/expanding-collection/master/header.png)](https://business.ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=expanding-collection-logo)

# expanding-collection

[![Twitter](https://img.shields.io/badge/Twitter-@Ramotion-blue.svg?style=flat)](http://twitter.com/Ramotion)
[![CocoaPods](https://img.shields.io/cocoapods/p/expanding-collection.svg)](https://cocoapods.org/pods/expanding-collection)
[![CocoaPods](https://img.shields.io/cocoapods/v/expanding-collection.svg)](http://cocoapods.org/pods/expanding-collection)
[![CocoaPods](https://img.shields.io/cocoapods/metrics/doc-percent/expanding-collection.svg)](https://cdn.rawgit.com/Ramotion/expanding-collection/master/docs/index.html)

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Ramotion/expanding-collection)
[![Travis](https://travis-ci.org/Ramotion/expanding-collection.svg?branch=master)](https://travis-ci.org/Ramotion/expanding-collection)
[![codebeat badge](https://codebeat.co/badges/6a009992-5bf2-4730-aa35-f3b20ce7693d)](https://codebeat.co/projects/github-com-ramotion-expanding-collection)

## About
This project is maintained by Ramotion, Inc.<br>
We specialize in the designing and coding of custom UI for Mobile Apps and Websites.<br><br>**Looking for developers for your project?** [[▶︎CONTACT OUR TEAM◀︎](http://business.ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=expanding-collection-contact-us/#Get_in_Touch)]


[![Animation](https://raw.githubusercontent.com/Ramotion/expanding-collection/master/preview.gif)](https://dribbble.com/shots/2741477-iOS-Expanding-Collection-Open-Source)

The [iPhone mockup](https://store.ramotion.com/product/iphone-6-mockups?utm_source=gthb&utm_medium=special&utm_campaign=expanding-collection) available [here](https://store.ramotion.com/product/iphone-6-mockups?utm_source=gthb&utm_medium=special&utm_campaign=expanding-collection).

## Requirements

- iOS 9.0+
- Xcode 8

## Installation

Just add the Source folder to your project.

or use [CocoaPods](https://cocoapods.org) with Podfile:
``` ruby
pod 'expanding-collection', '~> 1.0.3' swift 3

pod 'expanding-collection', '~> 0.3.2' swift 2
```
or [Carthage](https://github.com/Carthage/Carthage) users can simply add to their `Cartfile`:
```
github "Ramotion/expanding-collection"
```

## Usage

```swift
import expanding_collection
```

#### Create CollectionViewCell
![cell](https://raw.githubusercontent.com/Ramotion/expanding-collection/master/images/image2.png)

1) Create UICollectionViewCell inherit from `BasePageCollectionCell` (recommend create cell with xib file)

2) Adding FrontView
  - add a view to YOURCELL.xib and connect it to `@IBOutlet weak var frontContainerView: UIView!`  
  - add width, height, centerX and centerY constraints (width and height constranints must equal cellSize)

  ![cell](https://raw.githubusercontent.com/Ramotion/expanding-collection/master/images/image1.png)  
  - connect centerY constraint to `@IBOutlet weak var frontConstraintY: NSLayoutConstraint!`
  - add any desired uiviews to frontView

3) Adding BackView
  - repeat step 2 (connect outlets to `@IBOutlet weak var backContainerView: UIView!`, `@IBOutlet weak var backConstraintY: NSLayoutConstraint!`)

4) Cell example [DemoCell](https://github.com/Ramotion/expanding-collection/tree/master/DemoExpandingCollection/DemoExpandingCollection/ViewControllers/DemoViewController/Cells)

###### If set `tag = 101` for any `FrontView.subviews` this view will be hidden during the transition animation

#### Create CollectionViewController  

1) Create a UIViewController inheriting from `ExpandingViewController`

2) Register Cell and set Cell size:

``` swift
override func viewDidLoad() {
    itemSize = CGSize(width: 214, height: 264)
    super.viewDidLoad()

    // register cell
    let nib = UINib(nibName: "NibName", bundle: nil)
    collectionView?.registerNib(nib, forCellWithReuseIdentifier: "CellIdentifier")
}
```

3) Add UICollectionViewDataSource methods

``` swift
extension YourViewController {

  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellIdentifier"), forIndexPath: indexPath)
    // configure cell
    return cell
  }
}
```

4) Open Cell animation

```swift
override func viewDidLoad() {
    itemSize = CGSize(width: 214, height: 264)
    super.viewDidLoad()

    // register cell
    let nib = UINib(nibName: "CellIdentifier", bundle: nil)
    collectionView?.registerNib(nib, forCellWithReuseIdentifier: String(DemoCollectionViewCell))
}
```

``` swift
func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    cell.cellIsOpen(!cell.isOpened)
}
```

###### if you use this delegates method:
```Swift
func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath)

func scrollViewDidEndDecelerating(scrollView: UIScrollView)
```
###### must call super method:  
```Swift
func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
  super.collectionView(collectionView: collectionView, willDisplayCell cell: cell, forItemAtIndexPath indexPath: indexPath)
  // code
}

func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
  super.scrollViewDidEndDecelerating(scrollView: scrollView)
  // code
}
```
#### Transition animation

1) Create a UITableViewController inheriting from `ExpandingTableViewController`

2) Set header height default 236

``` swift
override func viewDidLoad() {
    super.viewDidLoad()
    headerHeight = ***
}  
```

3) Call the push method in YourViewController to YourTableViewController

``` swift
  if cell.isOpened == true {
    let vc: YourTableViewController = // ... create view controller  
    pushToViewController(vc)
  }
```
4) For back transition use `popTransitionAnimation()`


## License

Expanding collection is released under the MIT license.
See [LICENSE](./LICENSE) for details.

## Follow us

[![Twitter URL](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=https://github.com/ramotion/expanding-collection)
[![Twitter Follow](https://img.shields.io/twitter/follow/ramotion.svg?style=social)](https://twitter.com/ramotion)
