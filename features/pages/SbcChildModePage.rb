=begin
package com.dt.standalone.pages;


import com.dt.standalone.backend.AutomationException;
import com.dt.standalone.backend.ContextKeys;
import com.dt.standalone.backend.DtAutomationContext;
import com.dt.standalone.pageElement.*;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class SbcChildModePage extends SbcMasterPage {

    private static final Log log = LogFactory.getLog(SbcChildModePage.class);
    private static SbcChildModePage instance;
    private static BeinTextBox TXT_PASSWORD = new BeinTextBox(PageElementModel.selectorNames.ID, "password");
    private static BeinButton BTN_LOGIN = new BeinButton(PageElementModel.selectorNames.ID, "cm-btn-check-pwd");
    private static BeinButton BTN_UPDATE_AGE = new BeinButton(PageElementModel.selectorNames.ID, "cm-btn-update-age");
    private static BeinButton BTN_SAVE_PIN = new BeinButton(PageElementModel.selectorNames.ID, "cm-btn-save-setup");
    private static BeinButton BTN_GO_CHILD_ROOM = new BeinButton(PageElementModel.selectorNames.XPATH, "//a[text()='ÇOCUK ODASINA GİR']");
    private static BeinLabel LBL_PIN_SUCCES_TEXT = new BeinLabel(PageElementModel.selectorNames.XPATH, "(//div[@class='cm-header']//h1[@class='cm-title'])[3]");
    private static BeinButton BTN_LIST_MENU_CHILD_ROOM = new BeinButton(PageElementModel.selectorNames.XPATH,"(//div[@class='bc-user-nav-desktop']//button)[2]");
    private static BeinButton BTN_CHILD_ROOM_SETTING = new BeinButton(PageElementModel.selectorNames.XPATH,"//ul[@id='bc-nav-user-desktop']//a[@data-item-title='Çocuk Odası Ayarları']");
    private static BeinButton BTN_LOGOUT_CHILD_ROOM = new BeinButton(PageElementModel.selectorNames.XPATH,"//ul[@id='bc-nav-user-desktop']//a[@data-item-title='Çocuk Odasından Çık']");
    private  static BeinButton BTN_CHANGE_AGE = new BeinButton(PageElementModel.selectorNames.ID,"cm-link-pin-prompt");
    private static BeinButton BTN_CHANGE_AGE_SAVE = new BeinButton(PageElementModel.selectorNames.ID,"cm-btn-save-settings");
    private static BeinLabel  LBL_CHANGE_AGE_MESSAGE = new BeinLabel(PageElementModel.selectorNames.XPATH,"//div[@class='bc-inline-alert bc-inline-success']");
    private static BeinButton BTN_EXIT_CHILD_MODE = new BeinButton(PageElementModel.selectorNames.ID,"cm-btn-exit");
    private static BeinButton BTN_GO_TO_CHANGE_PIN = new BeinButton(PageElementModel.selectorNames.XPATH,"//a[@title='Yeni Ebeveyn Kodu Tanımla']");
    private static BeinButton BTN_UPDATE_PIN_SAVE = new BeinButton(PageElementModel.selectorNames.ID,"cm-btn-update-pin");
    private static BeinLabel LBL_UPDATE_PIN_MESSAGE = new BeinLabel(PageElementModel.selectorNames.XPATH,"//div[@class='bc-inline-alert bc-inline-success']");
    private static BeinButton BTN_FORGOT_PARENT_CODE = new BeinButton(PageElementModel.selectorNames.XPATH,"//a[@href='/cocukodasi/ebeveynkodu']");

    public static synchronized SbcChildModePage getInstance() {
        if (instance == null)
            instance = new SbcChildModePage();
        return instance;
    }

    public void enterLoginPassword() {
        log.info("Enter login password");
        TXT_PASSWORD.waitUntilVisibleAndType(DtAutomationContext.getUser().getPassword());
    }

    public void clickToEnterPassword() {
        log.info("CLick to login child mode");
        BTN_LOGIN.waitUntilVisibleAndClick();
    }

    public void clickToAge(String age) {
        log.info("Select age");
        DtAutomationContext.addContext(ContextKeys.AGE,age);
        BeinCheckBox RDB_AGE = new BeinCheckBox(PageElementModel.selectorNames.XPATH, "//input[@id='age-"+age+"']");

        RDB_AGE.waitFor(5);
        RDB_AGE.check();
    }

    public void clickToUpdateAge() {
        log.info("Click update age");
        BTN_UPDATE_AGE.waitUntilVisibleAndClick();

    }

    public void enterChildPin() {
        log.info("EnterChildPin");
        String pinCode = "";
        for (int i = 1; i < 5; i++) {
            BeinTextBox TXT_PIN = new BeinTextBox(PageElementModel.selectorNames.XPATH, "//div[@class='cm-pin-inputs']//input[" + i + "]");

            TXT_PIN.waitUntilVisibleAndType(String.valueOf(i));
            pinCode = pinCode + i;
        }
        DtAutomationContext.addContext(ContextKeys.CHILD_PIN, pinCode);

    }

    public void saveChildPin() {
        BTN_SAVE_PIN.waitUntilVisibleAndClick();
    }

    public void verifySaveChildRoom(String verifyMessage) {
        log.info("Check save pin sucess message ");
        BTN_GO_CHILD_ROOM.waitUntilVisible();
        LBL_PIN_SUCCES_TEXT.waitFor(10);
        String message = LBL_PIN_SUCCES_TEXT.getLabelText();
        if (!message.contains(verifyMessage)) {
            String error = "DONT VERIFY SAVE PIN SUCCESS expected: " + verifyMessage + " label text: " + message;
            log.info(error);
            throw new AutomationException(error);
        }
    }

    public void goToChildRoom() {
        log.info("Go to child room on success page");
        BTN_GO_CHILD_ROOM.waitUntilVisibleAndClick();
    }

    public void hoverChildMenu() {
       log.info("Hover on child room list");
       BTN_LOGOUT_CHILD_ROOM.waitFor(4);
        BTN_LIST_MENU_CHILD_ROOM.waitUntilVisible();
        BTN_LIST_MENU_CHILD_ROOM.click();
    }

    public void  goToChildRoomSetting(){
        log.info("Go to childroom setting");
        BTN_CHILD_ROOM_SETTING.waitUntilVisibleAndClick();
    }

    public void logoutChildRoom(){
        log.info("Logout childroom");
        BTN_LOGOUT_CHILD_ROOM.waitUntilVisibleAndClick();
    }

    public void goToChangeAgeSetting(){
        BTN_CHANGE_AGE.waitUntilVisibleAndClick();
    }

    public void verifyUpdateAge(String verifyMessage){
        LBL_CHANGE_AGE_MESSAGE.waitUntilInvisible();
        String message = LBL_CHANGE_AGE_MESSAGE.getLabelText();
        if(!message.contains(verifyMessage)){
            String error = "DONT CHANGE AGE EXPECTED: "+verifyMessage +"LABEL TEXT: "+message;
            log.info(error);
            throw  new AutomationException(error);
        }
    }



    public void exitChildModePin(){
           BTN_EXIT_CHILD_MODE.waitUntilVisibleAndClick();
           BTN_EXIT_CHILD_MODE.waitFor(5);

    }

    public void goToChangePinCode(){
        log.info("Go to change pin");
        BTN_GO_TO_CHANGE_PIN.waitUntilVisibleAndClick();
    }

    public void updatePinCode(){
            log.info("EnterChildPin update");
            String pinCode = "";
            for (int i = 1; i < 5; i++) {
                BeinTextBox TXT_PIN = new BeinTextBox(PageElementModel.selectorNames.XPATH, "//div[@class='cm-pin-inputs']//input[" + i + "]");

                TXT_PIN.waitUntilVisibleAndType(String.valueOf(i+1));
                pinCode = pinCode + i+1;
            }
            DtAutomationContext.addContext(ContextKeys.CHILD_PIN, pinCode);
    }

    public void updatePinSave(){
        log.info("Update pin save");
        BTN_UPDATE_PIN_SAVE.waitUntilVisibleAndClick();
    }

    public void updatePinVeriyfMessage(String message){
        log.info("Update pin verify message" +message);
        LBL_PIN_SUCCES_TEXT.waitFor(5);
        BeinLabel LBL_PIN_SUCCESS_TEXT2 = new BeinLabel(PageElementModel.selectorNames.XPATH,"//div[text()='"+message+"']");
        LBL_PIN_SUCCESS_TEXT2.getLabelText();

    }

    public void updateAge(){
        BTN_CHANGE_AGE.waitUntilVisibleAndClick();
    }

    public void saveUpdateAge(){
        BTN_CHANGE_AGE_SAVE.waitUntilVisibleAndClick();
    }

    public void verifySaveAgeMessage(String message){
        BeinLabel LBL_AGE_VERIFY = new BeinLabel(PageElementModel.selectorNames.XPATH,"//div[text()='"+message+"']");
        LBL_AGE_VERIFY.waitFor(3);
        log.info("Verify message: "+ LBL_AGE_VERIFY.getLabelText());
    }

    public void verifUpdateAge(){
        LBL_PIN_SUCCES_TEXT.pageReflesh();
        BeinCheckBox CHX_AGE = new BeinCheckBox(PageElementModel.selectorNames.XPATH,"//input[@checked and @value='"+DtAutomationContext.getContextValue(ContextKeys.AGE)+"']") ;
        CHX_AGE.waitUntilInvisible();
    }

    public void clickForgotParentCode(){
        BTN_FORGOT_PARENT_CODE.waitUntilVisibleAndClick();
    }




}

=end