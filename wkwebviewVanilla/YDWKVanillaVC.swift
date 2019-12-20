import UIKit
import WebKit

class YDWKVanillaVC: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var webView: WKWebView!
    var resource: URL = URL(string: Scheme.normal + Endpoint.hostname + Endpoint.path)!
    let wkPathsToObserve = ["loading", "estimatedProgress", "title"]
    
    override func loadView() {
        let configuration = WKWebViewConfiguration()
        let dataStore = WKWebsiteDataStore.nonPersistent()
        configuration.websiteDataStore = dataStore
        configuration.dataDetectorTypes = [.all]
               
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.customUserAgent = "Vanilla WKWebKit UserAgent"
        
        for keyPath in wkPathsToObserve {
            webView.addObserver(self, forKeyPath: keyPath, options: .new, context: nil)
        }
        view = webView
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    //MARK: WKnavigationDelegate
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        ydHandleError(error: error)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ydHandleError(error: error)
    }
    
    func ydHandleError(error: Error) {
        print("[*] ydHandleError: \(error.localizedDescription)")

    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

        decisionHandler(.allow)
        return
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let a = webView.url?.absoluteString {
            print("[*] \(a)")
        }
    }
    
    //MARK: WKUIDelegate
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("[*] runJavaScriptAlertPanelWithMessage called")
        let alertController = UIAlertController(title: message, message: nil,
                                                preferredStyle: UIAlertController.Style.alert);
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) {
            _ in completionHandler()}
        );
        
        self.present(alertController, animated: true, completion: {});
    }
    
    override func viewDidLoad() {
        print("[*]\tviewDidLoad...")
        super.viewDidLoad()
        let myRequest = URLRequest(url: resource)
        self.webView.load(myRequest)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("[*]\tviewDidAppear...")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "loading" {
            print("[*] isLoading -> "  + String(webView.isLoading))
        }
        
        if keyPath == "estimatedProgress" {
            print("[*] progress -> "  + String(webView.estimatedProgress))
        }
        if keyPath == "title" {
            if let title = webView.title {
                print("[*] title -> " + title)
            }
        }
    }
}

