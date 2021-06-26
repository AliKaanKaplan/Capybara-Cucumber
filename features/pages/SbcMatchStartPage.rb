=begin
package com.dt.standalone.pages;

import com.amazonaws.services.dynamodbv2.document.Page;
import com.dt.standalone.backend.AutomationException;
import com.dt.standalone.backend.DtAutomationContext;
import com.dt.standalone.pageElement.BeinButton;
import com.dt.standalone.pageElement.BeinLabel;
import com.dt.standalone.pageElement.BeinTextBox;
import com.dt.standalone.pageElement.PageElementModel;
import com.dt.standalone.utils.WebService.RestUserService;
import com.dt.standalone.utils.dbquery.DBQueryUtil;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openqa.selenium.Keys;

public class SbcMatchStartPage extends SbcMasterPage {
    private static final Log log = LogFactory.getLog(SbcMatchStartPage.class);
    private static SbcMatchStartPage instance;

    public static synchronized SbcMatchStartPage getInstance() {
        if (instance == null)
            instance = new SbcMatchStartPage();
        return instance;
    }

    private static BeinTextBox TXT_USER_INFO = new BeinTextBox(PageElementModel.selectorNames.ID,"inlineFormInputName2");
    private static BeinTextBox TXT_PASSWORD = new BeinTextBox(PageElementModel.selectorNames.ID,"inlineFormInputGroupUsername2");
    private static BeinButton BTN_LOGIN = new BeinButton(PageElementModel.selectorNames.XPATH,"//*[text()='Giriş Yap']");
    private static BeinButton BTN_MATCH = new BeinButton(PageElementModel.selectorNames.XPATH,"(//div[@class='match__time'])[1]");
    private static BeinButton BTN_STARMATCH = new BeinButton(PageElementModel.selectorNames.XPATH,"//div[@class='col-md-4']");
    private  static BeinButton BTN_BLACKOUT_ACTIVATE = new BeinButton(PageElementModel.selectorNames.XPATH,"//button[text()='TV’DEKİ YAYINI KAPAT ve İZLE']");
    private static  BeinButton BTN_BLACKOUT_CANCEL = new BeinButton(PageElementModel.selectorNames.XPATH,"//a[text()='Uydu Yayınına Geri Dön ']");
    private static BeinButton BTN_PLAYER_ON = new BeinButton(PageElementModel.selectorNames.XPATH,"//button[@class='bmpui-ui-hugeplaybacktogglebutton bmpui-on']");
    private static BeinButton BTN_PLAYER_OFF = new BeinButton(PageElementModel.selectorNames.XPATH,"bmpui-ui-hugeplaybacktogglebutton bmpui-off");
    private static BeinButton BTN_CLOSE_PLAYER = new BeinButton(PageElementModel.selectorNames.XPATH,"//button[@class='close-modal']");
    private static BeinButton BTN_LOGOUT = new BeinButton(PageElementModel.selectorNames.XPATH,"//button[text()='Çıkış Yap']");
    private static BeinLabel LBL_CANCEL_MESSAGE = new BeinLabel(PageElementModel.selectorNames.XPATH,"//p[@class='cancel-blackout-info']");



    private static BeinLabel LBL_CLOSE_SCREEN_MESSAGE = new BeinLabel(PageElementModel.selectorNames.XPATH,"");



    public void enterUserLogin(){
        log.info("ENTERING enterUserLogin");
        TXT_USER_INFO.waitUntilVisible();
        log.info(DtAutomationContext.getUser().getLoginAccount());
        if (DtAutomationContext.getUser().getLoginAccount() == null) {
            TXT_USER_INFO.type(DtAutomationContext.getUser().getDbsAccountNumber());
            log.info(DtAutomationContext.getUser().getLoginAccount());
        } else {
            TXT_USER_INFO.type(DtAutomationContext.getUser().getPhoneNumber());
            log.info(DtAutomationContext.getUser().getPhoneNumber());
        }
        log.info(DtAutomationContext.getUser().getPassword());
        TXT_PASSWORD.type(DtAutomationContext.getUser().getPassword());
        DtAutomationContext.getUser().setLocked(true);
        if (DtAutomationContext.getUser().get_id() == null)
            RestUserService.getInstance().postCreateUser();
        else
            RestUserService.getInstance().putUser();
    }


    public void clickLogin(){
        log.info("Click login button");
        BTN_LOGIN.waitUntilVisibleAndClick();
       /* try {
            if(!DtAutomationContext.getUser().getFraud()){
                BTN_LOGOUT.waitUntilVisible(10);
            }

        }catch (AutomationException e){
            log.warn("Not Login");
            throw new AutomationException("Not login");
        }*/
    }

    public void clickMatch(){
        log.info("Click first match");
        BTN_MATCH.waitFor(5);
        BTN_MATCH.waitUntilVisibleAndClick(10);
    }

    public void clicStarkMatch(){
        log.info("Click first match");
        BTN_STARMATCH.waitFor(5);
        BTN_STARMATCH.waitUntilVisibleAndClick(10);
    }

    public void watchMatch(Integer watchTime){
        log.info("Watch Play");
        if(!DtAutomationContext.getUser().getFrekans().equals("F01-BB-TR")){
            BTN_BLACKOUT_ACTIVATE.waitFor(10);
            if(BTN_BLACKOUT_ACTIVATE.isDisplayed()){
                BTN_BLACKOUT_ACTIVATE.click();
            }
        }
        try{
            BTN_PLAYER_ON.waitUntilVisible(20);
         //   BTN_PLAYER_ON.click();
           // BTN_PLAYER_OFF.waitUntilVisible();
            //BTN_PLAYER_OFF.click();
            //BTN_PLAYER_ON.waitUntilVisible();
            BTN_PLAYER_ON.waitFor(watchTime);
        }catch (AutomationException e){
            throw new AutomationException("DON'T PLAY WHEN OPENED PLAYER");
        }
    }


    public void closePlayer(){
        log.info("Close player");
        BTN_CLOSE_PLAYER.waitUntilVisibleAndClick();
    }

    public void logout(){
        log.info("Logout");
        BTN_LOGOUT.waitUntilVisibleAndClick();
    }

    public void activateMatchStart(){
        log.info("Activate blackout");
        BTN_BLACKOUT_ACTIVATE.waitUntilVisibleAndClick();

    }

    public void cancelBlackoutMatchStart(){
        log.info("Cancel blackout match beginning");
        BTN_PLAYER_ON.waitUntilVisible();
        BTN_PLAYER_ON.hoverOn();
        BTN_BLACKOUT_CANCEL.waitUntilVisibleAndClick();
    }


      public void checkScreenMessageMatchStart(String message){
        log.info("Check cancel message");
        LBL_CANCEL_MESSAGE.waitUntilVisible();
        String cancelMessage = LBL_CANCEL_MESSAGE.getLabelText();
        if(!cancelMessage.equals(message)){
            throw new AutomationException("Cancel message wrong: "+ message);
        }
    }


    public void checkCancelMessageMatchStart(String message){
        log.info("Close player check message cancel blackout");
        BeinLabel LBL_BLACKOUT_MESSAGE = new BeinLabel(PageElementModel.selectorNames.XPATH,"//p[//text()='"+message+"']");
        try{
            LBL_BLACKOUT_MESSAGE.waitUntilVisible(999);
        }catch (AutomationException e){
            log.warn("Dont blackout cancel");
            throw new AutomationException("Dont blackout cancel");
        }

    }

    public void checkMultiplayFraudMessageMatchStart(String message){
        log.info("Close player check message: " + message);
        BeinLabel LBL_MULTIPLAY_MESSAGE = new BeinLabel(PageElementModel.selectorNames.XPATH,"//p[//text()='"+message+"']");
        try{
            LBL_MULTIPLAY_MESSAGE.waitUntilVisible(400);
        }catch (AutomationException e){
            log.warn("Dont multiplay");
            throw new AutomationException("Dont multiplay");
        }
    }

    public void checkLoginFraudMessage(String message){
        log.info("Not login fraud message");
        BeinLabel LBL_FRAUD_LOGIN_MESSAGE = new BeinLabel(PageElementModel.selectorNames.XPATH,"//h3[text()='"+message+"']");
        LBL_FRAUD_LOGIN_MESSAGE.waitUntilVisible();
        DBQueryUtil.getInstance().deleteFraud();
    }










}

=end

