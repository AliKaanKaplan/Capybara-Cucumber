=begin
package com.dt.standalone.pages;

import com.dt.standalone.pageElement.BeinButton;
import com.dt.standalone.pageElement.PageElementModel;
import com.dt.standalone.utils.driver.Driver;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class SbcLandingPage extends SbcMasterPage{
    private static final Log log = LogFactory.getLog(SbcLandingPage.class);
    private static SbcLandingPage instance;

    private static BeinButton BTN_SignUp = new BeinButton(PageElementModel.selectorNames.XPATH,"(//a[@href='/kullanici/hizli-kayit'])[1]");
    public static synchronized SbcLandingPage getInstance() {
        if (instance == null)
            instance = new SbcLandingPage();
        return instance;
    }

    public void goToSignUpPage(){
        log.info("Go to signup page");
        BTN_SignUp.waitUntilVisibleAndClick();


    }

    public void goToPackage(String packageName){
        log.info("Click to package "+packageName+" from landing ");
        BeinButton BTN_PACKAGE = new BeinButton(PageElementModel.selectorNames.XPATH,"//a[contains(@id-for-qa-test, '"+packageName+"')]");
        BTN_PACKAGE.waitUntilVisibleAndClick(3);
    }

    public void checkHomePageContents(String sectionName) {
        log.info("ENTERING checkHomePageContents");
        BeinButton BTN_HomePageContent = new BeinButton(PageElementModel.selectorNames.XPATH, "(//a[text()='" + sectionName + "']/parent::h2/parent::div//a[@class='swiper-slide-item'])[1]");
        BTN_HomePageContent.waitUntilVisibleAndClick();
    }

    public void clickLiveChannel(String channel){
        log.info("ENTERING clickLiveChannel");
        BeinButton BTN_HomePageChannel = new BeinButton(PageElementModel.selectorNames.XPATH, "//a[text()=' Canlı TV']/parent::h2/parent::div//h4[text()='" + channel + "']");
        BTN_HomePageChannel.waitUntilVisibleAndClick();
    }
}

=end