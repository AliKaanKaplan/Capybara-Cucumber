=begin
package com.dt.standalone.pages;

import com.amazonaws.util.StringUtils;
import com.dt.standalone.backend.AutomationException;
import com.dt.standalone.backend.ContextKeys;
import com.dt.standalone.backend.DtAutomationContext;
import com.dt.standalone.model.User;
import com.dt.standalone.pageElement.BeinButton;
import com.dt.standalone.pageElement.BeinLabel;
import com.dt.standalone.pageElement.BeinTextBox;
import com.dt.standalone.pageElement.PageElementModel;
import com.dt.standalone.utils.WebService.RestPackageService;
import com.dt.standalone.utils.WebService.RestUserService;
import com.dt.standalone.utils.dbquery.DBQueryUtil;
import com.dt.standalone.utils.driver.Driver;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Point;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;

import java.util.HashMap;
import java.util.Map;

public class SbcAffLoginPage extends SbcMasterPage{
    private static final Log log = LogFactory.getLog(SbcAffLoginPage.class);
    private static SbcAffLoginPage instance;
    private static BeinButton BTN_HOME_LOGO  = new BeinButton(PageElementModel.selectorNames.XPATH,"//div[@class='aff-logo']//a");
    private static BeinButton BTN_SIGN_IN_WELCOME = new BeinButton(PageElementModel.selectorNames.XPATH,"(//a[@href='/kullanici/giris'])[1]");
    private static BeinButton BTN_SIGN_IN_HOME = new BeinButton(PageElementModel.selectorNames.ID,"bc-link-login");
    private static BeinTextBox TXT_USERNAME =new BeinTextBox(PageElementModel.selectorNames.ID,"bc-input-username");
    private static BeinTextBox TXT_PASSWORD = new BeinTextBox(PageElementModel.selectorNames.ID,"bc-input-password");
    private static BeinButton  BTN_LOGIN_SUBMIT =new BeinButton(PageElementModel.selectorNames.ID,"bc-btn-login-submit");
    private static BeinButton  BTN_FORGOT_PASSWORD = new BeinButton(PageElementModel.selectorNames.XPATH,"//a[@class='bc-link forgot-password']");
    private static BeinButton BTN_AFF_LOGO = new BeinButton(PageElementModel.selectorNames.XPATH,"//div[@class='aff-logo']//a");
    private static BeinLabel LBL_ERROR_MESSAGE = new BeinLabel(PageElementModel.selectorNames.XPATH, "//div[@class='error-message']");
    private static BeinButton HOVER  = new BeinButton(PageElementModel.selectorNames.XPATH,"");

    //*[contains(@text,'Digiturk bir beIN MEDIA GROUP')]
    public static synchronized SbcAffLoginPage getInstance() {
        if (instance == null)
            instance = new SbcAffLoginPage();
        return instance;
    }

    public void openLoginPageFromWelcomePage(){

        String url = Driver.webDriver.getCurrentUrl();
        if(url.contains("hosgeldiniz")){
            BTN_SIGN_IN_WELCOME.waitUntilVisibleAndClick();
        }else {
            BTN_SIGN_IN_HOME.waitUntilVisibleAndClick();
        }

    }

    public void openLoginPageFromHomePage(){
        BTN_HOME_LOGO.waitUntilVisibleAndClick();
        BTN_SIGN_IN_HOME.waitUntilVisibleAndClick();
    }

    public void getUser(String loginType, String userType){
        log.info("Find user type: " + userType);
        Map<String, String> queryParams = new HashMap<String,String>();
        queryParams.put("userType", userType);
        if (loginType.equalsIgnoreCase("email")){
            queryParams.put("isEmailValid", "true");
        }
        else{
            queryParams.put("isValid", "true");
        }
        queryParams.put("isFraud", "false");
        DtAutomationContext.setUser(RestUserService.getInstance().getUser(queryParams));
        DtAutomationContext.getUser().setLoginAccountCredential(loginType);
    }

    public void getUyduUser(String loginType, String userType){
        log.info("Find user type: " + userType);
        Map<String, String> queryParams = new HashMap<String,String>();
        queryParams.put("frekans", userType);
        if (loginType.equalsIgnoreCase("email")){
            queryParams.put("isEmailValid", "true");
        }
        else{
            queryParams.put("isValid", "true");
        }
        queryParams.put("isFraud", "false");
        DtAutomationContext.setUser(RestUserService.getInstance().getUser(queryParams));
        DtAutomationContext.getUser().setLoginAccountCredential(loginType);
    }

    public void enterUser(){
        TXT_USERNAME.waitFor(5);
        JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
        log.info("ENTERING enterUserLogin");
        WebElement element2 = Driver.webDriver.findElement(By.id("bc-input-username"));
        js.executeScript("arguments[0].scrollIntoView();", element2);
        js.executeScript("arguments[0].click();", element2);
        TXT_USERNAME.waitUntilVisible();
        if (!StringUtils.isNullOrEmpty(DtAutomationContext.getContextValue(ContextKeys.LOGINUSER))) {
            TXT_USERNAME.type(DtAutomationContext.getContextValue(ContextKeys.LOGINUSER));
            log.info("Login account: "+DtAutomationContext.getUser().getLoginAccount());
        } else {
            TXT_USERNAME.type(DtAutomationContext.getUser().getPhoneNumber());
            log.info("Login account: "+DtAutomationContext.getUser().getPhoneNumber());
        }
        log.info("Password: "+DtAutomationContext.getUser().getPassword());
        js.executeScript("document.getElementById('bc-input-password').click()");
        TXT_PASSWORD.type(DtAutomationContext.getUser().getPassword());
        DtAutomationContext.getUser().setLocked(true);
        if (DtAutomationContext.getUser().get_id() == null)
            RestUserService.getInstance().postCreateUser();
        else
            RestUserService.getInstance().putUser();
    }

    public void clickGoToLogin(){
        JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
        WebElement ELEMENT = Driver.webDriver.findElement(By.id("bc-btn-login-submit"));
        js.executeScript("arguments[0].scrollIntoView();", ELEMENT);
        BTN_LOGIN_SUBMIT.waitFor(5);
        BTN_LOGIN_SUBMIT.waitUntilVisibleAndClick();
    }

    public void findLoginUser(String loginType, String userType) {
        log.info("Find user type: " + userType);
        Map<String, String> queryParams = new HashMap<String,String>();
        queryParams.put("userType", userType);
        if (loginType.equalsIgnoreCase("email")){
            queryParams.put("isEmailValid", "true");
        }
        else{
            queryParams.put("isValid", "true");
        }
        queryParams.put("isFraud", "false");
        DtAutomationContext.setUser(RestUserService.getInstance().getUser(queryParams));
        DtAutomationContext.getUser().setLoginAccountCredential(loginType);

    }
    public void verifyLogin(){
        BTN_UserMenu.waitUntilVisible();
    }

    public void logout() {
        log.info("User logout");
        HOVER.scrollPageUp();
        if (BTN_GoTop.isDisplayed()) {
            BTN_GoTop.waitUntilClickable();
            BTN_GoTop.clickAndWait(5);
        }
        BTN_UserMenu.waitUntilVisible();
        BTN_UserMenu.click();
        BTN_UserMenu.waitFor(2);
        BTN_Logout.waitUntilVisibleAndClick();

        if (!Driver.webDriver.getCurrentUrl().contains("mac-basliyor")) {
            if (BTN_AFF_LOGO.isDisplayed())
                BTN_AFF_LOGO.waitUntilVisible();
        }
        if (DtAutomationContext.getUser().getFrekans().equals("F01-BB-TR")) {
            DtAutomationContext.getUser().setValid(false);
        }
    }
    public void getLoginUserPackageAndUserType(String packageType, String registerType) {
        if (packageType.equals("non-package")) {
            Map<String, String> queryParams = new HashMap<String,String>();
            queryParams.put("userPackage", null);
            queryParams.put("registerType", registerType);
            RestUserService.getInstance().getUser(queryParams);
        }
    }

    public void findUserRecuringPackage() {
        Map<String, String> queryParams = new HashMap<String,String>();
        queryParams.put("userPackage", "O1A_SPR_4E");
        queryParams.put("isValid", "true");
        DtAutomationContext.setUser(RestUserService.getInstance().getUser(queryParams));
    }

    public void findUserByType(String userType) {
        log.info("Find User findUserByType");
        Map<String, String> queryParams = new HashMap<String,String>();
        queryParams.put("userPackage", userType);
        queryParams.put("environment", System.getenv("ENVIRONMENT").toLowerCase());
        queryParams.put("isValid", "true");
        queryParams.put("isLocked", "false");
        if(!userType.contains("OTT"))
            queryParams.put("userType", "non-user");
        User user = RestUserService.getInstance().getUser(queryParams);
        user.setLocked(true);
        DtAutomationContext.setUser(user);
        RestUserService.getInstance().putUser();
        DtAutomationContext.addContext(ContextKeys.LOGINUSER, user.getDbsAccountNumber());
        DtAutomationContext.addContext(ContextKeys.PASSWORD, user.getPassword());
        log.info("Login user:" +DtAutomationContext.getContextValue(ContextKeys.LOGINUSER));
        if(DtAutomationContext.getUser().getFrekans().contains("F01-BB-TR")){
            Map<String,String> queryParamsOffer = new HashMap<String,String>();
            queryParams.put("shortCode", userType);
            queryParams.put("environment", System.getenv("ENVIRONMENT").toLowerCase());
            DtAutomationContext.setOffer(RestPackageService.getInstance().getPackage(queryParamsOffer));
        }

    }

    public void findUserByTypeOTT(String userType){
        log.info("Find User findUserByTypeOTT");
        Map<String, String> queryParams = new HashMap<String,String>();
        queryParams.put("userPackage", userType);
        queryParams.put("environment", System.getenv("ENVIRONMENT").toLowerCase());
        queryParams.put("isValid", "true");
        queryParams.put("isLocked", "false");
        queryParams.put("isFraud", "false");
        User user = RestUserService.getInstance().getUser(queryParams);
        user.setLocked(true);
        DtAutomationContext.setUser(user);
        RestUserService.getInstance().putUser();
        DtAutomationContext.addContext(ContextKeys.LOGINUSER, user.getDbsAccountNumber());
        DtAutomationContext.addContext(ContextKeys.PASSWORD, user.getPassword());
    }

    public void setUserNamePasswordAndLogin(String loginOption) {
        User user = DtAutomationContext.getUser();
        log.info("LOGGING IN WITH USER: " + user.getDbsAccountNumber() + " PHONE NUMBER: " + user.getPhoneNumber() + " PASSWORD: " + user.getPassword());
        TXT_USERNAME.waitUntilVisible();
        if (loginOption.equalsIgnoreCase("PHONE")) {
            TXT_USERNAME.type(user.getPhoneNumber());
            DtAutomationContext.addContext(ContextKeys.ACCOUNT, "PHONE: " + user.getPhoneNumber());
        } else if (loginOption.equalsIgnoreCase("ACCOUNT NUMBER")) {
            TXT_USERNAME.type(user.getAccountNumber());
            DtAutomationContext.addContext(ContextKeys.ACCOUNT, "ACCOUNT NUMBER: " + user.getAccountNumber());
        } else if (loginOption.equalsIgnoreCase("EMAIL")) {
            TXT_USERNAME.type(user.getEmail());
            DtAutomationContext.addContext(ContextKeys.ACCOUNT, "EMAIL: " + user.getEmail());
        } else {
            TXT_USERNAME.type(user.getPartyId());
            DtAutomationContext.addContext(ContextKeys.ACCOUNT, "DBS_ACCOUNT_NMBER: " + user.getDbsAccountNumber());
        }
        DtAutomationContext.addContext(ContextKeys.LOGINUSER, user.getDbsAccountNumber());
        log.info("Login user: " + DtAutomationContext.getContextValue(ContextKeys.ACCOUNT));
        TXT_PASSWORD.type(user.getPassword());
        BTN_LOGIN_SUBMIT.submit();
        BTN_LOGIN_SUBMIT.waitFor(15);
    }

    public void checkLoginFraudMessage(String message) {
        BeinLabel LBL_FRAUD_ERROR = new BeinLabel(PageElementModel.selectorNames.XPATH,"//div[contains(text(),'"+message+"')]");
        LBL_FRAUD_ERROR.waitFor(1);
        LBL_FRAUD_ERROR.waitUntilVisible();
        if (!LBL_FRAUD_ERROR.getLabelText().contains(message)) {
            throw new AutomationException("Fraud user login");
        }
        DBQueryUtil.getInstance().deleteFraud();
    }


}
=end