class SbcAffBasketPage
    def initialize
        super
         @LBL_PACKAGE_NAME =  "//header//h3" 
         @LBL_OFFER_NAME =  "//header//h5" 
         @LBL_PRICE =  "(//div[@class='preview-body']/div//p)[2]" 
         @LBL_PAY_DATE_TEXT_BASKET =  "//div[text()='İlk Ödeme Tarihi']" 
         @LBL_AMOUNT_BASKET_BODY =  "((//div[@class='preview-body']//div[@class='preview-row'])[1]//p)[2]" 
         @LBL_PAY_DATE_BASKET_BODY =  "((//div[@class='preview-body']//div[@class='preview-row'])[2]//div)[2]" 
         @LBL_PAYING_RESULT =  "(//footer//div)[2]/strong" 
         @BTN_SKIP_SUGGESTED_BASKET =   "bc-btn-see-suggested-packages" 
         @BTN_SKIP_SUGGESTED_UPGRADE_BASKET =  "bc-btn-skip-suggested-packages" 
         @BTN_SKIP_SUGGESTED_BASKET_LAST =   "bc-btn-continue-with-selected-package-2" 
         @BTN_REMOVE_BASKET =   "//div[@class='remove-from-basket']//button" 
         @BTN_BASKET_SECTION =   "bc-sf-payment-package" 
         @BTN_ADD_PACKAGE =   "(//div[@id='bc-subview-package-suggestions']//a)[1]" 
         @LBL_MULTIPLE_PACKAGE = "//div[@class='bc-content']//header" 
        
    end



end



# package com.dt.standalone.pages;
#
# import com.amazonaws.services.config.model.PendingAggregationRequest;
# import com.amazonaws.services.dynamodbv2.document.Page;
# import com.dt.standalone.backend.AutomationException;
# import com.dt.standalone.backend.DtAutomationContext;
# import com.dt.standalone.pageElement.BeinButton;
# import com.dt.standalone.pageElement.BeinLabel;
# import com.dt.standalone.pageElement.PageElementModel;
# import com.dt.standalone.utils.driver.Driver;
# import org.apache.commons.logging.Log;
# import org.apache.commons.logging.LogFactory;
# import org.openqa.selenium.By;
# import org.openqa.selenium.JavascriptExecutor;
# import org.openqa.selenium.WebElement;
#
# import java.nio.charset.StandardCharsets;
#
# public class SbcAffBasketPage extends SbcMasterPage {
#
#     private static final Log log = LogFactory.getLog(SbcAffBasketPage.class
#     private static SbcAffBasketPage instance;
#
#     public static synchronized SbcAffBasketPage getInstance() {
#         if (instance == null)
#             instance = new SbcAffBasketPage(
#         return instance;
#     }
#
#     public void checkCatalogName() {
#         log.info("Check basket catalog name : " + DtAutomationContext.getOffer().getCategoryName()
#         BeinLabel LBL_CATALOG_NAME =  "//section[@class='bc-tab-list']//button[contains(text(),'" + DtAutomationContext.getOffer().getCategoryName() + "')]"
#         log.info("//header[@class='preview-header']//h3[contains(text(),'" + DtAutomationContext.getOffer().getCategoryName() + "')]"
#         try {
#             LBL_CATALOG_NAME.waitUntilInvisible(
#         } catch (AutomationException e) {
#             throw new AutomationException("Basket category name wrong "
#         }
#     }
#
#     public static void removePackageBasket() {
#         log.info("Remove package from basket"
#         BTN_REMOVE_BASKET.waitFor(2
#         JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
#         js.executeScript("document.getElementsByClassName('remove-from-basket')[0].children[0].click()"
#     }
#
#     public void checkPackageName() {
#         log.info("Check Basket package name : " + DtAutomationContext.getOffer().getPackageName()
#         LBL_PACKAGE_NAME.waitUntilVisible(
#         String packageName = LBL_PACKAGE_NAME.getLabelText(
#         if (!packageName.contains(DtAutomationContext.getOffer().getPackageName())) {
#             throw new AutomationException("Package Name : " + packageName + "expected : " + DtAutomationContext.getOffer().getPackageName()
#         }
#     }
#
#     public void checkOfferName() {
#         log.info("Check Basket offer name : " + DtAutomationContext.getOffer().getOfferName()
#         LBL_OFFER_NAME.waitUntilVisible(
#         String offerName = LBL_OFFER_NAME.getLabelText(
#         if (DtAutomationContext.getOffer().shortCode.contains("4E")) {
#             if (!offerName.contains("Smart TV") ){
#                 throw new AutomationException("Offer Name : " + offerName + "expected : " + DtAutomationContext.getOffer().getOfferName()
#             }
#         } else {
#             if (!offerName.contains(DtAutomationContext.getOffer().getOfferName())) {
#                 throw new AutomationException("Offer Name : " + offerName + "expected : " + DtAutomationContext.getOffer().getOfferName()
#             }
#         }
#     }
#
#     public static void checkBasketPrice() {
#         String price = LBL_PRICE.getLabelText(
#         log.info("Get price " + price
#         if (!price.contains(DtAutomationContext.getOffer().getCurrentRate())) {
#             throw new AutomationException("Price Name : " + price + "expected : " + DtAutomationContext.getOffer().getCurrentRate()
#         }
#     }
#
#     public void basketAllPrice() {
#         LBL_PAYING_RESULT.waitUntilVisible(
#         String price = LBL_PAYING_RESULT.getLabelText(
#         log.info("Get price " + price
#         if (!price.contains(DtAutomationContext.getOffer().getCurrentRate())) {
#             throw new AutomationException("Price Name : " + price + "expected : " + DtAutomationContext.getOffer().getCurrentRate()
#         }
#     }
#     public void basketMultiplePackageControl() {
#         log.info("Package adding control from the basket"
#         BTN_SKIP_SUGGESTED_BASKET.waitUntilVisible(
#         BTN_SKIP_SUGGESTED_BASKET.waitFor(3
#         Integer packageSize = LBL_MULTIPLE_PACKAGE.getSize(
#         log.info("Package size: " + packageSize
#         if (packageSize != 2) {
#             throw new AutomationException("No package added from the basket"
#         }
#     }
#
#     public void basketMultipleAllPrice(){
#         LBL_PAYING_RESULT.waitUntilVisible(
#         String price = LBL_PAYING_RESULT.getLabelText(
#         log.info("Get price " + price
#         if (price.contains(DtAutomationContext.getOffer().getCurrentRate())) {
#             throw new AutomationException("Price Name : " + price + "greater than the expected : " + DtAutomationContext.getOffer().getCurrentRate()
#         }
#     }
#
#     public void clickSkipSuggestedBasket() {
#         log.info("Click to basket DEVAM ET"
#         BTN_SKIP_SUGGESTED_BASKET.waitUntilVisibleAndClick(
#
#     }
#     public void checkVoucherCode(){
#         LBL_PAYING_RESULT.waitUntilVisible(
#         String price = LBL_PAYING_RESULT.getLabelText(
#         log.info("Get price " + price
#         if (!price.contains("0,00 TL") ){
#             throw new AutomationException("Vouchercode Price : " + price + "expected : 0,00 TL "
#         }
#     }
#
#     public void clickSkipSuggestedUpgradeBasket() {
#         JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
#         log.info("Click to basket DEVAM ET"
#         WebElement ELEMENT = Driver.webDriver.findElement(By.id("bc-btn-see-suggested-packages")
#         js.executeScript("arguments[0].scrollIntoView( ", ELEMENT
#         js.executeScript("arguments[0].click( ", ELEMENT
#       //  BTN_SKIP_SUGGESTED_BASKET.waitUntilVisibleAndClick(
#     }
#
#
#
#     public void clickSkipSuggestedBasketLast() {
#         BTN_SKIP_SUGGESTED_BASKET_LAST.waitUntilVisibleAndClick(
#     }
#
#     public static void clickToPackageFromBasketUpgrade() {
#         JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
#         log.info("Upgrade package from basket"
#         BeinButton BTN_UPGRADE =   "//span[contains(text(),'" + DtAutomationContext.getOffer().getCurrentRate() + "')]//..//..//..//..//a[@id='add-package-into-basket']"
#         WebElement ELEMENT = Driver.webDriver.findElement(By.xpath("//span[contains(text(),'" + DtAutomationContext.getOffer().getCurrentRate() + "')]//..//..//..//..//a[@id='add-package-into-basket']")
#         js.executeScript("arguments[0].scrollIntoView( ", ELEMENT
#         js.executeScript("arguments[0].click( ", ELEMENT
#         BTN_UPGRADE.waitFor(5
#     }
#
#     public static void clickAddPackage() {
#         JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
#         log.info("Add package from basket"
#         WebElement ELEMENT = Driver.webDriver.findElement(By.xpath("(//div[@id='bc-subview-package-suggestions']//a)[1]")
#         js.executeScript("arguments[0].scrollIntoView( ", ELEMENT
#         js.executeScript("arguments[0].click( ", ELEMENT
#     }
#
#
#
#
# }