class SbcAccountPage
  def initialize
    super
     @BTN_PASSWORD_EDIT = "//div[@id='passwordPanel']//i[@class='fas fa-pen']"
     @TXT_OLD_PASSWORD =  "oldPassword"
     @TXT_NEW_PASSWORD =  "newPassword"
     @BTN_SAVE_PASSWORD =   "//div[@class='panel panel-edit screen-active']//input[@value='KAYDET']"
     @LBL_PASSWORD_SUCCESS_MESAJ =  "//*[@id='passwordPanel']/span"
     @LBL_NAME =   "lblFirstName"
     @LBL_SURNAME =   "lblLastName"
     @LBL_TC =   "lblCitizenNumber"
     @BTN_PhoneEdit =   "//div[@id='phonePanel']//a[contains(@class,'btn-edit')]"
     @BTN_EmailEdit =   "//div[@id='emailPanel']//a[contains(@class,'btn-edit')]"
     @TXT_Phone =   "phoneNumber"
     @TXT_Email =   "email" 
     @TXT_PhonePassword =  "//div[@id='phonePanel']//input[@type='password']"
     @TXT_EmailPassword =  "//div[@id='emailPanel']//input[@type='password']"
     @BTN_SaveEmail =   "//div[@id='emailPanel']//input[@value='KAYDET']"
     @TXT_SMS_CODE =   "smsCode"
     @BTN_SEND_PHONE_VERIFY = "btnSendVerifyCode"
     @BTN_SMS_CODE_CONTINUE =   "//input[@value='DEVAM ET']"
     @BTN_MY_PACKAGE =   "//a[@href='#packages']"
     @LBL_PHONE_EDIT_MESSAGE =  "//div[@id='phonePanel']//span[@class='panel-message']"
     @LBL_ERROR_MESSAGE =  "//div[@id='phonePanelStep2']//div[@class='error-message']"
     @BTN_INDIVIUAL_EDIT =   "//a[contains(@class,'ot-id')]"
     @TXT_CITIZEN =  "citizenNumber"
     @TXT_Name =   "name"
     @TXT_Surname =   "surname"
     @SLCT_BIRTH_YEAR = "birthYear"
     @BTN_INDIVIUAL_SAVE =   "//*[@value='KAYDET']"
     @LBL_INDIVIDUAL_MESSAGE =  "//div[@id='individualPanel']//span[@class='panel-message']"
     @LBL_CITIZIEN_ERROR_MESSAGE = "error-message"
     @LBL_REGISTERED_EMAIL_MESSAGE =  "//span[@id='emailNotVerifiedMessage']"
     @BTN_SHOW_UPGRADE_PACKAGE = "show-0"
     @BTN_BUY_UPGRADE_PACKAGE =  "(//a[@data-action-type='4'])[1]"
  end


end



=begin
package com.dt.standalone.pages;

import com.dt.standalone.backend.AutomationException;
import com.dt.standalone.backend.ContextKeys;
import com.dt.standalone.backend.DtAutomationContext;
import com.dt.standalone.pageElement.*;
import com.dt.standalone.utils.WebService.RestUserService;
import com.dt.standalone.utils.dbquery.DBQueryUtil;
import com.dt.standalone.utils.dbquery.EmailAndPhoneNumberCreate;
import com.dt.standalone.utils.driver.Driver;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebElement;

public class SbcAccountPage extends SbcMasterPage {

    private static final Log log = LogFactory.getLog(SbcAccountPage.class 
    private static SbcAccountPage instance;

 
    public static synchronized SbcAccountPage getInstance() {
        if (instance == null)
            instance = new SbcAccountPage( 
        return instance;
    }

    public void clickToEditPassword() {
        log.info("Go to click to edit password" 
        JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
        WebElement BTN_PASSWORD_EDITJW = Driver.webDriver.findElement(By.xpath("//div[@id='passwordPanel']//i[@class='fas fa-pen']") 
        js.executeScript("arguments[0].scrollIntoView( ", BTN_PASSWORD_EDITJW 
        BTN_PASSWORD_EDIT.waitFor(5 
        BTN_PASSWORD_EDIT.waitUntilVisibleAndClick( 
    }

    public void enterPassword(String type) {
        String password = DtAutomationContext.getUser().getPassword( 
        if (type.equals("invalid")) {
            password += "A";
        }
        TXT_OLD_PASSWORD.type(password 
        log.info("Old password is: " + password 
    }

    public void enterNewPassword() {
        String password = DtAutomationContext.getUser().getRandomPassword( 
        DtAutomationContext.addContext(ContextKeys.PASSWORD, password 
        DtAutomationContext.getUser().setPassword(password 
        TXT_NEW_PASSWORD.type(password 
        log.info("New password is: " + password 
    }

    public void clickToSavePassword() {
        log.info("Click to save" 

        BTN_SAVE_PASSWORD.waitUntilVisibleAndClick( 
    }

    public void validateSuccessMessagePassword(String message) {
        LBL_PASSWORD_SUCCESS_MESAJ.waitFor(3 
        String successMessage = LBL_PASSWORD_SUCCESS_MESAJ.getLabelText( 
        if (successMessage.equals(message)) {
            DtAutomationContext.getUser().setPassword(DtAutomationContext.getContextValue(ContextKeys.PASSWORD) 
            DtAutomationContext.getUser().setPreviousPassword(DtAutomationContext.getUser().getPassword() 
            RestUserService.getInstance().putUser( 

        } else {
            log.info("DON'T CHANGE PASSWORD MESSAGE: " + successMessage 
            throw new AutomationException("DON'T CHANGE PASSWORD MESSAGE: " + successMessage 
        }
        HOVER.scrollPageUp( 
        HOVER.scrollPageUp( 
    }

    public void getUserInformation() {
        LBL_NAME.waitUntilVisible( 
        String name = DtAutomationContext.getUser().getName( 
        String[] nameParts = name.split("" 
        String namePart = nameParts[0] + "*";
        log.info("Expected name: " +name 

        String surname = DtAutomationContext.getUser().getSurname( 
        String[] surnameParts = surname.split("" 
        String surnamePart = surnameParts[0] +  "*";
        log.info("Expected surname: " +surnamePart 

        String tc = DtAutomationContext.getUser().getTCKN( 
        String[] tcParts = tc.split("" 
        String tcPart = tcParts[0] +tcParts[1] + "*";


        if (!LBL_NAME.getLabelText().contains(namePart))
            throw new AutomationException("USER NAME WRONG: " + LBL_NAME.getLabelText() 
        else if (!LBL_SURNAME.getLabelText().contains(surnamePart))
            throw new AutomationException("USER SURNAME WRONG:  " + LBL_SURNAME.getLabelText() 
        else if (!LBL_TC.getLabelText().contains(tcPart))
            throw new AutomationException("USER TCKN WRONG:  " + LBL_TC.getLabelText() 
    }


    public void clickMyPackage() {
        log.info("Click My Package" 
        BTN_MY_PACKAGE.waitFor(20 
        BTN_MY_PACKAGE.pageReflesh( 
        BTN_MY_PACKAGE.waitUntilVisibleAndClick( 
    }

    public void checkPackageName(String packageName)
    {
        int tryCount=10;
        log.info("Package name: " +packageName 
      //  BeinLabel LBL_PACKAGE_NAME = "//div[contains(text(), '"+packageName+"') and @class='package-name']" 
    //    LBL_PACKAGE_NAME.waitUntilVisible( 
    }
    public void goToUpgradePackage(){
        log.info("Click to upgrade package" 
        int tryCount=10;
        while (tryCount>0){
            if(!BTN_SHOW_UPGRADE_PACKAGE.isDisplayed()){
                BTN_SHOW_UPGRADE_PACKAGE.pageReflesh( 
                BTN_MY_PACKAGE.waitUntilVisibleAndClick( 
                BTN_SHOW_UPGRADE_PACKAGE.waitFor(5 
                tryCount =tryCount-1;
            }else {
               // BTN_SHOW_UPGRADE_PACKAGE.waitUntilVisibleAndClick( 
                BTN_BUY_UPGRADE_PACKAGE.waitUntilVisibleAndClick( 
                break;
            }
        }



    }


    public void clickToEditPhoneNumber() {
        log.info("ENTERING clickToEditPhoneNumber" 
        JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
        WebElement BTN_PhoneEditJW = Driver.webDriver.findElement(By.xpath("//div[@id='phonePanel']//a[contains(@class,'btn-edit')]") 
        js.executeScript("arguments[0].scrollIntoView( ", BTN_PhoneEditJW 
        BTN_PhoneEdit.waitFor(5 
        BTN_PhoneEdit.waitUntilVisibleAndClick( 
    }

    public void clickToEditEmail() {
        log.info("ENTERING clickToEditEmail" 
        BTN_EmailEdit.waitUntilVisibleAndClick( 
    }

    public void enterPhoneNumber(String type) {
        String phoneNumber = "";
        if (type.equals("valid")) {
            phoneNumber = EmailAndPhoneNumberCreate.getInstance().createRandomPhone( 
        } else if (type.equals("registered")) {
            phoneNumber = EmailAndPhoneNumberCreate.getInstance().getRegisteredPhone( 
        }
        log.info("Change phone number " + phoneNumber 
        DtAutomationContext.getUser().setPhoneNumber(phoneNumber 
        TXT_Phone.clearText( 
        TXT_Phone.type(phoneNumber 
    }

    public void editEmail(boolean isValid) {
        log.info("ENTERING editEmail" 
        String email;
        if (isValid)
            email = EmailAndPhoneNumberCreate.getInstance().createRandomEmail( 
        else
            email = EmailAndPhoneNumberCreate.getInstance().getRegisteredEmail( 
        TXT_Email.waitUntilVisible( 
        TXT_Email.clearText( 
        TXT_Email.type(email 
        log.info("NEW EMAIL: " + email 
        DtAutomationContext.getUser().setEmail(email 
    }

    public void enterPasswordInPhoneNumberEditModal() {
        log.info("Enter password with Phone Number Modal" 
        TXT_PhonePassword.waitUntilVisibleAndType(DtAutomationContext.getUser().getPassword() 
    }

    public void enterPasswordEmailEdit() {
        log.info("ENTERING enterPasswordEmailEdit" 
        TXT_EmailPassword.waitUntilVisibleAndType(DtAutomationContext.getUser().getPassword() 
    }

    public void saveEmail() {
        log.info("ENTERING saveEmail" 
        BTN_SaveEmail.click( 
        DtAutomationContext.getUser().setEmailValid(false 
        RestUserService.getInstance().putUser( 
    }

    public void clickToSendVerifyCode() {
        BTN_SEND_PHONE_VERIFY.waitUntilVisibleAndClick( 
    }

    public void sendSmsVerificationCode() {
        BTN_SMS_CODE_CONTINUE.waitUntilVisibleAndClick( 
    }

    public void enterSmsCodeLoginCredantial() {
        log.info("ENTERING enterSmsCodeLoginCredantial" 
        TXT_SMS_CODE.waitUntilVisible( 
        TXT_SMS_CODE.waitFor(5 
        String smsCode = DBQueryUtil.getInstance().getSmsCodeByPhoneNumberRegister(DtAutomationContext.getUser().getPhoneNumber().substring(3) 
        TXT_SMS_CODE.waitUntilVisibleAndType(smsCode 
    }

    public void verifyChangePhoneMessage(String message) {
        LBL_PHONE_EDIT_MESSAGE.waitUntilVisible( 
        if (!LBL_PHONE_EDIT_MESSAGE.getLabelText().equals(message)) {
            throw new AutomationException("CHANGE PHONE NUMBER MESSAGE IS NOT CORRECT" 
        }
    }

    public void updateUserPhoneNumber() {
        log.info("Update user phone number" 
        RestUserService.getInstance().putUser( 

    }

    public void changePasswordErrorMessage(String message) {
        LBL_ERROR_MESSAGE.waitUntilVisible( 
        if (!LBL_ERROR_MESSAGE.getLabelText().equals(message)) {
            throw new AutomationException("Error message wrong: " + LBL_ERROR_MESSAGE.getLabelText() 
        }
    }

    public void clickToEditIndividualInformation() {
        BTN_INDIVIUAL_EDIT.waitUntilVisibleAndClick( 
    }


    public void enterUserIndividualData(String type) {
        DtAutomationContext.getUser().setStandartUserData(type 
        TXT_CITIZEN.waitUntilVisibleAndType(DtAutomationContext.getUser().getTCKN() 
        TXT_Name.clearText( 
        TXT_Name.type(DtAutomationContext.getUser().getName() 
        TXT_Surname.clearText( 
        TXT_Surname.type(DtAutomationContext.getUser().getSurname() 
        SLCT_BIRTH_YEAR.selectByText(DtAutomationContext.getUser().getBirthYear() 
    }


    public void clickToSaveCitizenshipNumber() {
        BTN_INDIVIUAL_SAVE.waitFor(2 
        BTN_INDIVIUAL_SAVE.waitUntilVisibleAndClick( 
    }


    public void verifyToSaveCitizenshipNumber() {
        LBL_INDIVIDUAL_MESSAGE.waitUntilVisible( 
        String successMessage = LBL_INDIVIDUAL_MESSAGE.getLabelText( 
        if (successMessage.equals("Kimlik bilgilerin başarılı bir şekilde güncellenmiştir.")) {
            log.info("Kimlik bilgilerin başarılı bir şekilde güncellenmiştir mesajı görülmüştür." 
        }
        else
        {
            log.error("DONT VERIFY Citizenship Number message: " + successMessage 
            throw new AutomationException("DONT EDIT Citizenship Number message: " + successMessage 
        }
       // DtAutomationContext.getUser().setTCKN(DBQueryUtil.getInstance().updateUserTCKN(DtAutomationContext.getUser().getTCKN()) 
        DtAutomationContext.getUser().setRegisterType("standart" 
        log.info(DtAutomationContext.getUser().getTCKN() 
        RestUserService.getInstance().putUser( 
    }

    public void showCitizenshipNumberErrorMessage(String message) {
        LBL_CITIZIEN_ERROR_MESSAGE.waitUntilVisible( 
        String errorMessage = LBL_CITIZIEN_ERROR_MESSAGE.getLabelText( 
        if (!message.equals(errorMessage)) {
            log.error("Eror message wrong: " + errorMessage 
            throw new AutomationException("Eror message wrong: " + errorMessage 
        }
    }

    public void verifyLogin() {
        log.info("CHECK USER DBS ACCOUNT NUMBER" 
        BeinLabel LBL_AccountNumber =  "//div[@id='profile']//span[text()='" + DtAutomationContext.getUser().getDbsAccountNumber() + "']" 
        LBL_AccountNumber.waitUntilVisible( 
    }


    public void checkRegisteredEmailMessage(String message) {
        log.info("EXPECTED MESSAGE: " + message 
        LBL_REGISTERED_EMAIL_MESSAGE.waitUntilVisible( 
        String emailMessage = LBL_REGISTERED_EMAIL_MESSAGE.getLabelText( 
        if (!message.equals(emailMessage)) {
            log.error("Page message: " + emailMessage 
            throw new AutomationException("Eror message wrong: " + emailMessage 
        }
    }

    public void updatePermission(String permission) {
        JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
        WebElement CHECK_PERMISSION = Driver.webDriver.findElement(By.xpath("(//label[text()='" + permission + "'])//..//..//ins") 
        js.executeScript("arguments[0].scrollIntoView( ", CHECK_PERMISSION 
        js.executeScript("arguments[0].click( ", CHECK_PERMISSION 
        BTN_INDIVIUAL_SAVE.waitFor(3 


    }

    public void checkPermission(String permission, Boolean checked) {
        JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
        BTN_INDIVIUAL_SAVE.waitFor(1 
        if (checked) {
            WebElement CHECKED_PERMISSION = Driver.webDriver.findElement(By.xpath("(//label[text()='" + permission + "'])//..//..//div[@class='icheckbox checked']") 
            js.executeScript("arguments[0].scrollIntoView( ", CHECKED_PERMISSION 
            BTN_INDIVIUAL_SAVE.waitFor(2 
            if (!CHECKED_PERMISSION.isDisplayed()) {
                error = "DONT UPDATE PERMISSION";
                log.error(error 
                throw new AutomationException(error 
            }
        } else {
            WebElement CHECK_PERMISSION =Driver.webDriver.findElement(By.xpath("(//label[text()='" + permission + "'])//..//..//div[@class='icheckbox']") 
            js.executeScript("arguments[0].scrollIntoView( ", CHECK_PERMISSION 
            if (!CHECK_PERMISSION.isDisplayed()) {
                error = "DONT UPDATE PERMISSION";
                log.error(error 
                throw new AutomationException(error 
            }


        }

    }
}
=end