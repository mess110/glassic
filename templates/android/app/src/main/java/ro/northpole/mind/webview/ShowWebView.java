package ro.northpole.mind.webview;

import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.view.Window;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import ro.northpole.music.webview.R;


public class ShowWebView extends Activity {

    private boolean haveNetworkConnection() {
        boolean haveConnectedWifi = false;
        boolean haveConnectedMobile = false;

        ConnectivityManager cm = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo[] netInfo = cm.getAllNetworkInfo();

        for (NetworkInfo ni : netInfo) {
            if (ni.getTypeName().equalsIgnoreCase("WIFI"))
                if (ni.isConnected())
                    haveConnectedWifi = true;
            if (ni.getTypeName().equalsIgnoreCase("MOBILE"))
                if (ni.isConnected())
                    haveConnectedMobile = true;
        }
        return haveConnectedWifi || haveConnectedMobile;
    }

    private WebView webView;

    public void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        this.requestWindowFeature(Window.FEATURE_NO_TITLE);

        setContentView(R.layout.show_web_view);

        webView = (WebView) findViewById(R.id.webView1);
        if (haveNetworkConnection()) {
            startWebView("${url}");
        } else {
            webView.loadUrl("file:///android_asset/error.html");
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


    @Override
    public void onBackPressed() {
        if (webView.canGoBack()) {
            webView.goBack();
        } else {
            super.onBackPressed();
        }
    }

}
