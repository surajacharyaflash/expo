import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';
const NativeView = requireNativeViewManager('ExpoDomWebViewModule');
export default function ExpoDomWebView(props) {
    return <NativeView {...props}/>;
}
//# sourceMappingURL=ExpoDomWebView.js.map