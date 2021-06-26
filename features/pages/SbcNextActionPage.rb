=begin
package com.dt.standalone.pages;

import com.dt.standalone.backend.DtAutomationContext;
import com.dt.standalone.pageElement.*;
import com.dt.standalone.utils.driver.Driver;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openqa.selenium.JavascriptExecutor;

public class SbcNextActionPage extends SbcMasterPage {
    private static final Log log = LogFactory.getLog(SbcNextActionPage.class);
    private static SbcNextActionPage instance;

    public static synchronized SbcNextActionPage getInstance() {
        if (instance == null)
            instance = new SbcNextActionPage();
        return instance;
    }

    private static BeinButton  BTN_UPDATE_PERMISSION = new BeinButton(PageElementModel.selectorNames.XPATH,"//a[@href='/free-trial']");
    private static BeinButton   BTN_CONTINUE = new BeinButton(PageElementModel.selectorNames.ID,"bc-btn-free-trial-permissions-submit");
    private static BeinButton  BTN_SHOW_PACKAGES = new BeinButton(PageElementModel.selectorNames.XPATH,"//a[@class='freeTrial-footer__btn']");
    private static BeinTextBox  TXT_CITIZEN = new BeinTextBox(PageElementModel.selectorNames.NAME,"CitizenNumber");
    private static BeinTextBox  TXT_NAME = new BeinTextBox(PageElementModel.selectorNames.NAME,"FirstName");
    private static BeinTextBox  TXT_SURNAME = new BeinTextBox(PageElementModel.selectorNames.XPATH,"//*[@id='bc-input-surname']");
    private static BeinTextBox SLCT_BIRTH_YEAR = new BeinTextBox(PageElementModel.selectorNames.NAME, "BirthDate");
    private static BeinButton  BTN_ENTER = new BeinButton(PageElementModel.selectorNames.ID,"bc-btn-verify-tckn-submit");


    public void updateFreeTrialPermission(){
        log.info("Update free trial permission");
        BTN_UPDATE_PERMISSION.waitUntilVisibleAndClick();
    }
    public void checkPermission(String permission){

        BTN_CONTINUE.waitUntilVisible(20);
        BeinCheckBox CHX_PERMISSION = new BeinCheckBox(PageElementModel.selectorNames.XPATH,"//input[@data-permission-type='"+permission+"']");
        CHX_PERMISSION.check();

    }

    public void clickContinue(){
        BTN_CONTINUE.waitUntilVisibleAndClick();
        BTN_CONTINUE.waitFor(10);
    }

    public void enterTCKNInformation(){
        BTN_ENTER.waitFor(4);
        DtAutomationContext.getUser().setStandartUserData("valid");
        log.info("TCKN: "+ DtAutomationContext.getUser().getTCKN());
        TXT_NAME.waitUntilVisible();
        JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
        js.executeScript("document.getElementsByName('CitizenNumber')[0].value= '"+DtAutomationContext.getUser().getTCKN()+"'");
        TXT_NAME.clearText();
        TXT_NAME.type(DtAutomationContext.getUser().getName());
        TXT_SURNAME.clearText();
        TXT_SURNAME.type(DtAutomationContext.getUser().getSurname());
        SLCT_BIRTH_YEAR.type("01.01."+DtAutomationContext.getUser().getBirthYear());
        BTN_ENTER.waitUntilVisibleAndClick();
    }



}

=end