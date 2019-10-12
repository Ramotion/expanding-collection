<a href="https://www.ramotion.com/agency/app-development?utm_source=gthb&utm_medium=repo&utm_campaign=expanding-collection"><img src="https://github.com/Ramotion/folding-cell/blob/master/header.png"></a>

<a href="https://github.com/Ramotion/expanding-collection">
<img align="left" src="https://github.com/Ramotion/expanding-collection/blob/master/expanding-collection.gif" width="480" height="360" /></a>

<p><h1 align="left">EXPANDING COLLECTION</h1></p>

<h4>An animated material design UI card peek/pop controller</h4>


___



<p><h6>We specialize in the designing and coding of custom UI for Mobile Apps and Websites.</h6>
<a href="https://www.ramotion.com/agency/app-development?utm_source=gthb&utm_medium=repo&utm_campaign=expanding-collection">
<img src="https://github.com/ramotion/gliding-collection/raw/master/contact_our_team@2x.png" width="187" height="34"></a>
</p>
<p><h6>Stay tuned for the latest updates:</h6>
<a href="https://goo.gl/rPFpid" >
<img src="https://i.imgur.com/ziSqeSo.png/" width="156" height="28"></a></p>

</br>

[![Twitter](https://img.shields.io/badge/Twitter-@Ramotion-blue.svg?style=flat)](http://twitter.com/Ramotion)
[![CocoaPods](https://img.shields.io/cocoapods/p/expanding-collection.svg)](https://cocoapods.org/pods/expanding-collection)
[![CocoaPods](https://img.shields.io/cocoapods/v/expanding-collection.svg)](http://cocoapods.org/pods/expanding-collection)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Ramotion/expanding-collection)
[![Travis](https://travis-ci.org/Ramotion/expanding-collection.svg?branch=master)](https://travis-ci.org/Ramotion/expanding-collection)
[![codebeat badge](https://codebeat.co/badges/6a009992-5bf2-4730-aa35-f3b20ce7693d)](https://codebeat.co/projects/github-com-ramotion-expanding-collection)
[![Donate](https://img.shields.io/badge/Donate-PayPal-blue.svg)](https://paypal.me/Ramotion)

## Requirements

- iOS 9.0+
- Xcode 9.0+

## Installation

Just add the Source folder to your project.

or use [CocoaPods](https://cocoapods.org) with Podfile:
``` ruby
pod 'expanding-collection'
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
    itemSize = CGSize(width: 214, height: 460) //IMPORTANT!!! Height of open state cell
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
override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    headerHeight = ***
}
```
OR

``` swift
required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
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


## 🗂 Check this library on other language:
<a href="https://github.com/Ramotion/expanding-collection-android">
<img src="https://github.com/ramotion/navigation-stack/raw/master/Android_Java@2x.png" width="178" height="81"></a>


## 📄 License

Expanding Collection is released under the MIT license.
See [LICENSE](./LICENSE) for details.

This library is a part of a <a href="https://github.com/Ramotion/swift-ui-animation-components-and-libraries"><b>selection of our best UI open-source projects.</b></a>

If you use the open-source library in your project, please make sure to credit and backlink to www.ramotion.com

## 📱 Get the Showroom App for iOS to give it a try
Try this UI component and more like this in our iOS app. Contact us if interested.

<a href="https://itunes.apple.com/app/apple-store/id1182360240?pt=550053&ct=expanding-collection&mt=8" >
<img src="https://github.com/ramotion/gliding-collection/raw/master/app_store@2x.png" width="117" height="34"></a>

<a href="https://www.ramotion.com/agency/app-development?utm_source=gthb&utm_medium=repo&utm_campaign=expanding-collection">
<img src="https://github.com/ramotion/gliding-collection/raw/master/contact_our_team@2x.png" width="187" height="34"></a>
<br>
<br>
