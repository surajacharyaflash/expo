import { ExpoDomWebView } from '@expo/dom-webview';
import { View } from 'react-native';

export default function App() {
  return (
    <View style={{ flex: 1, marginTop: 64, justifyContent: 'center', alignItems: 'stretch' }}>
      <ExpoDomWebView style={{ flex: 1 }} />
    </View>
  );
}
