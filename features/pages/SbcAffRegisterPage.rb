# package com.dt.standalone.pages;
# import com.dt.standalone.pagesteps.SbcAppLauncher;
# import com.dt.standalone.backend.AutomationException;
# import com.dt.standalone.backend.DtAutomationContext;
# import com.dt.standalone.model.User;
# import com.dt.standalone.pageElement.*;
# import com.dt.standalone.utils.WebService.RestUserService;
# import com.dt.standalone.utils.dbquery.DBQueryUtil;
# import com.dt.standalone.utils.driver.Driver;
# import org.apache.commons.logging.Log;
# import org.apache.commons.logging.LogFactory;
# import org.openqa.selenium.JavascriptExecutor;
#
# import java.util.HashMap;
# import java.util.Map;
#
# public class SbcAffRegisterPage extends SbcMasterPage {
#     private static final Log log = LogFactory.getLog(SbcAffRegisterPage.class);
#     private static String error;
#     private static SbcAffRegisterPage instance;
#
#     private static BeinButton BTN_SIGN_UP = new BeinButton(PageElementModel.selectorNames.XPATH, "/html/body/header/div/div[2]/a[1]");
#     private static BeinTextBox TXT_TCKN = new BeinTextBox(PageElementModel.selectorNames.ID, "bc-input-tckn");
#     private static BeinTextBox TXT_NAME = new BeinTextBox(PageElementModel.selectorNames.ID, "bc-input-firstname");
#     private static BeinTextBox TXT_SURNAME = new BeinTextBox(PageElementModel.selectorNames.ID, "bc-input-surname");
#     private static BeinTextBox TXT_BIRTDAY = new BeinTextBox(PageElementModel.selectorNames.ID, "bc-input-birthday");
#     private static BeinButton BTN_GO_ON_SMS_VALIDATION = new BeinButton(PageElementModel.selectorNames.ID, "bc-btn-register-submit");
#     private static BeinTextBox TXT_Email = new BeinTextBox(PageElementModel.selectorNames.ID, "bc-input-email");
#     private static BeinTextBox TXT_Phone = new BeinTextBox(PageElementModel.selectorNames.ID, "bc-input-phone");
#     private static BeinTextBox TXT_SMS_INPUT = new BeinTextBox(PageElementModel.selectorNames.ID, "bc-input-verification-code");
#     private static BeinLabel LBL_SMS_TIMER = new BeinLabel(PageElementModel.selectorNames.ID, "sms-timer-container");
#     private static BeinButton BTN_SMS_VERIFY = new BeinButton(PageElementModel.selectorNames.ID, "bc-btn-gsm-verification-submit");
#     private static BeinTextBox TXT_PASSWORD = new BeinTextBox(PageElementModel.selectorNames.ID, "bc-input-register-password");
#     private static BeinTextBox TXT_PASSWORD_REPEAT = new BeinTextBox(PageElementModel.selectorNames.ID, "bc-input-password-repeat");
#     private static BeinCheckBox CHECK_CONTACT_PERMISSION = new BeinCheckBox(PageElementModel.selectorNames.ID, "bc-input-permission-ILETISIM_IZNI");
#     private static BeinCheckBox CHECK_MEMBER_PERMISSION = new BeinCheckBox(PageElementModel.selectorNames.ID, "bc-input-permission-UYELIK_SOZLESME_IZNI");
#     private static BeinCheckBox CHECK_PROCESSING_ACCESS = new BeinCheckBox(PageElementModel.selectorNames.ID, "bc-input-permission-VERI_ISLEME_IZNI");
#     private static BeinButton BTN_REGISTER = new BeinButton(PageElementModel.selectorNames.ID, "bc-btn-permission-request-submit");
#     private static BeinLabel LBL_REGISTER_PHONE_ALERT = new BeinLabel(PageElementModel.selectorNames.XPATH, "//div[@class='bc-alert bc-form-alert bc-alert-danger']");
#     private static BeinLabel LBL_ERROR = new BeinLabel(PageElementModel.selectorNames.XPATH, "//div[@class='error-message']");
#     private static BeinLabel LBL_EmailValidMessage = new BeinLabel(PageElementModel.selectorNames.XPATH, "//div[@class='step screen-active']//h2");
#
#
#     public static synchronized SbcAffRegisterPage getInstance() {
#         if (instance == null)
#             instance = new SbcAffRegisterPage();
#         return instance;
#     }
#
#     public void goToSignUpPage() {
#         log.info("Click to Üye Ol button");
#         BTN_SIGN_UP.waitUntilVisibleAndClick();
#     }
#
#     public void fillTCKN() {
#         log.info("Fill TCKN textbox: " + DtAutomationContext.getUser().getTCKN());
#         TXT_TCKN.waitUntilVisibleAndType(DtAutomationContext.getUser().getTCKN());
#     }
#
#     public void fillName() {
#         log.info("Fill name textbox: " + DtAutomationContext.getUser().getName());
#         TXT_NAME.waitUntilVisibleAndType(DtAutomationContext.getUser().getName());
#     }
#
#     public void fillSurName() {
#         log.info("Fill lastName textbox: " + DtAutomationContext.getUser().getSurname());
#         TXT_SURNAME.waitUntilVisibleAndType(DtAutomationContext.getUser().getSurname());
#     }
#
#     public void fillBirthday() {
#         log.info("Fill birthday year: " + DtAutomationContext.getUser().getBirthYear());
#         TXT_BIRTDAY.waitUntilVisibleAndType(DtAutomationContext.getUser().getBirthYear());
#     }
#
#     public void fillPhoneNumber() {
#         String phoneNumber = DtAutomationContext.getUser().getPhoneNumber();
#         log.info("Fill phonenumber: " + phoneNumber);
#         JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
#         js.executeScript("document.getElementById('bc-input-phone').value= '(" + phoneNumber.substring(0, 3) + ") " + phoneNumber.substring(3, 6) + " " + phoneNumber.substring(6, 8) + " " + phoneNumber.substring(8, 10) + "'");
#     }
#
#     public void fillEmail() {
#         log.info("Fill email: " + DtAutomationContext.getUser().getEmail());
#         TXT_Email.waitUntilVisibleAndType(DtAutomationContext.getUser().getEmail());
#     }
#
#     public void fillRegisteredEmail() {
#         Map<String, String> queryParams = new HashMap<String,String>();
#         queryParams.put("isEmailValid", "true");
#         queryParams.put("frekans", "F01-ST-BB");
#         User user2 = RestUserService.getInstance().getUser(queryParams);
#         DtAutomationContext.getUser().setEmail(user2.getEmail());
#         log.info("Email adress: " + user2.getEmail());
#         TXT_Email.waitUntilVisibleAndType(DtAutomationContext.getUser().getEmail());
#     }
#
#     public void fillRegisteredPhoneNumber() {
#         Map<String, String> queryParams = new HashMap<String,String>();
#         queryParams.put("userType", "Quick Register Setup");
#         queryParams.put("frekans", "F01-BB-TR");
#         queryParams.put("isValid", "true");
#         User user2 = RestUserService.getInstance().getUser(queryParams);
#         DtAutomationContext.getUser().setPhoneNumber(user2.getPhoneNumber());
#         log.info("Phone Number: " + DtAutomationContext.getUser().getPhoneNumber());
#         fillPhoneNumber();
#     }
#
#     public void clickToSmsValidationPage() {
#         log.info("Click to go to sms validation page");
#         BTN_GO_ON_SMS_VALIDATION.waitUntilVisibleAndClick();
#     }
#
#     public void enterSmsCode() {
#         BTN_SMS_VERIFY.waitFor(10);
#         String  code = DBQueryUtil.getInstance().getSmsCodeByPhoneNumberRegister(DtAutomationContext.getUser().getPhoneNumber().substring(3));
#             if (code == null) {
#                 String error = "Sms code is null";
#                 log.error(error);
#                 throw new AutomationException(error);
#             }
#             log.info("Enter sms code: " + code);
#         TXT_SMS_INPUT.waitUntilVisibleAndType(code);
#     }
#
#     public void smsTimerVerify() {
#         LBL_SMS_TIMER.waitUntilInvisible();
#         String timer = LBL_SMS_TIMER.getLabelText();
#         log.info("Sms timer verify: " + timer);
#         log.info("split" + timer.split(":").equals(0));
#
#     }
#
#     public void clickToVerifySmsCode() {
#         log.info("Click Sms Veriy ");
#         BTN_SMS_VERIFY.waitUntilVisibleAndClick();
#     }
#
#     public void enterPassword() {
#         log.info("Enter Password: " + DtAutomationContext.getUser().getPassword());
#         TXT_PASSWORD.waitUntilVisibleAndType(DtAutomationContext.getUser().getPassword());
#
#     }
#
#     public void enterRepeatPassword() {
#         log.info("Enter Repeat Password: " + DtAutomationContext.getUser().getPassword());
#         TXT_PASSWORD_REPEAT.waitUntilVisibleAndType(DtAutomationContext.getUser().getPassword());
#     }
#
#     public void selectContactPermission() {
#         CHECK_CONTACT_PERMISSION.check();
#     }
#     public  void selectPermission(String type){
#         log.info("Check permission: " + type);
#         BeinCheckBox chxPermission = new BeinCheckBox(PageElementModel.selectorNames.XPATH,"//input[@data-permission-type='"+type+"']");
#         chxPermission.waitUntilVisible();
#         chxPermission.check();
#
#     }
#
#     public void selectMemberPermission() {
#         CHECK_MEMBER_PERMISSION.check();
#     }
#
#     public void selectProcessingAccess() {
#         CHECK_PROCESSING_ACCESS.check();
#     }
#
#     public void clickToRegister() {
#         BTN_REGISTER.waitUntilVisibleAndClick();
#         log.info("Click Regiter Button");
#     }
#
#     public void checkRegisteredPhoneAlert(String message) {
#         LBL_REGISTER_PHONE_ALERT.waitUntilVisible();
#         String pageText = LBL_REGISTER_PHONE_ALERT.getLabelText();
#         if (!pageText.contains(message)) {
#             throw new AutomationException("Registered Phone Alert Wrong: " + pageText);
#         }
#     }
#
#     public void verifyRegister() {
#         BTN_UserMenu.waitUntilVisible();
#     }
#
#     public void validateEmailAdress(){
#         log.info("Validate email address");
#         LBL_EmailValidMessage.waitFor(20);
#         String link = DBQueryUtil.getInstance().getEmailVerificationLink(DtAutomationContext.getUser().getEmail(), SbcAppLauncher.APP_URL);
#         log.info("VERIFY LINK: "+link);
#         Driver.webDriver.get(link);
#         if (!LBL_EmailValidMessage.getLabelText().contains("Mail adresin doğrulanmıştır.")) {
#             throw new AutomationException("Email address not validation page message :" + LBL_EmailValidMessage.getLabelText());
#         } else {
#             DtAutomationContext.getUser().setEmailValid(true);
#             // RestUserService.getInstance().putUser();
#         }
#     }
# }