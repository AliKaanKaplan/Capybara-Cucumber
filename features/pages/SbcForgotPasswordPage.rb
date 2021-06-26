=begin
package com.dt.standalone.pages;

import com.dt.standalone.backend.AutomationException;
import com.dt.standalone.backend.ContextKeys;
import com.dt.standalone.backend.DtAutomationContext;
import com.dt.standalone.pageElement.BeinButton;
import com.dt.standalone.pageElement.BeinLabel;
import com.dt.standalone.pageElement.BeinTextBox;
import com.dt.standalone.pageElement.PageElementModel;
import com.dt.standalone.pagesteps.SbcAppLauncher;
import com.dt.standalone.utils.WebService.RestUserService;
import com.dt.standalone.utils.dbquery.DBQueryUtil;
import com.dt.standalone.utils.dbquery.EmailAndPhoneNumberCreate;
import com.dt.standalone.utils.driver.Driver;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.util.Random;

public class SbcForgotPasswordPage extends SbcMasterPage {

    private static final Log log = LogFactory.getLog(SbcForgotPasswordPage.class);
    private static SbcForgotPasswordPage instance;

    private static BeinButton BTN_FORGOT_PASSWORD = new BeinButton(PageElementModel.selectorNames.XPATH, "//a[@href='/kullanici/sifremi-unuttum']");
    private static BeinTextBox TXT_PHONE_OR_EMAIL = new BeinTextBox(PageElementModel.selectorNames.ID, "phoneOrEmail");
    private static BeinButton BTN_CONTINUE = new BeinButton(PageElementModel.selectorNames.ID, "step1Btn");
    private static BeinTextBox TXT_SMSCODE = new BeinTextBox(PageElementModel.selectorNames.ID, "smsCode");
    private static BeinTextBox TXT_NEWPASSWORD = new BeinTextBox(PageElementModel.selectorNames.ID, "newPassword");
    private static BeinButton BTN_LOGIN = new BeinButton(PageElementModel.selectorNames.XPATH, "//a[@data-component-info='link']");
    private static BeinLabel LBL_VERIFY = new BeinLabel(PageElementModel.selectorNames.XPATH, "//div[@class='step screen-active']//h2");
    private static BeinButton BTN_FORGOT_PASSWORD_VERIFY = new BeinButton(PageElementModel.selectorNames.ID, "step2PhoneBtn");
    private static BeinButton BTN_FORGOT_PASSWORD_VERIFY_EMAIL = new BeinButton(PageElementModel.selectorNames.ID, "resetPassBtn");
    private static BeinLabel LBL_EMAIL_SEND = new BeinLabel(PageElementModel.selectorNames.XPATH, "//div[@id='form-step2-email']//h2");
    private static BeinLabel LBL_ERROR = new BeinLabel(PageElementModel.selectorNames.CLASS_NAME, "error-message");

    public static synchronized SbcForgotPasswordPage getInstance() {
        if (instance == null)
            instance = new SbcForgotPasswordPage();
        return instance;
    }

    public void clickToForgotPassword() {
        log.info("Click to forgot password");
        BTN_FORGOT_PASSWORD.waitUntilVisibleAndClick(1);
    }

    public void enterPhoneOrEmail(String phoneOrEmail) {
        String phoneOrEmailNumber ;
        TXT_PHONE_OR_EMAIL.waitUntilVisible();
        if(phoneOrEmail.equalsIgnoreCase("email"))
            phoneOrEmailNumber=DtAutomationContext.getUser().getEmail();
        else
            phoneOrEmailNumber=DtAutomationContext.getUser().getPhoneNumber();
        log.info("Forgot password Enter: " + phoneOrEmailNumber);
        TXT_PHONE_OR_EMAIL.type(phoneOrEmailNumber);
    }

    public void clickContinue() {
        log.info("Click to 'Devam Et' button");
        BTN_CONTINUE.waitUntilVisibleAndClick();
    }

    public void enterSmsCode() {
        log.info("Enter sms code");
        TXT_SMSCODE.waitUntilVisible(35);
        TXT_SMSCODE.waitFor(5);
        TXT_SMSCODE.type(DBQueryUtil.getInstance().getSmsCodeByPhoneForgotPassword(DtAutomationContext.getUser().getPhoneNumber()));
    }

    public void enterRandomPassword() {
        int randomNumber = (new Random()).nextInt(900) + 100;//generate random between 100-1000
        String newPassword = "Asd" + randomNumber;
        log.info("Enter password: " + newPassword);
        TXT_NEWPASSWORD.type(newPassword);
        DtAutomationContext.addContext(ContextKeys.PASSWORD, newPassword);
    }

    public void clickToChangePassword() {
        log.info("Click to change password");
        BTN_FORGOT_PASSWORD_VERIFY.click();
    }

    public void clickToChangePasswordEmail() {
        log.info("Click to change password with email");
        BTN_FORGOT_PASSWORD_VERIFY_EMAIL.waitUntilVisibleAndClick();
    }

    public void verifyForgotPasswordEmail(String verifyText) {
        log.info("Check forgot password verify page");
        BeinLabel LBL_VERIFY = new BeinLabel(PageElementModel.selectorNames.XPATH, "//h2[contains(text(),'"+verifyText+"')]");
        log.info("//div[contains(text(),'"+verifyText+"')]");
        LBL_VERIFY.waitUntilVisible();
        DtAutomationContext.getUser().setPreviousPassword(DtAutomationContext.getUser().getPassword());
        DtAutomationContext.getUser().setPassword(DtAutomationContext.getContextValue(ContextKeys.PASSWORD));
        RestUserService.getInstance().putUser();
    }

    public void verifyForgotPasswordPhoneNumber(String verifyText) {
        log.info("Check forgot password verify page");
        BeinLabel LBL_VERIFY = new BeinLabel(PageElementModel.selectorNames.XPATH, "(//h2[contains(text(),'"+verifyText+"')])[3]");
        LBL_VERIFY.waitUntilVisible();
        DtAutomationContext.getUser().setPreviousPassword(DtAutomationContext.getUser().getPassword());
        DtAutomationContext.getUser().setPassword(DtAutomationContext.getContextValue(ContextKeys.PASSWORD));
        RestUserService.getInstance().putUser();
    }

    public void clickLoginButton() {
        BTN_LOGIN.waitUntilVisibleAndClick();
    }


    public void goToForgotPasswordLink() {
        log.info("Go to forgot password link");
        LBL_EMAIL_SEND.waitUntilVisible();
        log.info(LBL_EMAIL_SEND.getLabelText());
        if (LBL_EMAIL_SEND.getLabelText().contains("sıfırlama linki e-posta adresinize(" + DtAutomationContext.getUser().getEmail() + ") ")) {
            LBL_EMAIL_SEND.waitFor(20);
            String emailLink = DBQueryUtil.getInstance().getEmailLinkForgotPassword(DtAutomationContext.getUser().getEmail(), SbcAppLauncher.APP_URL);
            if (emailLink != null && emailLink.contains("sifre-sifirla")) {
                Driver.webDriver.get(emailLink);
            } else {
                log.error("Email not sent");
                throw new AutomationException("Email link not send");
            }
        } else {
            log.error("Email not sent");
            throw new AutomationException("Email not send");
        }
    }

    public void findNotRegisterUser(String credantialType) {
        log.info("Find not registered" + credantialType);
        String credantial_value = DBQueryUtil.getInstance().findNotRegisterUser(credantialType);
        if (credantial_value != null) {
            DtAutomationContext.addContext(ContextKeys.LOGINUSER, credantial_value);
            log.info("Not registered credantial value: " + credantial_value);
        } else {
            throw new AutomationException("Not find not registered user");
        }
    }

    public void createRandomEmail() {
        log.info("Create random email");
        DtAutomationContext.addContext(ContextKeys.LOGINUSER, EmailAndPhoneNumberCreate.getInstance().createRandomEmail());
    }

    public void shownMessage(String message) {
        log.info("Check page message");
        LBL_ERROR.waitUntilVisible();
        if (!LBL_ERROR.getLabelText().contains(message)) {
            throw new AutomationException("Message is not valid page message: " + LBL_ERROR.getLabelText() + "expected: " + message);
        } else {
            log.info("Success page message " + LBL_ERROR.getLabelText());
        }
    }

    public void enterEmailOrPhone() {
        log.info("Enter invalid credantial " + DtAutomationContext.getContextValue(ContextKeys.LOGINUSER));
        TXT_PHONE_OR_EMAIL.type(DtAutomationContext.getContextValue(ContextKeys.LOGINUSER));
    }

}

=end