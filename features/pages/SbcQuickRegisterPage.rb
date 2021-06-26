=begin
package com.dt.standalone.pages;

import com.dt.standalone.backend.AutomationException;
import com.dt.standalone.backend.DtAutomationContext;
import com.dt.standalone.model.User;
import com.dt.standalone.pageElement.BeinButton;
import com.dt.standalone.pageElement.BeinCheckBox;
import com.dt.standalone.pageElement.BeinTextBox;
import com.dt.standalone.pageElement.PageElementModel;
import com.dt.standalone.utils.WebService.RestUserService;
import com.dt.standalone.utils.dbquery.DBQueryUtil;
import com.dt.standalone.utils.dbquery.EmailAndPhoneNumberCreate;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.util.HashMap;
import java.util.Map;

public class SbcQuickRegisterPage extends SbcMasterPage {
    private static final Log log = LogFactory.getLog(SbcQuickRegisterPage.class);
    private static SbcQuickRegisterPage instance;
    private static BeinTextBox TXT_FIRST_NAME = new BeinTextBox(PageElementModel.selectorNames.NAME,"FirstName");
    private static BeinTextBox TXT_LAST_NAME = new BeinTextBox(PageElementModel.selectorNames.NAME,"LastName");
    private static BeinTextBox TXT_EMAIL = new BeinTextBox(PageElementModel.selectorNames.NAME,"Email");
    private static BeinTextBox TXT_PHONE = new BeinTextBox(PageElementModel.selectorNames.NAME,"PhoneNumber");
    private static BeinButton  BTN_GET_PASSWORD = new BeinButton(PageElementModel.selectorNames.ID,"quickRegisterBtn");
    private static BeinTextBox TXT_SMS_CODE = new BeinTextBox(PageElementModel.selectorNames.NAME,"smsCode");
    private static BeinButton BTN_STEP = new BeinButton(PageElementModel.selectorNames.ID,"step2VerifyBtn");
    private static BeinTextBox TXT_PASSWORD =new BeinTextBox(PageElementModel.selectorNames.NAME,"Password");
    private static BeinButton BTN_QUICK_REGISTER = new BeinButton(PageElementModel.selectorNames.XPATH,"//input[@id='quickRegisterBtn' and contains(text(),'ÜYE OL')]");
    private static BeinButton BTN_BASKET = new BeinButton(PageElementModel.selectorNames.ID,"btnBasketOk");
    private static BeinCheckBox CHK_RegisterConfirm = new BeinCheckBox(PageElementModel.selectorNames.XPATH, "//input[@data-title='UYELIK_SOZLESME_IZNI']");
    private static BeinButton BTN_FreeTrialBuy = new BeinButton(PageElementModel.selectorNames.ID, "btnBuy");

    public static synchronized SbcQuickRegisterPage getInstance() {
        if (instance == null)
            instance = new SbcQuickRegisterPage();
        return instance;
    }

    public void fillToName(String fistname, String lastname, String indivual, String franchise){
        log.info("User name " + fistname + "Last name: " +lastname);
        TXT_FIRST_NAME.waitUntilVisibleAndType(fistname);
        TXT_LAST_NAME.waitUntilVisibleAndType(lastname);
        User user = new User();
        user.setName(fistname);
        user.setSurname(lastname);
        user.setRegisterType("quick");
        user.setUserType(indivual);
        user.setFrekans(franchise);
        user.setVerifyTckn(false);
        DtAutomationContext.setUser(user);
    }

    public void fillEmail(String email){
        String emailAddress ="";
        if(email.contains("valid")){
            emailAddress= EmailAndPhoneNumberCreate.getInstance().createRandomEmail();
        }
        else if(email.contains("register")){
            Map<String,String> queryParams = new HashMap<String,String>();
            queryParams.put("isEmailValid","true");
            queryParams.put("frekans","F01-BB-TR");
            emailAddress = RestUserService.getInstance().getUser(queryParams).getEmail();
        }
        log.info("Fill email adress" + emailAddress);
        TXT_EMAIL.waitUntilVisibleAndType(emailAddress);
        DtAutomationContext.getUser().setEmail(emailAddress);
    }

    public void fillPhoneNumber(String phoneType){
        String phone ="";
        if(phoneType.contains("valid")){
            phone=EmailAndPhoneNumberCreate.getInstance().createRandomPhone();
        }
        else if(phoneType.contains("registered")){
            Map<String,String> queryParams = new HashMap<String,String>();
            queryParams.put("frekans","F01-BB-TR");
            phone = RestUserService.getInstance().getUser(queryParams).getPhoneNumber();
            log.info(phone);
        }
        log.info("Fill phone number" + phone);
        TXT_PHONE.waitUntilVisibleAndType(phone);
        DtAutomationContext.getUser().setPhoneNumber(phone);
    }

    public void clickToGetPassword(){
        log.info("Click to get password");
        BTN_GET_PASSWORD.click();

    }
    public void enterSmsCode(String type){
        log.info("Enter sms code");
        TXT_SMS_CODE.waitUntilVisible();
        String code = DBQueryUtil.getInstance().getSmsCodeByPhoneNumberRegister(DtAutomationContext.getUser().getPhoneNumber().substring(3));
        if (code == null) {
            String error = "Sms code is null";
            log.error(error);
            throw new AutomationException(error);
        }
        TXT_SMS_CODE.waitUntilVisibleAndType(code);
    }

    public void goOnStep(){
        BTN_STEP.click();
    }

    public void enterPassword(String password){
        TXT_PASSWORD.waitUntilVisibleAndType(password);
        DtAutomationContext.getUser().setPassword(password);
    }

    public void clickQuickRegister(){
        log.info("ENTERING clickQuickRegister");
        CHK_RegisterConfirm.check();
        BTN_QUICK_REGISTER.waitFor(2);
        BTN_QUICK_REGISTER.click();
        CHK_RegisterConfirm.waitUntilInvisible();
    }

    public void validateQuickRegister(){
        DtAutomationContext.getUser().setLoginCredantial();
        BTN_BASKET.waitUntilVisible();
     //   RestUserService.getInstance().postCreateUser();
    }


    public void validateQuickRegisterNoPayment(){

        BTN_FreeTrialBuy.waitUntilVisible(25);

        RestUserService.getInstance().postCreateUser();
        DtAutomationContext.getUser().setLoginCredantial();
    }
}

=end