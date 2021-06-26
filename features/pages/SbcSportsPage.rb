# package com.dt.standalone.pages;
#
# import com.dt.standalone.backend.DtAutomationContext;
# import com.dt.standalone.pageElement.BeinButton;
# import com.dt.standalone.pageElement.BeinTextBox;
# import com.dt.standalone.pageElement.PageElementModel;
# import com.dt.standalone.utils.WebService.RestUserService;
# import com.dt.standalone.utils.dbquery.DBQueryUtil;
# import org.apache.commons.logging.Log;
# import org.apache.commons.logging.LogFactory;
#
# public class SbcSportsPage extends SbcMasterPage {
#     private static final Log log = LogFactory.getLog(SbcSportsPage.class);
#     private static SbcSportsPage instance;
#
#     private static BeinButton BTN_FirstMatch = new BeinButton(PageElementModel.selectorNames.XPATH, "(//div[contains(@class, 'match-of-weeks')])[1]");
#     private static BeinButton BTN_Watch = new BeinButton(PageElementModel.selectorNames.XPATH, "//button[text()='İZLE']");
#     private static BeinButton BTN_BUY = new BeinButton(PageElementModel.selectorNames.XPATH,"//div[@data-next-action='Offer']//button");
#     private static BeinButton BTN_BlackOutApprove = new BeinButton(PageElementModel.selectorNames.XPATH, "//button[text()='TV’DEKİ YAYINI KAPAT ve İZLE']");
#     private static BeinButton BTN_BlackOutApproveLiveContent = new BeinButton(PageElementModel.selectorNames.XPATH, "//span[text()='Uydudaki Yayını Kapat ve Buradan İzle']//..//..//button");
#     private static BeinButton BTN_WatchOptions = new BeinButton(PageElementModel.selectorNames.XPATH, "//button[text()='İZLEME SEÇENEKLERİ']");
#     private static BeinButton BTN_StepOne = new BeinButton(PageElementModel.selectorNames.CLASS_NAME, "step-one-click");
#     private static BeinTextBox TXT_SmsCode = new BeinTextBox(PageElementModel.selectorNames.XPATH, "(//input[@name='lname'])[1]");
#     private static BeinButton BTN_SmsConfirm = new BeinButton(PageElementModel.selectorNames.XPATH, "//a[contains(@class,'step-two-click')]");
#
#     public static synchronized SbcSportsPage getInstance() {
#         if (instance == null)
#             instance = new SbcSportsPage();
#         return instance;
#     }
#
#     public void clickFirstMatchAndPlay(){
#         log.info("ENTERING clickSingleMatch");
#         BTN_FirstMatch.waitUntilVisibleAndClick();
#         BTN_Watch.waitUntilVisibleAndClick();
#     }
#     public void clickFirstMatch(){
#         log.info("ENTERING clickSingleMatch");
#         BTN_FirstMatch.waitUntilVisibleAndClick();
#     }
#
#     public void clickFirstMatchAndClickBuy(){
#         log.info("ENTERING clickSingleMatch");
#         BTN_FirstMatch.waitUntilVisibleAndClick();
#         BTN_BUY.waitUntilVisibleAndClick();
#     }
#
#     public void clickFirstMatchAndWatchOptions(){
#         log.info("ENTERING clickFirstMatchAndWatchOptions");
#         BTN_FirstMatch.waitUntilVisibleAndClick();
#         BTN_WatchOptions.waitUntilVisibleAndClick();
#     }
#
#     public void clickFirstStep(){
#         log.info("ENTERING clickFirstStep");
#         BTN_StepOne.waitUntilVisibleAndClick();
#     }
#
#     public void typeSmsCode(){
#         log.info("ENTERING typeSmsCode");
#         TXT_SmsCode.waitUntilVisible();
#         TXT_SmsCode.waitFor(10);
#         TXT_SmsCode.type(DBQueryUtil.getInstance().getSmsCodeByAccountNumber(DtAutomationContext.getUser().getDbsAccountNumber()));
#     }
#
#     public void clickVerifyBlackout() {
#         log.info("ENTERING clickVerifyBlackout");
#         BTN_BlackOutApprove.waitUntilVisibleAndClick();
#     }
#
#     public void clickToVerifyBlackoutOnLiveChannel(){
#         log.info("Blackout activate");
#         BTN_BlackOutApproveLiveContent.waitUntilVisibleAndClick();
#     }
#
#     public void clickConfirmSms(){
#         log.info("ENTERING clickConfirmSms");
#        // waitLoadingToDisappear();
#         BTN_SmsConfirm.waitFor(5);
#         BTN_SmsConfirm.waitUntilVisibleAndClick();
#         DtAutomationContext.getUser().setValid(false);
#         RestUserService.getInstance().putUser();
#     }
# }
# =