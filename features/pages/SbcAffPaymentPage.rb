=begin
package com.dt.standalone.pages;

import com.amazonaws.services.dynamodbv2.document.Page;
import com.dt.standalone.backend.AutomationException;
import com.dt.standalone.backend.ContextKeys;
import com.dt.standalone.backend.DtAutomationContext;
import com.dt.standalone.model.CreditCard;
import com.dt.standalone.pageElement.*;
import com.dt.standalone.utils.WebService.RestUserService;
import com.dt.standalone.utils.dbquery.DBQueryUtil;
import com.dt.standalone.utils.driver.Driver;

import com.thoughtworks.gauge.Step;
import javassist.compiler.Parser;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Point;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;

public class SbcAffPaymentPage extends SbcMasterPage {

    private static final Log log = LogFactory.getLog(SbcAffPaymentPage.class);
    private static SbcAffPaymentPage instance;

    private static BeinLabel LBL_PAGE_TITLE = new BeinLabel(PageElementModel.selectorNames.XPATH, "//h1[text()='Ödeme Bilgileri']");
    private static BeinTextBox TXT_CREDIT_CARD_NAME = new BeinTextBox(PageElementModel.selectorNames.XPATH, "" +
            "");
    private static BeinTextBox TXT_CARD_NUMBER = new BeinTextBox(PageElementModel.selectorNames.ID, "bc-input-cc-no");
    private static BeinTextBox TXT_DATE = new BeinTextBox(PageElementModel.selectorNames.ID, "bc-input-cc-exp");
    private static BeinTextBox TXT_CVV = new BeinTextBox(PageElementModel.selectorNames.ID, "bc-input-cc-cvv");
    private static BeinCheckBox CHX_SAVE_CREDIT_CARD = new BeinCheckBox(PageElementModel.selectorNames.ID, "bc-input-save-cc");
    private static BeinCheckBox CHX_ACCEPT_EULA = new BeinCheckBox(PageElementModel.selectorNames.ID, "bc-input-accept-eula");
    private static BeinLabel LBL_REQURING_MESSAGE = new BeinLabel(PageElementModel.selectorNames.XPATH, "//p[contains(text() ,'Aylık Yenilemeli Paket üyeliğini başlatırken herhangi bir taahhüt')]");
    private static BeinButton BTN_PAYMENT = new BeinButton(PageElementModel.selectorNames.ID, "bc-payment-submit-btn");
    private static BeinButton BTN_PAYMENT_SUCCESS_HOME = new BeinButton(PageElementModel.selectorNames.XPATH, "//section[@id='bc-sf-success-message']//a");
    private static BeinLabel LBL_SUCCESS_MESAGE = new BeinLabel(PageElementModel.selectorNames.XPATH, "//section[@id='bc-sf-success-message']//p");
    private static BeinTextBox TXT_ASSECO_PASSWORD = new BeinTextBox(PageElementModel.selectorNames.NAME, "password");
    private static BeinButton BTN_3D_SEND_VAKIF = new BeinButton(PageElementModel.selectorNames.ID, "submitbutton");
    private static BeinButton BTN_3D_SEND_ASSECO = new BeinButton(PageElementModel.selectorNames.ID, "submitbutton");
    private static BeinLabel LBL_PACKAGE_PRICE = new BeinLabel(PageElementModel.selectorNames.XPATH,"(//section[@id='bc-sf-payment-package']//div[@class='preview-body']//div//p)[2]");
    private static BeinLabel LBL_ALL_PRICE = new BeinLabel(PageElementModel.selectorNames.XPATH,"//section[@id='bc-sf-payment-package']//footer//div//strong");

    public static synchronized SbcAffPaymentPage getInstance() {
        if (instance == null)
            instance = new SbcAffPaymentPage();
        return instance;
    }

    public void checkPaymentPageTitle() {
        log.info("Check page title from Payment page");
        try {
            LBL_PAGE_TITLE.waitUntilVisible(60);
            log.info("Page title correct: Ödeme Bilgileri");
        } catch (AutomationException e) {
            log.warn("After signing up, the payment page title is not verified.");
            throw new AutomationException("After signing up, the payment page title is not verified.");
        }

    }

    public void chooseCreditCard(String bankName, String type) {
        log.info("Choose random credit card");
        CreditCard.getCreditCard(bankName, type);
    }

    public void fillOwnerName() {
        log.info("Enter credit car owner name: " + "Test Automation");
        JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
        js.executeScript("document.getElementById('bc-input-cc-name').value = 'Test Automation'");
    }

    public void fillCreditCardNumber() {
        log.info("Enter credit card number : " + DtAutomationContext.getCreditCard().getCardNumber());
        TXT_CARD_NUMBER.waitUntilVisibleAndType(DtAutomationContext.getCreditCard().getCardNumber());
    }

    public void fillCVV() {
        log.info("Enter credit card cvv : " + DtAutomationContext.getCreditCard().getCvc());
        TXT_CVV.type(DtAutomationContext.getCreditCard().getCvc());
    }

    public void fillExpireDate() {
        String expiryDate = DtAutomationContext.getCreditCard().getExpireMonth() + '/' + DtAutomationContext.getCreditCard().getExprireYear();
        log.info("Enter expiry date : " + expiryDate);
        TXT_DATE.type(expiryDate);
    }

    public void saveCreditCard() {
        log.info("Check save credit card");
        if (DtAutomationContext.getOffer().isRecurring) {
            CHX_SAVE_CREDIT_CARD.check();
        }

    }
    public void checkPackagePrice(){
        log.info("Check Package Price");
        LBL_PACKAGE_PRICE.waitUntilVisible();
        String price = LBL_PACKAGE_PRICE.getLabelText();
        if(!price.contains(DtAutomationContext.getOffer().getCurrentRate())){
            throw new AutomationException("Expected price: " + DtAutomationContext.getOffer().currentRate +" but show: " + price);
        }
    }
    public void checkAllPrice(){
        log.info("Check All Price");
        LBL_ALL_PRICE.waitUntilVisible();
        String price = LBL_ALL_PRICE.getLabelText();
        if(DtAutomationContext.getOffer().isTrial){
            if(!price.contains("0,00 TL"))
                throw new AutomationException("Expected price: 0,00 TL but show: " + price);
        }
        else if (!price.contains(DtAutomationContext.getOffer().getCurrentRate())){
            throw new AutomationException("Expected price: " + DtAutomationContext.getOffer().currentRate +" but show: " + price);
        }

    }

    public void checkEula() {
        log.info("Check eula ");
        CHX_ACCEPT_EULA.check();
    }

    public void choosePaymentMethodMonthly() {
        JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
        log.info("Choose Payment Method Monthly");
        if(!DtAutomationContext.getOffer().isTrial) {
            BeinLabel LBL_INSTALLMENT_TEXT = new BeinLabel(PageElementModel.selectorNames.XPATH, "//div[@data-bank='" + DtAutomationContext.getCreditCard().getBankName() + "']//div[@class='installment-label']//span");
            log.info("Aradığım: " + "//div[@data-bank='" + DtAutomationContext.getCreditCard().getBankName() + "']//div[@class='installment-label']//span");
            BeinCheckBox RD_REQURING_PAYMENT_METHOD = new BeinCheckBox(PageElementModel.selectorNames.XPATH, "//input[@data-type='CreditCardRecurring' and @data-parentbank='" + DtAutomationContext.getCreditCard().getBankName() + "']");
            RD_REQURING_PAYMENT_METHOD.waitUntilVisible();
            LBL_INSTALLMENT_TEXT.waitUntilVisible();
            String installmentText = LBL_INSTALLMENT_TEXT.getLabelText();
            if (!installmentText.contains("Aylık Yenilemeli")) throw new AutomationException("Installment text expected : Aylık Yenilemeli but show :" + installmentText);
            WebElement element3 = Driver.webDriver.findElement(By.xpath("//*[@id='bc-form-payment-cc']/div[5]/label/span[1]"));
            js.executeScript("arguments[0].scrollIntoView();", element3);
            js.executeScript("arguments[0].click();", element3);
            WebElement ELEMENT = Driver.webDriver.findElement(By.xpath("//input[@data-type='CreditCardRecurring' and @data-parentbank='"+ DtAutomationContext.getCreditCard().getBankName() +"']"));
            js.executeScript("arguments[0].scrollIntoView();", ELEMENT);
            js.executeScript("arguments[0].click();", ELEMENT);
            WebElement element2 = Driver.webDriver.findElement(By.xpath("//*[@id='bc-sf-user-aggreement']/div[1]/label/span[1]"));
            js.executeScript("arguments[0].scrollIntoView();", element2);
            js.executeScript("arguments[0].click();", element2);
            RD_REQURING_PAYMENT_METHOD.check();

        }
    }

    public void choosePaymentMethodInstallment() {
        JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
        log.info("Choose Payment Method Installment");
        BeinLabel LBL_INSTALLMENT_TEXT = new BeinLabel(PageElementModel.selectorNames.XPATH, "//div[@data-bank='" + DtAutomationContext.getCreditCard().getBankName() + "']//div[@class='installment-label']//span//i[contains(text(),'Taksit')]");
        BeinCheckBox RD_REQURING_PAYMENT_METHOD = new BeinCheckBox(PageElementModel.selectorNames.XPATH, "//input[@data-parentbank='"+DtAutomationContext.getCreditCard().getBankName()+"' and contains(@data-name , 'Taksit')]");
        RD_REQURING_PAYMENT_METHOD.waitUntilVisible();
        LBL_INSTALLMENT_TEXT.waitUntilVisible();
        String installmentText = LBL_INSTALLMENT_TEXT.getLabelText();
        if (!installmentText.contains("Taksit")) throw new AutomationException("Installment text expected : Taksitli but show :" + installmentText);
        WebElement ELEMENT = Driver.webDriver.findElement(By.xpath("//input[@data-parentbank='"+DtAutomationContext.getCreditCard().getBankName()+"' and contains(@data-name , 'Taksit')]"));
        js.executeScript("arguments[0].scrollIntoView();", ELEMENT);
        js.executeScript("arguments[0].click();", ELEMENT);
        WebElement element2 = Driver.webDriver.findElement(By.xpath("//span[@class='bc-custom-checkbox-mask']"));
        js.executeScript("arguments[0].scrollIntoView();", element2);
        js.executeScript("arguments[0].click();", element2);
       // RD_REQURING_PAYMENT_METHOD.check();

    }

    public void choosePaymentMethodFullPayment() {
        JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
        log.info("Choose Payment Method Installment");
        BeinLabel LBL_INSTALLMENT_TEXT = new BeinLabel(PageElementModel.selectorNames.XPATH, "//div[@data-bank='" + DtAutomationContext.getCreditCard().getBankName() + "']//div[@class='installment-label']//span[contains(text(),'Tek')]");
        BeinCheckBox RD_REQURING_PAYMENT_METHOD = new BeinCheckBox(PageElementModel.selectorNames.XPATH, "//input[@data-parentbank='"+DtAutomationContext.getCreditCard().getBankName()+"' and contains(@data-name , 'Tek')]");
        RD_REQURING_PAYMENT_METHOD.waitUntilVisible();
        LBL_INSTALLMENT_TEXT.waitUntilVisible();
        String installmentText = LBL_INSTALLMENT_TEXT.getLabelText();
        if (!installmentText.contains("Tek")) throw new AutomationException("Installment text expected : Tek Çekim but show :" + installmentText);
        WebElement ELEMENT = Driver.webDriver.findElement(By.xpath("//input[@data-parentbank='"+DtAutomationContext.getCreditCard().getBankName()+"' and contains(@data-name , 'Tek')]"));
        js.executeScript("arguments[0].scrollIntoView();", ELEMENT);
        js.executeScript("arguments[0].click();", ELEMENT);
        WebElement element2 = Driver.webDriver.findElement(By.xpath("//span[@class='bc-custom-checkbox-mask']"));
        js.executeScript("arguments[0].scrollIntoView();", element2);
        js.executeScript("arguments[0].click();", element2);
        RD_REQURING_PAYMENT_METHOD.check();
    }

    public void choosePaymentMethodInstallmentForTrial() {
        JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
        log.info("Choose Payment Method Free Trial");
        WebElement ELEMENT3 = Driver.webDriver.findElement(By.xpath("//*[@id='bc-form-payment-cc']/div[5]/label/span[1]"));
        js.executeScript("arguments[0].scrollIntoView();", ELEMENT3);
        js.executeScript("arguments[0].click();", ELEMENT3);
        WebElement element2 = Driver.webDriver.findElement(By.xpath("//*[@id='bc-sf-user-aggreement']/div[1]/label/span[1]"));
        js.executeScript("arguments[0].scrollIntoView();", element2);
        js.executeScript("arguments[0].click();", element2);
    }


    public void clickPayment() {
        JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
        log.info("Click to payment");
        BTN_PAYMENT.waitFor(2);
        WebElement PAY_ELEMENT3 = Driver.webDriver.findElement(By.id("bc-payment-submit-btn"));
        js.executeScript("arguments[0].scrollIntoView();", PAY_ELEMENT3);
        js.executeScript("arguments[0].click();", PAY_ELEMENT3);
    }

    public void checkPaymentOption() {
        BTN_PAYMENT.waitFor(15);
        Boolean switchData = DBQueryUtil.getInstance().checkPaymentSecureSwitch();
        String bankCode = DtAutomationContext.getCreditCard().getBankName();
        if (switchData) {
            if (DtAutomationContext.getOffer().getTrial()) {
                log.info("FREE TRIAL PACKAGE NOT 3D");
            } else if (bankCode.equals("YKB") || bankCode.equals("GBK")) {
                log.info("DONT HAVE 3D PAGE");
            } else if (bankCode.equals("VBK")) {
                enterVakifSecureCode();
                clickSendVakifSecureCode();
            } else {
                enterAssecoSecureCode();
                clickAssecoSendSecureCode();
            }
        } else {
            log.info("3D SWITCH CLOSE");
        }
    }

    public void controlRequringMessage() {
        if (DtAutomationContext.getOffer().getRecurring()) {
            if (!LBL_REQURING_MESSAGE.isDisplayed()) {
                throw new AutomationException("Requiring Credit Card message not found");
            }
        }
    }

    public void verifyPaymentSuccesPage() {
        BTN_PAYMENT_SUCCESS_HOME.waitUntilVisible();
        String message = LBL_SUCCESS_MESAGE.getLabelText();
        if (!message.contains("Keyifli seyirler dileriz")) {
            throw new AutomationException("Succes message wrong: " + message);
        }
    }

    public void verifyPaymentAmount() {
        if (!DtAutomationContext.getOffer().getTrial()) {
            log.info("Verify payment");
            log.info("Check APPLIED_BILLING_RATE");
            String userCurrentAccount = DBQueryUtil.getInstance().userCurrentAccount(DtAutomationContext.getUser().getDbsAccountNumber());
            log.info("Check APPLIED_BILLING_RATE table TAX_INCLUDED_AMOUNT: " + userCurrentAccount);
            if (!DtAutomationContext.getOffer().getCurrentRate().equals(userCurrentAccount)) {
                throw new AutomationException("TAX_INCLUDED_AMOUNT is  wrong: " + userCurrentAccount);
            }
        }
    }
    public void verifyPaymentAmountMultiple(){
        if (!DtAutomationContext.getOffer().getTrial()) {
            log.info("Verify payment");
            log.info("Check APPLIED_BILLING_RATE");
            String userCurrentAccount = DBQueryUtil.getInstance().userCurrentAccount(DtAutomationContext.getContextValue(ContextKeys.DBSACCOUNT));
            log.info("Check APPLIED_BILLING_RATE table TAX_INCLUDED_AMOUNT: " + userCurrentAccount);
            if (DtAutomationContext.getOffer().getCurrentRate().contains(userCurrentAccount)) {
                throw new AutomationException("TAX_INCLUDED_AMOUNT is  wrong: " + userCurrentAccount);
            }
        }
    }

    public void enterAssecoSecureCode() {
        log.info("Enter secure Code");
        TXT_ASSECO_PASSWORD.waitUntilVisibleAndType(DtAutomationContext.getCreditCard().getSecurePassword());
    }

    public void clickAssecoSendSecureCode() {
        log.info("Click send 3D secure code");
        BTN_3D_SEND_ASSECO.click();
    }

    public void enterVakifSecureCode() {
        BTN_3D_SEND_VAKIF.waitUntilVisible(3);
        log.info("Enter 3d password " + DtAutomationContext.getCreditCard().getSecurePassword());
        JavascriptExecutor jsx = (JavascriptExecutor) Driver.webDriver;
        jsx.executeScript("return document.getElementById('passwordfield').value ='" + DtAutomationContext.getCreditCard().getSecurePassword() + "'");
        // TXT_VAKIF_PASSWORD.waitUntilVisibleAndType(DtAutomationContext.getCreditCard().getSecurePassword());
    }

    public void clickSendVakifSecureCode() {
        BTN_3D_SEND_VAKIF.waitUntilVisibleAndClick(10);
    }

    public void deleteFreeTrialCreditCard(){
        log.info("Delete free trial card");
        DBQueryUtil.getInstance().deleteFreeTrialCreditCard();
    }

    public void checkPaymentSuccessPage(String message) {
        log.info("Ok success page");

            BeinLabel lblSuccessMesage = new BeinLabel(PageElementModel.selectorNames.XPATH, "//p[contains(text(), '" + message + "')] ");
            lblSuccessMesage.waitUntilVisible(50);

        RestUserService.getInstance().postCreateUser();

    }
    public void chooseRandomCreditCard(String bankName, String type) {
        log.info("Choose random credit card");
        CreditCard.getCreditCard(bankName, type);

    }

}
=end