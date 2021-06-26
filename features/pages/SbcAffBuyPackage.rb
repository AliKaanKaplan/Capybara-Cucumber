
=begin
package com.dt.standalone.pages;

import com.amazonaws.services.dynamodbv2.document.Page;
import com.dt.standalone.backend.AutomationException;
import com.dt.standalone.backend.DtAutomationContext;
import com.dt.standalone.model.Offer;
import com.dt.standalone.pageElement.*;
import com.dt.standalone.utils.WebService.RestPackageService;
import com.dt.standalone.utils.driver.Driver;
import org.apache.commons.lang.WordUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebElement;

import java.util.HashMap;
import java.util.Map;

public class SbcAffBuyPackage extends SbcMasterPage {
    private static final Log log = LogFactory.getLog(SbcAffBuyPackage.class);
    private static SbcAffBuyPackage instance;
    private static BeinButton BTN_BUY = new BeinButton(PageElementModel.selectorNames.XPATH, "//div[@class='player-offer-explore']//a");

    public static synchronized SbcAffBuyPackage getInstance() {

        if (instance == null)
            instance = new SbcAffBuyPackage();
        return instance;
    }

    public void getPackageWithShortCode(String shortCode){
        try {
            log.info("Get package");
            Map<String, String> queryParams = new HashMap<String,String>();
            queryParams.put("shortCode", shortCode);
            Offer offer = RestPackageService.getInstance().getPackage(queryParams);
            if(offer.getShortCode().contains("SPR"))
                offer.setCatalogCode("SUPER_LIG_OTT_WEB_KATALOGU");
            if(offer.getShortCode().contains("SPE"))
                offer.setCatalogCode("SPE_PLUS_OTT_WEB_KATALOGU");
            if(offer.getShortCode().contains("EGL"))
                offer.setCatalogCode("EGLENCE_OTT_WEB_KATALOGU");
            DtAutomationContext.setOffer(offer);
            log.info("Get package "+offer);
        }catch (Exception e) {
            throw new AutomationException("Get offer method exception: "+ e);
        }
    }

    public void clickToCatalog(){
        log.info("Click to catalog: " +DtAutomationContext.getOffer().getCatalogCode());
        BeinButton BTN_KATALOG = new BeinButton(PageElementModel.selectorNames.XPATH,"//button[@data-tab='"+DtAutomationContext.getOffer().getCatalogCode()+"']");
        try {
            BTN_KATALOG.waitUntilVisibleAndClick();
        }catch (Exception e){
            BTN_KATALOG.pageReflesh();
            BTN_KATALOG.waitUntilVisibleAndClick();
        }

    }

    public void checkOfferName(){
        log.info("Validate package Information");
        BeinLabel LBL_OFFER_NAME =new  BeinLabel(PageElementModel.selectorNames.XPATH,"//div[@id='"+DtAutomationContext.getOffer().getCatalogCode()+"']//h3[text()='"+DtAutomationContext.getOffer().getPackageName()+"']//..//..//div[@class='package-label']//span[contains(text(),'"+DtAutomationContext.getOffer().getOfferName()+"')]");
        log.info("//div[@id='"+DtAutomationContext.getOffer().getCatalogCode()+"']//h3[text()='"+DtAutomationContext.getOffer().getPackageName()+"']//..//..//div[@class='package-label']//span[contains(text(),'"+DtAutomationContext.getOffer().getOfferName()+"')]");
        LBL_OFFER_NAME.waitUntilInvisible();
        if(LBL_OFFER_NAME.isDisplayed()){
            log.info("Offer name success");
        }else{
            throw new AutomationException("Package name wrong exğected: "+DtAutomationContext.getOffer().getOfferName());
        }
    }
    public void checkCatalogName(){
        log.info("Check catalog name");
        BeinLabel  LBL_CATALOG_NAME = new BeinLabel(PageElementModel.selectorNames.XPATH,"//button[@data-tab='"+DtAutomationContext.getOffer().getCatalogCode()+"']");
        String catalogName = LBL_CATALOG_NAME.getLabelText();
        if(!catalogName.contains(DtAutomationContext.getOffer().getCategoryName())){
            throw new AutomationException("Expected catalog name: "+DtAutomationContext.getOffer().getCategoryName()+"Page catalog name: "+catalogName );
        }
    }

    public void clickToPackage(){
        log.info("Click to package:" + DtAutomationContext.getOffer().getOfferName());
        JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
        if(DtAutomationContext.getOffer().getShortCode().contains("4E")){

            WebElement element= Driver.webDriver.findElement(By.xpath("//div[@id='"+DtAutomationContext.getOffer().getCatalogCode()+"']//h3[text()='"+DtAutomationContext.getOffer().getPackageName()+"']//..//..//input[@type='checkbox']"));
            js.executeScript("arguments[0].click();",element);
        }

        WebElement btnElement = Driver.webDriver.findElement(By.xpath("//div[@id='"+DtAutomationContext.getOffer().getCatalogCode()+"']//h3[text()='"+DtAutomationContext.getOffer().getPackageName()+"']//..//..//a[@id='add-package-into-basket']"));
        log.info("//div[@id='"+DtAutomationContext.getOffer().getCatalogCode()+"']//h3[text()='"+DtAutomationContext.getOffer().getPackageName()+"']//..//..//a[@id='add-package-into-basket']");
        js.executeScript("arguments[0].click();",btnElement);
    }
    public void clickToBuyPackageOnLiveChannel() {
        BTN_BUY.waitFor(5);
        BTN_BUY.waitUntilVisibleAndClick(15);
    }

    public void checkBuyedMessage(String message) {
        log.info("Message wait: " + message);
        BeinLabel lblBuyedMessage = new BeinLabel(PageElementModel.selectorNames.XPATH, "//h4[text()='" + message + "']");
        lblBuyedMessage.waitUntilVisible(10);
    }


}
=end