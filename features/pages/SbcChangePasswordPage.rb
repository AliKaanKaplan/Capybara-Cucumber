# package com.dt.standalone.pages;
#
# import com.dt.standalone.backend.AutomationException;
# import com.dt.standalone.backend.ContextKeys;
# import com.dt.standalone.backend.DtAutomationContext;
# import com.dt.standalone.pageElement.BeinButton;
# import com.dt.standalone.pageElement.BeinLabel;
# import com.dt.standalone.pageElement.BeinTextBox;
# import com.dt.standalone.pageElement.PageElementModel;
# import com.dt.standalone.utils.WebService.RestUserService;
# import org.apache.commons.logging.Log;
# import org.apache.commons.logging.LogFactory;
#
# public class SbcChangePasswordPage extends SbcMasterPage {
#     private static final Log log = LogFactory.getLog(SbcContentPage.class);
#     private static SbcChangePasswordPage instance;
#     private static BeinTextBox TXT_PASSWORD = new BeinTextBox(PageElementModel.selectorNames.NAME,"password");
#     private static BeinTextBox TXT_NEW_PASSWORD = new BeinTextBox(PageElementModel.selectorNames.XPATH,"(//input[@name='passwordnew'])[1]");
#     private static BeinTextBox TXT_NEW_PASSWORD_AGAIN = new BeinTextBox(PageElementModel.selectorNames.XPATH,"//input[@name='passwordnewre']");
#     private static BeinButton  BTN_CHANGE_PASSWORD = new BeinButton(PageElementModel.selectorNames.XPATH,"//input[@type='submit']");
#
#     public static synchronized SbcChangePasswordPage getInstance() {
#         if (instance == null)
#             instance = new SbcChangePasswordPage();
#         return instance;
#     }
#
#     public void enterPassword(String type){
#         String password ="";
#         if(type.equals("valid")) {
#             password = DtAutomationContext.getContextValue(ContextKeys.PASSWORD);
#         }
#         log.info("Enter password: " + password);
#         TXT_PASSWORD.waitUntilVisibleAndType(password);
#     }
#
#     public void enterNewPassword(String type){
#         String newPassword ="";
#         if(type.equals("valid")) {
#             newPassword = DtAutomationContext.getUser().getRandomPassword();
#             DtAutomationContext.addContext(ContextKeys.PASSWORD, newPassword);
#             DtAutomationContext.getUser().setPassword(newPassword);
#
#         }
#         log.info("New password: " +newPassword);
#         TXT_NEW_PASSWORD.waitUntilVisibleAndType(newPassword);
#
#     }
#
#     public void enterAgainNewPassword(String type){
#         String newPassword ="";
#         if(type.equals("valid")) {
#             newPassword = DtAutomationContext.getUser().getPassword();
#         }
#
#         TXT_NEW_PASSWORD_AGAIN.waitUntilVisibleAndType(newPassword);
#     }
#
#     public void clickToChangePassword(){
#         log.info("Click to change password");
#         BTN_CHANGE_PASSWORD.waitUntilVisibleAndClick();
#     }
#
#     public void checkChangePasswordMessage(String message){
#         log.info("Check change password message: " + message);
#         BeinLabel LBL_PASSWORD_SUCCESS_MESAJ = new BeinLabel(PageElementModel.selectorNames.XPATH,"//section[@class='success-section']//p[contains(text(), ' "+message+"')]");
#         LBL_PASSWORD_SUCCESS_MESAJ.waitFor(3);
#
#         if (LBL_PASSWORD_SUCCESS_MESAJ.isDisplayed()) {
#             DtAutomationContext.getUser().setPassword(DtAutomationContext.getContextValue(ContextKeys.PASSWORD));
#             DtAutomationContext.getUser().setPreviousPassword(DtAutomationContext.getUser().getPassword());
#             RestUserService.getInstance().putUser();
#
#         } else {
#             log.info("DON'T CHANGE PASSWORD MESSAGE: " + message);
#             throw new AutomationException("DON'T CHANGE PASSWORD MESSAGE: " + message);
#         }
#
#
#
#
#     }
#
#
#
#
# }