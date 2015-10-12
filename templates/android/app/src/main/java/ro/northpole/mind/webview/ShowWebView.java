package ${android.packageName};

import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.app.Activity;
import android.content.Context;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import ${android.packageName}.R;


public class ShowWebView extends Activity {

    private WebView webView;

    public void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        if (${android.fullscreen}) {
            this.requestWindowFeature(Window.FEATURE_NO_TITLE);
            this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        }

        setContentView(R.layout.show_web_view);

        webView = (WebView) findViewById(R.id.webView1);
        webView.setWebViewClient(new MyWebViewClient());

        if (${android.offline}) {
            startWebView("file:///android_asset/index.html");
        } else {
          if (haveNetworkConnection()) {
              startWebView("${url}");
          } else {
              startWebView("file:///android_asset/error.html");
          }
        }
    }

    private void startWebView(String url) {

        WebSettings webSettings = webView.getSettings();
        // webView.setSoundEffectsEnabled(true);
        // webView.setScrollBarStyle(WebView.SCROLLBARS_OUTSIDE_OVERLAY);
        // webView.setScrollbarFadingEnabled(false);

        webSettings.setJavaScriptEnabled(true);
        webSettings.setDomStorageEnabled(true);

        // webSettings.setLoadWithOverviewMode(true);
        // webSettings.setUseWideViewPort(true);
        // webSettings.setBuiltInZoomControls(true);

        // webSettings.setJavaScriptCanOpenWindowsAutomatically(true);
        // webSettings.setDatabaseEnabled(true);
        // webSettings.setAllowUniversalAccessFromFileURLs(true);
        // webSettings.setAppCacheEnabled(true);
        // webSettings.setLayoutAlgorithm(webView.getSettings().getLayoutAlgorithm().NORMAL);
        // webSettings.setLoadWithOverviewMode(true);
        // webSettings.setUseWideViewPort(false);

        webView.loadUrl(url);
    }

    private class MyWebViewClient extends WebViewClient {
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            return false;
        }
    }

    @Override
    public void onBackPressed() {
        if (webView.canGoBack()) {
            webView.goBack();
        } else {
            super.onBackPressed();
        }
    }

    private boolean haveNetworkConnection() {
        boolean haveConnectedWifi = false;
        boolean haveConnectedMobile = false;

        ConnectivityManager cm = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo[] netInfo = cm.getAllNetworkInfo();

        for (NetworkInfo ni : netInfo) {
            if (ni.getTypeName().equalsIgnoreCase("WIFI")) {
                if (ni.isConnected()) {
                    haveConnectedWifi = true;
                }
            }
            if (ni.getTypeName().equalsIgnoreCase("MOBILE")) {
                if (ni.isConnected()) {
                    haveConnectedMobile = true;
                }
            }
        }
        return haveConnectedWifi || haveConnectedMobile;
    }

}
