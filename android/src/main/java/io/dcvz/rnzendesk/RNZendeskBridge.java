package io.dcvz.rnzendesk;

import zendesk.core.Zendesk;
import zendesk.core.AnonymousIdentity;
import zendesk.core.Identity;
import zendesk.core.JwtIdentity;
import zendesk.support.Support;
import zendesk.support.UiConfig;
import zendesk.support.guide.HelpCenterActivity;
import zendesk.support.request.RequestActivity;
import zendesk.support.CustomField;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import java.util.List;
import java.util.Arrays;
import java.util.ArrayList;

public class RNZendeskBridge extends ReactContextBaseJavaModule {

    public RNZendeskBridge(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "RNZendesk";
    }

    @ReactMethod
    public void initialize(ReadableMap config) {
        String appId = config.getString("appId");
        String zendeskUrl = config.getString("zendeskUrl");
        String clientId = config.getString("clientId");
        Zendesk.INSTANCE.init(getReactApplicationContext(), zendeskUrl,
    appId,
    clientId);
        Identity identity = new AnonymousIdentity();
        Zendesk.INSTANCE.setIdentity(identity);

        Support.INSTANCE.init(Zendesk.INSTANCE);
    }

    @ReactMethod
    public void identifyJWT(String token) {
        JwtIdentity identity = new JwtIdentity(token);
        Zendesk.INSTANCE.setIdentity(identity);
    }

    @ReactMethod
    public void showHelpCenter(ReadableMap options) {
      /*
        UiConfig hcConfig = HelpCenterActivity.builder()
                .withContactUsButtonVisible(!(options.hasKey("hideContactSupport") && options.getBoolean("hideContactSupport")))
                .config();

        HelpCenterActivity.builder()
                .show(getReactApplicationContext(), hcConfig);
*/

    CustomField c2 = new CustomField(360016501732L, options.getString("Device_Brand"));
    CustomField c3 = new CustomField(360016554711L, options.getString("Device_Model"));
    CustomField c4 = new CustomField(360016554731L, options.getString("OS"));
    CustomField c5 = new CustomField(360016554911L, options.getString("OS_Version"));
    CustomField c6 = new CustomField(360016554751L, options.getString("App_Version"));
    CustomField c7 = new CustomField(360016502792L, options.getString("Connection"));
    CustomField c8 = new CustomField(360016556691L, options.getString("Phone_or_Tablet"));
    /*
    .withRequestSubject("Android ticket")
    .withTags("android", "mobile")
    */
    UiConfig requestActivityConfig = RequestActivity.builder()
    .withCustomFields(Arrays.asList(c2,c3,c4,c5,c6,c7,c8))
    .config();



    HelpCenterActivity.builder()
    .show(getReactApplicationContext(), requestActivityConfig);
    }

    @ReactMethod
    public void showNewTicket(ReadableMap options) {
      //this code doesn't get called
        ArrayList tags = options.getArray("tags").toArrayList();



        RequestActivity.builder()
                .withTags(tags)
                .show(getReactApplicationContext());
    }
}
