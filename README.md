# WKWebView vs WKWebView WKURLSchemeHandler
## Overview
This repo showed a vanilla `WKWebView` setup versus a `WKWebView WKURLSchemeHandler` setup.

The [WKURLSchemeHandler](https://developer.apple.com/documentation/webkit/wkurlschemehandler) Protocol was introduced with `iOS 11` to allow custom loading of resources.

### Setup
```
git clone https://github.com/rustymagnet3000/WKWebView-and-WKURLSchemeHandler.git

run the app on iOS 11 + Simulator

```
### Open WKURLSchemeHandler tab
```
[*]	URL -> https://www.httpbin.org/
[*]	URL -> https://www.httpbin.org/flasgger_static/swagger-ui.css
[*]	URL -> https://www.httpbin.org/flasgger_static/swagger-ui-bundle.js
[*]	URL -> https://www.httpbin.org/flasgger_static/swagger-ui-standalone-preset.js
[*]	URL -> https://www.httpbin.org/flasgger_static/lib/jquery.min.js
[*]	URL -> https://www.httpbin.org/spec.json
```
### Design and Test
There were two `Unit Tests` inside the project.  I added these tests to observe **speed difference** when hitting a web server.

To make the `Unit Tests` comparable, I did the following:

  - Created a `Vanilla WKWebview Class` that setup the screen lifecycle (`ViewController`)
  - I `delegated` a lot of the `Vanilla WKWebview Class` work to the pre-canned Apple code.
  - I created a `Class` that implemented the `WKURLSchemeHandler protocol`.  My class removed the custom scheme with `https` and sent all requests using `URLSession`.
  - For the `custom scheme Class` I subclassed the `Vanilla WKWebview Class` and overwrote a few custom pieces:
    - Added the `setURLSchemeHandler` to the `WKWebViewConfiguration`
    - Set the scheme to a custom value (`rm`)
    - Set a custom `User-Agent`

### Summary
I sent **6 x 30 requests** to setup and tear down both the Vanilla setup and the custom setup.  The _mean average time_ was:

Vanilla WK | Custom WK
--|--
35.8 seconds | 32.6 seconds

These tests were imperfect test but fun.

1. Custom routing appeared quicker.  Without deeper analysis, my gut said this was more related to my own code  (inside of `YDWKURLSchemeHandler`) that sent the network requests.  I had zero error checking logic compared to Apple's [ assumed ] more robust code.

2. If the webpage linked to a resource on a host that didn't exist, the `WKURLSchemeHandler` would appear much slower.  Different to vanilla `WKWebView` the `Protocol` seemed to force requests into a **serial** queue.  If the server requested a `javascript` or `stylesheet` that were hosted on a black-hole, the entire loading was slowed down.

The below example highlights how the `WKURLSchemeHandler` could appear slower:
```
    Readable		    Epoch			        Resource
[*]	15:58:39	| 1576598319756	-> https://myserver.local/
[*]	15:58:39	| 1576598319894	-> https://myserver.local/styles/bootstrap.min.css
[*]	15:58:39	| 1576598319908	-> https://myserver.local/js/jquery-3.3.1.slim.min.js
[*]	15:58:39	| 1576598319920	-> https://myserver.local/js/popper.min.js
[*]	15:58:39	| 1576598319928	-> https://myserver.local/js/bootstrap.min.js
[*]	15:58:39	| 1576598319938	-> https://blackhole.com//DEADFILE.js <-- non-existing file
[*]	15:58:46	| 1576598326130	-> https://myserver/images/porg.jpg <-- delayed here
```

### Future items
I didn't rule out `caching` affecting the speed results.

Different to `UIWebView`, as the HTML homepage referenced an `absolute path` at googleapis, this request was never invoked:
```
https://fonts.googleapis.com/css?family=Open+Sans:400,700|Source+Code+Pro:300,600|Titillium+Web:400,600,700
```
Hence, `https://www.httpbin.org/` looked prettier in `UIWebView`.



### References
##### Unit Test setup
```
https://www.natashatherobot.com/ios-testing-view-controllers-swift/
https://www.vadimbulavin.com/unit-testing-async-code-in-swift/
https://stackoverflow.com/questions/52172971/xctkvoexpectation-usage-example-in-objective-c
```
