import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';

import { ExpoDomWebViewProps } from './ExpoDomWebView.types';

const NativeView: React.ComponentType<ExpoDomWebViewProps> =
  requireNativeViewManager('ExpoDomWebViewModule');

export default function ExpoDomWebView(props: ExpoDomWebViewProps) {
  return <NativeView {...props} />;
}
