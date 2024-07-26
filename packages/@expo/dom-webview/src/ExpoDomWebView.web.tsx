import * as React from 'react';

import { ExpoDomWebViewProps } from './ExpoDomWebView.types';

export default function ExpoDomWebView(props: ExpoDomWebViewProps) {
  return (
    <div>
      <span>{props.name}</span>
    </div>
  );
}
