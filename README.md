<div><img src="icon.png" style="margin:auto; display: block" /></div>
# SwipeTabController

## Overview

<div style="display: table; margin: auto"><img src="img/Topsy.png" /> <img src="img/Turvy.png" style="margin-left: 2em" /></div>

This package implements a "tabbed" view controller, that behaves in a manner similar to Android tabs.

Use this, in place of the classic Apple [`UITabBarController`](https://developer.apple.com/documentation/uikit/uitabbarcontroller/) (but not always. More on that, later).

## What Problem Does This Solve?

The standard iOS [`UITabBarController`](https://developer.apple.com/documentation/uikit/uitabbarcontroller/) has a number of restrictions, and the most obvious one, is that it does not behave like [`UIPageViewController`](https://developer.apple.com/documentation/uikit/uipageviewcontroller/), where you can "swipe" between the tabs.

Android does this. Android also usually has the tab bar on the top of the screen (like browser tabs), as opposed to the iOS positioning (at the bottom of the screen).

By implementing this module, you can have both the "swipe" behavior, and the ability to place the tab bar at either the top, or the bottom, of the screen.

It also helps to work around the issue of the [`UITabBarController`](https://developer.apple.com/documentation/uikit/uitabbarcontroller/)'s propensity to have a separate navigation stack. This module will integrate the displayed screen's navigation stack with the container's navigation stack, giving you continuity with the container's navigation.

And lastly, when implementing [`UITabBarController`](https://developer.apple.com/documentation/uikit/uitabbarcontroller/) in [iPadOS](https://apple.com/ipados), or [MacOS](https://apple.com/macos), Apple will swap out the fixed bottom tab bar, with a segmented control, at the top of the screen. This is not always what the user wants.

## ``LGV_SwipeTabViewController`` vs. [`UITabBarController`](https://developer.apple.com/documentation/uikit/uitabbarcontroller/)

Although the SwipeTabController shares a lot of similarities with [`UITabBarController`](https://developer.apple.com/documentation/uikit/uitabbarcontroller/), there are some crucial differences.

### The Railway Analogy

<div><img src="img/station.png" style="margin:auto; display: block" /></div>

- [`UITabBarController`](https://developer.apple.com/documentation/uikit/uitabbarcontroller/) is like a railway station. You get off one train, and get onto another one. The entire context changes.

<div><img src="img/train.png" style="margin:auto; display: block" /></div>

- ``LGV_SwipeTabViewController`` is more like a switch in the railway tracks. You stay on the train, but change the direction. The context is preserved.

## Usage

In order to use this package, you must either instantiate, or subclass (and instantiate the subclass) the ``LGV_SwipeTabViewController`` class. This is the "wrapper" class that presents a screen with two main components:

- A "Tab Bar" (instance of [`UIToolbar`](https://developer.apple.com/documentation/uikit/uitoolbar))
  
- A Swipeable screen (instance of [`UIPageViewController`](https://developer.apple.com/documentation/uikit/uipageviewcontroller/)).

## LICENSE

### [MIT license](https://opensource.org/licenses/MIT)
 
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

