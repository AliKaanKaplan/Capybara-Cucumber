=begin
package com.dt.standalone.pages;

import com.amazonaws.services.dynamodbv2.document.Page;
import com.dt.standalone.backend.AutomationException;
import com.dt.standalone.backend.ContextKeys;
import com.dt.standalone.backend.DtAutomationContext;
import com.dt.standalone.model.CreditCard;
import com.dt.standalone.model.DbQueryRequest;
import com.dt.standalone.pageElement.*;
import com.dt.standalone.utils.WebService.RestUserService;
import com.dt.standalone.utils.dbquery.DBQueryUtil;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class SbcPackagesPage extends SbcMasterPage {
    private static final Log log = LogFactory.getLog(SbcPackagesPage.class);
    private static  String error;
    public static SbcPackagesPage instance;

    private static BeinButton BTN_PACKAGE_OPERATION = new BeinButton(PageElementModel.selectorNames.ID, "dropdown-detail-package-cancel2");
    private static BeinButton BTN_PAYMENT_INFO = new BeinButton(PageElementModel.selectorNames.CLASS_NAME, "update-pay-info");
    private static BeinButton BTN_UPDATE_PAYMENT_INFO = new BeinButton(PageElementModel.selectorNames.XPATH, "//div[contains(@class, 'update-credit-card-component')]//a");
    private static BeinTextBox TXT_CREDIT_CARD = new BeinTextBox(PageElementModel.selectorNames.XPATH, "//input[contains(@class,'credit-card-number')]");
    private static BeinSelect SLCT_CARD_MONTH = new BeinSelect(PageElementModel.selectorNames.XPATH, "//select[contains(@class,'credit-card-month')]");
    private static BeinSelect SLCT_CARD_YEAR = new BeinSelect(PageElementModel.selectorNames.XPATH, "//select[contains(@class,'credit-card-year')]");
    private static BeinTextBox TXT_CVV = new BeinTextBox(PageElementModel.selectorNames.XPATH, "//input[contains(@class,'credit-card-cvv')]");
    private static BeinButton BTN_CREDIT_CARD_SAVE = new BeinButton(PageElementModel.selectorNames.XPATH, "//div[contains(@class,'credit-card-update')]//a");
    private static BeinButton BTN_CancelRecurring = new BeinButton(PageElementModel.selectorNames.CLASS_NAME, "renovation-cancel");
    private static BeinButton BTN_Revoke = new BeinButton(PageElementModel.selectorNames.XPATH, "//a[contains(text(),'YENİLEMEYİ BA')]");
    private static BeinButton BTN_ConfirmRevoke = new BeinButton(PageElementModel.selectorNames.XPATH, "//a[text()='YENİLEMEYİ ONAYLA']");
    private static BeinSelect SEL_ReasonCode = new BeinSelect(PageElementModel.selectorNames.XPATH, "//select[contains(@class,'reason-code-select')]");
    private static BeinButton BTN_CANCEL_PACKAGE = new BeinButton(PageElementModel.selectorNames.XPATH,"//a[text()='PAKETİ İPTAL ET']");
    private static BeinTextBox TXT_CANCEL_DESCRIPTION = new BeinTextBox(PageElementModel.selectorNames.XPATH,"//textarea[contains(@class,'form-control reason-description required')]");
    private static BeinButton BTN_OtherOffers = new BeinButton(PageElementModel.selectorNames.XPATH, "//div[@class='package-detail'][1]");
    private static BeinLabel LBL_FREE_TRIAL_GIFT_PACKAGE_NAME = new BeinLabel(PageElementModel.selectorNames.XPATH,"//div[@class='package-detail' and contains(text(),'30 gün boyunca hediye 4. Ekran')]");
    private static BeinButton  BTN_ALL_PACKAGES = new BeinButton(PageElementModel.selectorNames.XPATH,"//a[text()='TÜM PAKETLERİ İNCELE']");
    private static BeinLabel LBL_PACKAGE_START_TIME = new BeinLabel(PageElementModel.selectorNames.XPATH,"((//ul[@class='info-list'])[1]//li)[1]//span[@class='value']//b");
    private static BeinLabel LBL_PACKAGE_END_TIME = new BeinLabel(PageElementModel.selectorNames.XPATH,"((//ul[@class='info-list'])[1]//li)[2]//span[@class='value']//b");
    public static synchronized SbcPackagesPage getInstance() {
        if (instance == null)
            instance = new SbcPackagesPage();
        return instance;
    }

    public void clickPackageOperation() {
        log.info("Click package operation");
        BTN_PACKAGE_OPERATION.waitUntilVisibleAndClick();
    }

    public void clickToPaymentInfo() {
        log.info("CLICK TO PAYMENT INFO");
        BTN_PAYMENT_INFO.waitFor(2);
        BTN_PAYMENT_INFO.waitUntilVisibleAndClick();
    }

    public void clickToUpdateCreditCardInformation() {
        log.info("Click to update credit card information ");
        BTN_UPDATE_PAYMENT_INFO.waitUntilVisibleAndClick();
    }



    public void enterCreditCardAndSave() {
        log.info("Enter Credit Card" + DtAutomationContext.getCreditCard().getCardNumber() + "Bank Code " + DtAutomationContext.getCreditCard().getBankName());
        TXT_CREDIT_CARD.waitUntilVisibleAndType(DtAutomationContext.getCreditCard().getCardNumber());
        SLCT_CARD_MONTH.selectByText(DtAutomationContext.getCreditCard().getExpireMonth());
        SLCT_CARD_YEAR.selectByText(DtAutomationContext.getCreditCard().getExprireYear());
        TXT_CVV.waitUntilVisibleAndType(DtAutomationContext.getCreditCard().getCvc());
        BTN_CREDIT_CARD_SAVE.click();
    }

    public void verifyExpectedMessage(String message) {
        BeinLabel LBL_CreditMessage = new BeinLabel(PageElementModel.selectorNames.XPATH, "//*[contains(text(),'" + message + "')]");
        LBL_CreditMessage.waitUntilVisible();
    }

    public void checkCancelMonthlySubscription(){
        BTN_CancelRecurring.waitFor(3);
/*        Integer betweenMonth = DBQueryUtil.getInstance().checkCancelPackage();
        if(betweenMonth !=1){
            error = "Dont working Cancel package ";
            log.error(error);
            throw new AutomationException(error);
        }*/


    }



    public void clickToCancelRecuring() {
        log.info("ENTERING clickToCancelRecuring");
        BTN_CancelRecurring.waitUntilVisibleAndClick();
    }

    public void clickRevoke() {
        log.info("ENTERING clickRevoke");
        BTN_Revoke.waitUntilVisibleAndClick();
    }

    public void selectReasonCode(String code) {
        log.info("ENTERING selectReasonCode");
        SEL_ReasonCode.waitFor(3);
        SEL_ReasonCode.selectByText(code);

    }

    public void clickToCancelPackage(){
        BTN_CANCEL_PACKAGE.waitUntilVisibleAndClick();
    }

    public void enterReasonDescription(){
        log.info("Enter reason description");
        TXT_CANCEL_DESCRIPTION.waitUntilVisibleAndType("Test automation reason code");
    }

    public void notShowToPackageOperation(){
        BTN_OtherOffers.waitUntilVisible();
        if(BTN_PACKAGE_OPERATION.isDisplayed()){
            throw new AutomationException("Show The Cancellation of NON-Renewable Products");
        }
    }

    public void confirmRevoke(){
        BTN_ConfirmRevoke.waitUntilVisibleAndClick();
    }

    public void verifyGiftFourScreen(){
       log.info("Verify free trial gift package four screen");
        BTN_ALL_PACKAGES.waitUntilVisible();
       if(!LBL_FREE_TRIAL_GIFT_PACKAGE_NAME.isDisplayed()){
           error = "NOT FOUND FREE TRIAL 4 SCREEN GIFT";
           log.error(error);
           throw new AutomationException(error);
       }
    }

    public void verifyPackageDate(){
        BTN_ALL_PACKAGES.waitUntilVisible();
        String startTime= LBL_PACKAGE_START_TIME.getLabelText();
        String endTime =LBL_PACKAGE_END_TIME.getLabelText();
        String endTimeCal;
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("dd.MMM.yyyy", Locale.US);
        String startTimeCal = sdf.format(cal.getTime());
        if(DtAutomationContext.getOffer().getShortCode().contains("O1A")){
            cal.add(Calendar.MONTH,+1);
        }
        if(DtAutomationContext.getOffer().getShortCode().contains("SZN")){
            cal.add(Calendar.MONTH,5);
            cal.add(Calendar.DAY_OF_MONTH,31);
            cal.add(Calendar.YEAR,+1);
        }
        endTimeCal = sdf.format(cal.getTime());
        if(!startTime.contains(startTimeCal)){
            error = "Package start time wrong: "+ startTime +"Expected: "+startTimeCal;
            log.error(error);
            throw new AutomationException(error);
        }
        if(!endTime.contains(endTimeCal)){
            error = "Package end time wrong: "+ endTime +"Expected: "+endTimeCal;
            log.error(error);
            throw new AutomationException(error);
        }



    }
}

=end