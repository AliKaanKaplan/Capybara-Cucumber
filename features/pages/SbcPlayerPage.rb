=begin
package com.dt.standalone.pages;

import com.amazonaws.services.dynamodbv2.document.Page;
import com.dt.standalone.backend.AutomationException;
import com.dt.standalone.backend.ContextKeys;
import com.dt.standalone.backend.DTSoapConnection;
import com.dt.standalone.backend.DtAutomationContext;
import com.dt.standalone.model.DtSystemUserSoap;
import com.dt.standalone.pageElement.BeinButton;
import com.dt.standalone.pageElement.BeinLabel;
import com.dt.standalone.pageElement.BeinTextBox;
import com.dt.standalone.pageElement.PageElementModel;
import com.dt.standalone.utils.WebService.RestUserService;
import com.dt.standalone.utils.dbquery.DBQueryUtil;
import com.dt.standalone.utils.driver.Driver;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebElement;

import static java.lang.Integer.parseInt;

public class SbcPlayerPage extends SbcMasterPage {
    private static final Log log = LogFactory.getLog(SbcPlayerPage.class);
    private static SbcPlayerPage instance;
    private static BeinButton BTN_CancelBlackout = new BeinButton(PageElementModel.selectorNames.CLASS_NAME, "return-blackout");
    private static BeinButton BTN_CancelBlackoutLiveChannel = new BeinButton(PageElementModel.selectorNames.XPATH, "//button[@aria-label='Uyduya Aktar']");
    private static BeinButton BTN_ACCEPT_CANCEL_BLACKOUT_CHANNEL = new BeinButton(PageElementModel.selectorNames.XPATH,"//button[@aria-label='Bu Yayını Kapat ve Uydudan İzle']");
    private static BeinButton BTN_TvPlayer = new BeinButton(PageElementModel.selectorNames.ID, "bitmovinplayer-video-player");
    private static BeinButton BTN_PPVPlayer = new BeinButton(PageElementModel.selectorNames.ID, "bitmovinplayer-video-playerLiveTvBitmovin");

    private static BeinButton BTN_FULL_SCREEN = new BeinButton(PageElementModel.selectorNames.XPATH,"//button[@class='bmpui-ui-fullscreentogglebutton bmpui-on']");
    private static BeinButton BTN_SMALL_SCREEN = new BeinButton(PageElementModel.selectorNames.XPATH,"//button[@class='bmpui-ui-fullscreentogglebutton bmpui-off']");
    private static BeinButton BTN_PLAYER = new BeinButton(PageElementModel.selectorNames.ID, "player");
    private static BeinButton BTN_CHANNEL_LIST = new BeinButton(PageElementModel.selectorNames.ID, "bmpui-id-66");
    private static BeinButton BTN_ContentPlayer = new BeinButton(PageElementModel.selectorNames.ID, "bitmovinplayer-video-player");
    private static BeinButton BTN_PlayerToggleOff = new BeinButton(PageElementModel.selectorNames.XPATH, "//button[@class='bmpui-ui-playbacktogglebutton bmpui-off']");
    private static BeinButton BTN_PlayerToggleOn = new BeinButton(PageElementModel.selectorNames.XPATH, "//button[@class='bmpui-ui-playbacktogglebutton bmpui-on']");
    private static BeinButton BTN_BuyPackage = new BeinButton(PageElementModel.selectorNames.XPATH, "(//a[@class='package-item-link package-item-offer-link'])[1]");
    private static BeinTextBox TXT_SmsCode = new BeinTextBox(PageElementModel.selectorNames.NAME, "lname");
    private static BeinButton BTN_SmsConfirm = new BeinButton(PageElementModel.selectorNames.ID, "confirmation-code-send");
    private static BeinButton BTN_PLAYER_CLOSE = new BeinButton(PageElementModel.selectorNames.CLASS_NAME, "video-close-btn");
    private static BeinLabel LBL_WATCH_TIME = new BeinLabel(PageElementModel.selectorNames.XPATH, "//div[@class='watch-info']//div//span");
    private static BeinLabel LBL_CONTENT_HEADER = new BeinLabel(PageElementModel.selectorNames.XPATH, "//div[@class='general-info-area']//h1");
    private static BeinLabel LBL_EPISODE_WATCHED = new BeinLabel(PageElementModel.selectorNames.XPATH, "//div[@class='remain']//a");
    private static BeinTextBox TXT_CHANNEL_SEARCH = new BeinTextBox(PageElementModel.selectorNames.XPATH, "//input[@type='search']");
    private static BeinButton BTN_PLAYER_PLAY_PAUSE = new BeinButton(PageElementModel.selectorNames.ID, "bmpui-id-81");
    private static BeinLabel LBL_PLAYER_LOADING = new BeinLabel(PageElementModel.selectorNames.XPATH, "//div[@class='bmpui-bein-loading-indicator']");
    private static BeinLabel LBL_Broadcast = new BeinLabel(PageElementModel.selectorNames.XPATH, "//ul[@id='bmpui-id-30']//li[@class='bc-list-item bc-list-item-active']//a");
    private static BeinButton BTN_Broadcast_Icon = new BeinButton(PageElementModel.selectorNames.XPATH,"//button[@label='TvGuide']");
    public static synchronized SbcPlayerPage getInstance() {
        if (instance == null)
            instance = new SbcPlayerPage();
        return instance;
    }

    public void clickCancelBlackout() {
        log.info("ENTERING clickCancelBlackout");
        BTN_CancelBlackout.waitUntilVisibleAndClick();
    }

    public void clickCancelBlackoutLiveChannel() {
        log.info("ENTERING clickCancelBlackoutLiveChannel");
        BTN_TvPlayer.waitUntilVisible();
        BTN_TvPlayer.hoverOn();
        BTN_CancelBlackoutLiveChannel.waitUntilVisibleAndClick();
        BTN_ACCEPT_CANCEL_BLACKOUT_CHANNEL.waitUntilVisibleAndClick();
    }

    public void clickChannelList() {
        log.info("Click channel list");
        BTN_PLAYER.waitUntilVisible();
        BTN_PLAYER.waitFor(3);
        BTN_PLAYER.hoverOn();
        BTN_CHANNEL_LIST.waitUntilVisibleAndClick();
    }

    protected void waitPlayerLoadingToDisappear() {
        try {
            int retryCount = 10;
            while (LBL_PLAYER_LOADING.isDisplayed() && retryCount >0){
                retryCount -=1;
                LBL_PLAYER_LOADING.waitFor(1);
            }
        } catch (TimeoutException e) {
            log.error(e.getMessage());
        }
    }

    public void selectChannel(String channelName, Boolean isBuyPackageFlow) {
        JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
        log.info("Select Channel");
        waitPlayerLoadingToDisappear();
        clickChannelList();
        TXT_CHANNEL_SEARCH.waitUntilVisibleAndType(channelName);
        BeinButton BTN_Channel = new BeinButton(PageElementModel.selectorNames.XPATH, "(//span[text()='" + channelName + "']//..)[1]");
        BTN_Channel.waitUntilVisible();
        BTN_Channel.click();
        if (!isBuyPackageFlow) {
            BTN_TvPlayer.waitUntilVisible();
            BeinLabel LBL_ChannelHeader = new BeinLabel(PageElementModel.selectorNames.XPATH, "//span[contains(@class,'bmpui-ui-labe') and text()='" + channelName + "']");
            waitPlayerLoadingToDisappear();
            BTN_TvPlayer.waitFor(2);
            WebElement BTN_PLAYER_PLAY_PAUSEJW = Driver.webDriver.findElement(By.id("bmpui-id-81"));
            js.executeScript("arguments[0].click();", BTN_PLAYER_PLAY_PAUSEJW);
            LBL_ChannelHeader.waitUntilVisible();
            js.executeScript("arguments[0].click();", BTN_PLAYER_PLAY_PAUSEJW);
        } else {
            BTN_BuyPackage.waitUntilVisibleAndClick();
        }
    }

    public void selectChannelBuyPackageOtt(String channelName) {
        BeinButton BTN_Channel = new BeinButton(PageElementModel.selectorNames.XPATH, "//a[@data-title='" + channelName + "']/child::div");
        BTN_Channel.waitUntilVisible();
        //  waitLoadingToDisappear();
        BTN_Channel.waitFor(2);
        BTN_Channel.click();
        BTN_Channel.waitFor(5);

    }

    public void clickChannel(String channelName, Boolean isBuyPackageFlow) {
        log.info("Select Channel");
        waitPlayerLoadingToDisappear();
        clickChannelList();
        TXT_CHANNEL_SEARCH.waitUntilVisibleAndType(channelName);
        BeinButton BTN_Channel = new BeinButton(PageElementModel.selectorNames.XPATH, "(//span[text()='" + channelName + "']//..)[1]");
        BTN_Channel.waitUntilVisible();
        BTN_Channel.click();

    }

    public void watchChannel() {
        log.info("ENTERING watchChannel");
        BTN_TvPlayer.waitUntilVisible();
        int retry = 10;
        while (!BTN_PlayerToggleOn.isDisplayed() && --retry > 0) {
            BTN_TvPlayer.hoverOn();
            BTN_TvPlayer.waitFor(3);
            log.info(retry);
        }
        BTN_TvPlayer.hoverOn();
        BTN_PlayerToggleOn.click();
        BTN_PlayerToggleOn.waitFor(4);
        BTN_TvPlayer.hoverOn();
        BTN_PlayerToggleOff.click();
        BTN_PlayerToggleOff.waitFor(4);
        BTN_TvPlayer.hoverOn();
        if(BTN_FULL_SCREEN.isDisplayed()){
            log.info("from full screen to small screen");
            BTN_FULL_SCREEN.click();
        }
    }

    public void  watchPPV()  {
        log.info("ENTERING watchChannel");
        BTN_PPVPlayer.waitUntilVisible();
        JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
        WebElement ELEMENT3 = Driver.webDriver.findElement(By.id("bitmovinplayer-video-playerLiveTvBitmovin"));
        js.executeScript("arguments[0].scrollIntoView();", ELEMENT3);
        log.info("ELEMENT 3 SCROOL EDİLDİ VE PLAYER ORTALANDI.");
        int retry = 10;
        while (!BTN_PlayerToggleOn.isDisplayed() && --retry > 0) {
            BTN_PPVPlayer.hoverOn();
            BTN_PPVPlayer.waitFor(2);
            log.info(retry);
        }
        BTN_PPVPlayer.waitFor(5);
        WebElement PAUSEBUTTON = Driver.webDriver.findElement(By.xpath("//button[@class='bmpui-ui-playbacktogglebutton bmpui-on']"));
        js.executeScript("arguments[0].click();", PAUSEBUTTON);
        BTN_PlayerToggleOn.waitFor(4);
        BTN_PPVPlayer.hoverOn();
        BTN_PlayerToggleOff.click();
        BTN_PlayerToggleOff.waitFor(4);
        BTN_PPVPlayer.hoverOn();

    }

    public void watchContent() {
        log.info("ENTERING watchContent");
        BTN_ContentPlayer.waitUntilVisible();
        int retry = 30;
        while (!BTN_PlayerToggleOn.isDisplayed() && --retry > 0) {
            BTN_ContentPlayer.hoverOn();
            BTN_ContentPlayer.waitFor(1);
            log.info(retry);
        }
        BTN_PlayerToggleOn.click();
        BTN_PlayerToggleOn.waitFor(12);
        BTN_PlayerToggleOff.click();
        BTN_PlayerToggleOff.waitFor(12);
        BTN_ContentPlayer.hoverOn();
    }

    public void watchContentWithTime(Integer time) {
        log.info("ENTERING watchContent");
        BTN_ContentPlayer.waitUntilVisible();
        int retry = 30;
        while (!BTN_PlayerToggleOn.isDisplayed() && --retry > 0) {
            BTN_ContentPlayer.hoverOn();
            BTN_ContentPlayer.waitFor(1);
            log.info(retry);
        }
        BTN_PlayerToggleOn.click();
        BTN_PlayerToggleOn.waitFor(2);
        BTN_PlayerToggleOff.click();
        BTN_PlayerToggleOff.waitFor(time);
        BTN_ContentPlayer.hoverOn();

    }

    public void webServiceLogin(String client) {
        try {
            log.info("Soap get login service");
            DtSystemUserSoap systemUserSoap = DTSoapConnection.getInstance().getLoginSystemToken(client);
            DTSoapConnection.getInstance().getLoginService(client, systemUserSoap);
        } catch (Exception e) {
            log.error("COLUD NOT LOGIN SOAP");
            throw new AutomationException("COULD NOT LOGIN SOAP, SOAP MESSAGE: " + e.getMessage());
        }
    }

    public void webServicePlay(String client) {
        log.info("Web service play request");
        try {
            log.info("Soap get play service");
            DtSystemUserSoap systemUserSoap = DTSoapConnection.getInstance().getPlaySystemToken(client);
            DTSoapConnection.getInstance().getPlay(systemUserSoap);
        } catch (Exception e) {
            log.error("COULD NOT PLAY SOAP");
            throw new AutomationException("COULD NOT PLAY SOAP, SOAP MESSAGE: " + e.getMessage());
        }
    }

    public void typeSmsCode() {
        log.info("ENTERING typeSmsCode");
        TXT_SmsCode.waitUntilVisible();
        TXT_SmsCode.type(DBQueryUtil.getInstance().getSmsCodeByAccountNumber(DtAutomationContext.getUser().getDbsAccountNumber()));
    }

    public void clickConfirmSms() {
        log.info("ENTERING clickConfirmSms");
        BTN_SmsConfirm.click();
        DtAutomationContext.getUser().setValid(false);
        RestUserService.getInstance().putUser();
    }

    public void checkWatchingData() {
        LBL_CONTENT_HEADER.waitFor(10);
        BTN_PlayerToggleOn.waitUntilInvisible();
        BTN_ContentPlayer.hoverOn();
        BTN_PLAYER_CLOSE.waitUntilVisibleAndClick();

        int watchTime = parseInt(LBL_WATCH_TIME.getLabelText());
        log.info("Watched time: " + watchTime);
        if (watchTime > 9) {
            log.info("Watched time is wrong: " + watchTime);
            throw new AutomationException("Watched time wrong: " + LBL_WATCH_TIME.getLabelText());
        }
        log.info("Content header: " + LBL_CONTENT_HEADER.getLabelText());

    }

    public void checkWatchedEpisodeDetail() {
        log.info("Check watched Episode detail page ");

        LBL_CONTENT_HEADER.waitFor(10);
        BTN_PlayerToggleOn.waitUntilInvisible();
        BTN_ContentPlayer.hoverOn();
        BTN_PLAYER_CLOSE.waitUntilVisibleAndClick();
        String watchedTime = LBL_EPISODE_WATCHED.getLabelText();
        log.info("Watched time: " + watchedTime);
        if (!watchedTime.contains("dk izlediniz")) {
            log.info("Watched time is wrong: " + watchedTime);
            throw new AutomationException("Watched time wrong: " + LBL_EPISODE_WATCHED.getLabelText());
        }

    }

    public void checkBroadcastStream() {
        BTN_PLAYER.hoverOn();
        BTN_Broadcast_Icon.waitUntilVisibleAndClick();
        LBL_Broadcast.waitUntilVisible();
        String broadcastStream = LBL_Broadcast.getLabelText();
        if (broadcastStream.isEmpty()) {
            log.error("DONT HAVE BROADCAST STREAM");
            throw new AutomationException("DONT HAVE BROADCAST STREAM");
        }
        log.info("broadcast stream: " + broadcastStream );
    }

}

=end