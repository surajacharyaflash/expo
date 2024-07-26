// Copyright 2015-present 650 Industries. All rights reserved.

import ExpoModulesCore
import WebKit

internal final class ExpoDomWebView: ExpoView, WKUIDelegate, WKScriptMessageHandlerWithReply {
  private var webView: WKWebView!

  public required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
    webView = createWebView()
    if let url = URL(string: "http://localhost:3000/") {
      let request = URLRequest(url: url)
      webView.load(request)
    }
    if #available(iOS 16.4, *) {
      webView.isInspectable = true
    }
    addSubview(webView)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    webView.frame = bounds
  }

  override func removeFromSuperview() {
    webView.configuration.userContentController.removeScriptMessageHandler(forName: "evalAsync")
    super.removeFromSuperview()
  }

  // MARK: - WKUIDelegate implementations

  func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
    guard let appContext else {
      completionHandler("ERROR: Missing AppContext")
      return
    }
    appContext.executeOnJavaScriptThread {
      guard let runtime = try? appContext.runtime else {
        completionHandler("ERROR: Missing JS Runtime")
        return
      }
      do {
        let result = try runtime.eval(prompt)
        // TODO: serialize result from jsi::Value
        completionHandler(result.getString())
      } catch {
        completionHandler("ERROR: \(error)")
      }
    }
  }

  // MARK: - WKScriptMessageHandlerWithReply implementations

  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage, replyHandler: @escaping (Any?, String?) -> Void) {
    if message.name == "evalAsync" {
      guard let appContext else {
        replyHandler(nil, "Missing AppContext")
        return
      }
      // TODO: deserialize message.body
      guard let body = message.body as? String else {
        replyHandler(nil, "Invalid message body type")
        return
      }
      appContext.executeOnJavaScriptThread {
        guard let runtime = try? appContext.runtime else {
          replyHandler(nil, "Missing JS Runtime")
          return
        }
        do {
          let result = try runtime.eval(body)
          // TODO: serialize result from jsi::Value
          replyHandler(result.getString(), nil)
        } catch {
          replyHandler(nil, "\(error)")
        }
      }
      return
    }
    replyHandler(nil, "Unsupported message")
  }

  // MARK: - Internals

  private func createWebView() -> WKWebView {
    let config = WKWebViewConfiguration()
    config.userContentController = WKUserContentController()
    if #available(iOS 14.0, *) {
      config.userContentController.addScriptMessageHandler(self, contentWorld: .page, name: "evalAsync")
    }
    let webView = WKWebView(frame: .zero, configuration: config)
    webView.uiDelegate = self
    return webView
  }
}
