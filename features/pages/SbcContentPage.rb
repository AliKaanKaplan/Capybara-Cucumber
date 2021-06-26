=begin
package com.dt.standalone.pages;

import com.dt.standalone.backend.AutomationException;
import com.dt.standalone.backend.ContextKeys;
import com.dt.standalone.backend.DTSoapConnection;
import com.dt.standalone.backend.DtAutomationContext;
import com.dt.standalone.pageElement.BeinButton;
import com.dt.standalone.pageElement.BeinLabel;
import com.dt.standalone.pageElement.BeinTextBox;
import com.dt.standalone.pageElement.PageElementModel;
import com.dt.standalone.utils.WebService.RestUserService;
import com.dt.standalone.utils.dbquery.DBQueryUtil;
import com.dt.standalone.utils.driver.Driver;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openqa.selenium.*;


public class SbcContentPage extends SbcMasterPage {
    private static final Log log = LogFactory.getLog(SbcContentPage.class);
    private static SbcContentPage instance;
    
    private static BeinButton BTN_Watch = new BeinButton(PageElementModel.selectorNames.XPATH, "(//a[text()='İZLE'])[1]");
    private static BeinButton BTN_WatchSeries = new BeinButton(PageElementModel.selectorNames.ID, "watching-smart-binge");
    private static BeinButton BTN_WatchLastEpisode = new BeinButton(PageElementModel.selectorNames.XPATH, "//a[contains(text(),'İZLE')]");
    private static BeinButton BTN_CreatePvr = new BeinButton(PageElementModel.selectorNames.XPATH, "//a[text()='KAYDET VE İZLE']");
    private static BeinButton BTN_CancelPvr = new BeinButton(PageElementModel.selectorNames.XPATH, "//a[text()='KAYDETMEYİ DURDUR']");
    private static BeinButton BTN_Trailer = new BeinButton(PageElementModel.selectorNames.XPATH, "//a[text()='FRAGMAN İZLE']");
    private static BeinButton BTN_Login = new BeinButton(PageElementModel.selectorNames.XPATH, "(//a[@data-component-info='link'])[3]");
    private static BeinButton BTN_WatchLastRecorded = new BeinButton(PageElementModel.selectorNames.XPATH, "//a[contains(text(),'KAYITLI SON BÖLÜMÜ İZLE')]");
    private static BeinButton BTN_AddToFavorites = new BeinButton(PageElementModel.selectorNames.XPATH, "//img[contains(@class,'addfavourite')]");
    private static BeinButton BTN_RemoveFromFavorites = new BeinButton(PageElementModel.selectorNames.XPATH, "//img[contains(@class,'removefavourite')]");
    private static BeinLabel LBL_HeaderMessage = new BeinLabel(PageElementModel.selectorNames.XPATH, "//div[@class='header-information']//p");
    private static BeinButton BTN_BuyPackage = new BeinButton(PageElementModel.selectorNames.XPATH, "(//a[@class='offer-item'])[1]");
    private static BeinButton BTN_BuyContent = new BeinButton(PageElementModel.selectorNames.XPATH, "(//a[@data-title='Satın Al'])[1]");
    private static BeinButton BTN_RentContent = new BeinButton(PageElementModel.selectorNames.XPATH, "(//a[@data-offer-type='TVOD' and @data-title='Kirala'])[1]//img");
    private static BeinTextBox TXT_SmsCode = new BeinTextBox(PageElementModel.selectorNames.XPATH, "(//input[@name='lname'])[1]");
    private static BeinButton BTN_SmsConfirm = new BeinButton(PageElementModel.selectorNames.XPATH, "(//a[@class='verification-code'])[1]");
    private static BeinTextBox TXT_BoxOfficePageLoadItem = new BeinTextBox(PageElementModel.selectorNames.XPATH, "//input[@data-main-category='box-office']");
    private static BeinLabel LBL_FavHeader = new BeinLabel(PageElementModel.selectorNames.CLASS_NAME,"favourite-header");
    private static BeinButton BTN_BUY = new BeinButton(PageElementModel.selectorNames.XPATH,"(//a[@data-category='EGLENCE_OTT_WEB_KATALOGU'])[1]");
    private static BeinButton BTN_ContiueWatching = new BeinButton(PageElementModel.selectorNames.XPATH,"//a[contains(text(),'YERDEN İZLE')]");
    private static BeinButton BTN_WatchedContent = new BeinButton(PageElementModel.selectorNames.XPATH,"//a[@data-item-title='"+DtAutomationContext.getContextValue(ContextKeys.CONTENT_TITLE)+"']" );
    private static BeinButton BTN_WatchListBar = new BeinButton(PageElementModel.selectorNames.XPATH,"(//div[@class='progress-bar bg-danger'])[1]");
    private static BeinLabel BTN_WatchListWatchTime = new BeinLabel(PageElementModel.selectorNames.XPATH,"(//span[@class='movie-date'])[1]");
    public static synchronized SbcContentPage getInstance() {
        if (instance == null)
            instance = new SbcContentPage();
        return instance;
    }

    public void clickMovieContent(String sectionName) {
        JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
        log.info("ENTERING clickMovieContent");
        WebElement element3 = Driver.webDriver.findElement(By.xpath("//h2[text()='" + sectionName + "']/.."));
        js.executeScript("arguments[0].scrollIntoView();", element3);
        js.executeScript("arguments[0].click();", element3);
        WebElement element5 = Driver.webDriver.findElement(By.xpath("(//a[@class='favorite-hub-v2'])[18]"));
        js.executeScript("arguments[0].scrollIntoView();", element5);
        js.executeScript("arguments[0].click();", element5);
        WebElement element4 = Driver.webDriver.findElement(By.xpath("//div[@class='general-info-area']//h1"));
        js.executeScript("arguments[0].scrollIntoView();", element4);
        js.executeScript("arguments[0].click();", element4);
        BeinLabel LBL_MovieName = new BeinLabel(PageElementModel.selectorNames.XPATH, "//div[@class='general-info-area']//h1");
        String movieName = LBL_MovieName.getLabelText();
        log.info(movieName);
        DtAutomationContext.addContext(ContextKeys.CONTENT_TITLE, movieName);
    }

    public void clickToContentDetailButton(String buttonName){
        BTN_BUY.waitFor(3);
        BeinButton contentDetailButton = new BeinButton(PageElementModel.selectorNames.XPATH,"//a[text()='" + buttonName + "']");
        contentDetailButton.waitUntilVisibleAndClick();
        if(!buttonName.contains("30")){
            int retry = 10;
            BeinButton BTN_BUY = new BeinButton(PageElementModel.selectorNames.XPATH,"//a[@href='/satinal']");
            BTN_BUY.waitFor(5);
            while(BTN_BUY.isDisplayed() && --retry > 0){
                Driver.webDriver.navigate().refresh();
                BTN_BUY.waitFor(5);
                contentDetailButton.waitUntilVisibleAndClick();
            }
        }
    }


    public void clickSeriesContent(String sectionName) {
        JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
        log.info("ENTERING clickSeriesContent");
        BeinButton BTN_Section = new BeinButton(PageElementModel.selectorNames.XPATH, "//h2[text()='" + sectionName + "']/..");
        WebElement ELEMENT3 = Driver.webDriver.findElement(By.xpath("//h2[text()='" + sectionName + "']/.."));
        js.executeScript("arguments[0].scrollIntoView();", ELEMENT3);
        js.executeScript("arguments[0].click();", ELEMENT3);
        BeinButton BTN_MovieContent = new BeinButton(PageElementModel.selectorNames.XPATH, "(//a[@class='favorite-hub-v2'])[4]");
        BTN_MovieContent.waitUntilVisibleAndClick();
        BeinLabel LBL_MovieName = new BeinLabel(PageElementModel.selectorNames.XPATH, "//h1[@class='content-header']");
        LBL_MovieName.waitUntilVisible();
        String movieName = LBL_MovieName.getLabelText();
        log.info("Content name: " +movieName);
        DtAutomationContext.addContext(ContextKeys.CONTENT_TITLE, movieName);
    }

    public void checkTitle() {
        String title = DtAutomationContext.getContextValue(ContextKeys.CONTENT_TITLE);
        BeinLabel LBL_ContentHeader = new BeinLabel(PageElementModel.selectorNames.XPATH, "//h1[@class='content-header' and normalize-space(text())=\"" + title + "\"]");
        LBL_ContentHeader.waitUntilVisible();
    }

    public void clickPlay() {
        log.info("ENTERING clickPlay");
        if(DtAutomationContext.getUser().getFrekans().contains("F01-BB-TR")) {
            BTN_Watch.waitFor(40);
            BTN_Watch.pageReflesh();
        }
        BTN_Watch.waitUntilVisible();
        BTN_Watch.waitFor(3);
        BTN_Watch.waitUntilVisibleAndClick();
    }

    public void clickSeriesPlay() {
        log.info("ENTERING clickPlay");
        BTN_WatchSeries.waitUntilVisible();
        BTN_WatchSeries.waitFor(3);
        BTN_WatchSeries.waitUntilVisibleAndClick();
    }

    public void clickPlayLastEpisode() {
        log.info("ENTERING clickPlayLastEpisode");
        if(DtAutomationContext.getUser().getFrekans().contains("F01-BB-TR")){
            BTN_WatchLastEpisode.waitFor(50);
            BTN_WatchLastEpisode.pageReflesh();
        }
        BTN_WatchLastEpisode.waitUntilVisible();
        BTN_WatchLastEpisode.waitFor(3);
        BTN_WatchLastEpisode.waitUntilVisibleAndClick();
    }

    public void clickToContiueWatchingButon(){
        log.info("Click to continue watching buton from episode detail page");
        BTN_ContiueWatching.waitUntilVisibleAndClick();

    }

    public void clickCreatePvr() {
        log.info("ENTERING clickCreatePvr");
        BTN_CreatePvr.waitUntilVisible();
        BTN_CreatePvr.waitFor(3);
        BTN_CreatePvr.waitUntilVisibleAndClick();
        DtAutomationContext.getUser().setValid(false);
        RestUserService.getInstance().putUser();
    }

    public void clickCancelPvr() {
        log.info("ENTERING clickCancelPvr");
        BTN_CancelPvr.waitUntilVisible();
        BTN_CancelPvr.waitFor(3);
        BTN_CancelPvr.waitUntilVisibleAndClick();
        DtAutomationContext.getUser().setValid(true);
        RestUserService.getInstance().putUser();
    }

    public void clickWatchLastRecordedEpisode() {
        log.info("ENTERING clickWatchLastRecordedEpisode");
        BTN_WatchLastEpisode.waitFor(2);
        BTN_WatchLastRecorded.waitUntilVisibleAndClick();
    }

    public void checkRecordedEpisode() {
        log.info("ENTERING checkRecordedEpisode");
        BeinButton BTN_LastEpisode = new BeinButton(PageElementModel.selectorNames.XPATH, "(//a[@class='season-episode-item'])[1]");
        BTN_LastEpisode.waitUntilVisible();
    }

    public void addToFavorites() {
        log.info("ENTERING addToFavorites");
        BTN_AddToFavorites.waitFor(3);
        BTN_AddToFavorites.waitUntilVisibleAndClick();
    }

    public void removeFromFavorites() {
        log.info("ENTERING removeFromFavorites");
        BTN_RemoveFromFavorites.waitUntilVisibleAndClick();
        BTN_RemoveFromFavorites.waitFor(2);
    }

    public void checkFavorites() {
        log.info("ENTERING ");
        BeinLabel LBL_FavoriteTitle = new BeinLabel(PageElementModel.selectorNames.XPATH, "(//span[@class='movie-name'])[1]");
        int retryCount = 3;
        boolean isFound = false;
        while (!isFound && retryCount-- > 0)
            try {

                LBL_FavoriteTitle.waitUntilVisible(10);
                isFound = true;
                if(!DtAutomationContext.getContextValue(ContextKeys.CONTENT_TITLE).contains(LBL_FavoriteTitle.getLabelText())){
                    throw new AutomationException("DONT WANT RECENTENLY WATCH");
                }
            } catch (TimeoutException e) {
                Driver.webDriver.navigate().refresh();
            }
    }

    public void checkDuration(){
        BTN_WatchListWatchTime.waitUntilVisible();
        String watchTime = BTN_WatchListWatchTime.getLabelText();
        log.info("Watch time : "+ watchTime);
        if(!watchTime.contains(" dk. izlediniz.")){
            throw new AutomationException("Watched time wrong : "+ watchTime+" expected: 3 dk. izlediniz.");
        }
        BTN_WatchListBar.isDisplayed();

    }

    public void checkFavoritesNotContent() {
        BeinLabel LBL_NotFavoriteTitle = new BeinLabel(PageElementModel.selectorNames.XPATH, "//span[ not text()='" + DtAutomationContext.getContextValue(ContextKeys.CONTENT_TITLE) + "']");
        int retryCount = 1;
        boolean isFound = false;
        while (!isFound) {
            try {
                LBL_NotFavoriteTitle.getLabelText();

            } catch (NoSuchElementException e) {
                log.info("Succesful");
            }
        }

    }


    public void checkRentals() {
        log.info("ENTERING checkRentals");
        BeinLabel LBL_FavoriteTitle = new BeinLabel(PageElementModel.selectorNames.XPATH, "//span[text()='" + DtAutomationContext.getContextValue(ContextKeys.CONTENT_TITLE) + "']");
        int retryCount = 3;
        boolean isFound = false;
        while (!isFound && retryCount-- > 0)
            try {
                LBL_FavoriteTitle.waitUntilVisible(10);
                isFound = true;
            } catch (TimeoutException e) {
                Driver.webDriver.navigate().refresh();
            }
    }

    public void checkFavoritesIsEmpty() {
        log.info("ENTERING checkFavoritesIsEmpty");
        LBL_FavHeader.waitUntilVisible();
        BeinButton  BTN_FavContent = new BeinButton(PageElementModel.selectorNames.XPATH,"(//a[@class='favorite-hub-v2'])[1]");
        Boolean contentIsOk =  BTN_FavContent.isDisplayed();
        if(contentIsOk){
            BeinLabel LBL_FavoriteTitle = new BeinLabel(PageElementModel.selectorNames.XPATH, "//span[text()='" + DtAutomationContext.getContextValue(ContextKeys.CONTENT_TITLE) + "']");
            if(LBL_FavoriteTitle.isDisplayed()){
                throw new AutomationException("Fav content not remove");
            }
            else{
                log.info("Fav Content remove");
            }
        }
        else{
            BeinLabel LBL_Empty = new BeinLabel(PageElementModel.selectorNames.XPATH, "//div[text()='İçerik bulunamadı.']");
            LBL_Empty.waitUntilVisible();
        }

    }

    public void clickTrailer() {
        log.info("ENTERING clickTrailer");
        BTN_Trailer.waitFor(3);
        BTN_Trailer.waitUntilVisibleAndClick();
    }

    public void clickLogin() {
        log.info("ENTERING clickLogin");
        BTN_Login.waitUntilVisibleAndClick();
    }

    public void makeFraud() {
        log.info("USER MAKE FRAUD");
        DTSoapConnection.getInstance().getAccountMemberToken();
        DTSoapConnection.getInstance().markUserAsFraud();
        DtAutomationContext.getUser().setFraud(true);
        DtAutomationContext.getUser().setValid(false);
        RestUserService.getInstance().putUser();
    }


    public void checkFraudMessage() {
        log.info("CHECK FRAUD MESSAGE");
        BeinLabel LBL_MULTI_PLAY_MESSAGE= new BeinLabel(PageElementModel.selectorNames.XPATH,"//div[text()='test Fraud']");
        LBL_MULTI_PLAY_MESSAGE.waitUntilVisible(500);

    }
   public void checkMultiPlayMessageContent(String message){
       log.info("CHECK MULTIPLAY MESSAGE");
       LBL_HeaderMessage.waitUntilVisible(500);

       if (!LBL_HeaderMessage.getLabelText().contains(message)) {
           throw new AutomationException("MULTIPLAY NOT WORKING");
       }
   }
    public void checkMultiPlayMessage(String message) {
        log.info("CHECK MULTIPLAY MESSAGE");
        BeinLabel LBL_MULTI_PLAY_MESSAGE= new BeinLabel(PageElementModel.selectorNames.XPATH,"//div[text()='"+message+"']");
        LBL_MULTI_PLAY_MESSAGE.waitUntilVisible(500);
    }

    public void checkCancelBlackoutMessage() {
        log.info("CHECK CANCEL BLACKOUT MESSAGE");
        BeinLabel LBL_BLACKOUTCANCEL_MESSAGE = new BeinLabel(PageElementModel.selectorNames.XPATH,"//div[text()='IP yayınınız UYDU’ya yönlendirilmiştir. İyi seyirler dileriz.']");
        LBL_BLACKOUTCANCEL_MESSAGE.waitUntilVisible(500);

    }
    public void waitPPVCancelBlackoutMessage() {
        log.info("CHECK CANCEL BLACKOUT MESSAGE");
        LBL_HeaderMessage.waitUntilVisible(500);
        log.info(LBL_HeaderMessage.getLabelText());
        if (!LBL_HeaderMessage.getLabelText().contains("IP yayınınız UYDU’ya yönlendirilmiştir. İyi seyirler dileriz.")) {
            log.error("Cancel blackout not working");
        }
    }

    public void clickBuyPackage() {
        log.info("ENTERING clickBuyPackage");
        BTN_BuyPackage.waitUntilVisibleAndClick();
    }

    public void clickBuyContent() {
        log.info("ENTERING clickBuyContent");
        BTN_BuyContent.waitUntilVisibleAndClick();
    }

    public void clickRentContent() {
        log.info("ENTERING clickRentContent");
        BTN_RentContent.waitUntilVisibleAndClick();
    }

    public void checkFreeMessage(){
        log.info("Check dav member free message");
        BTN_RentContent.waitFor(20);
        BeinLabel LBL_FREE_MESSAGE = new BeinLabel(PageElementModel.selectorNames.XPATH, "(//div[@class='package-name' and text()='Kirala']/..//div[@class='package-detail'])[1]");
        String messageText = LBL_FREE_MESSAGE.getLabelText();
        log.info("Rent message: " +messageText);

        if(!messageText.contains("içeriği ücretsiz izleyebilirsiniz. Kalan ücretsiz izleme hakkınız")){
            throw new AutomationException("DAV member dont have  free rent message: " + messageText);
        }
    }

    public void typeSmsCode() {
        log.info("ENTERING typeSmsCode");
        TXT_SmsCode.waitUntilVisible();
        TXT_SmsCode.type(DBQueryUtil.getInstance().getSmsCodeByAccountNumber(DtAutomationContext.getUser().getDbsAccountNumber()));
    }

    public void clickConfirmSms() {
        log.info("ENTERING clickConfirmSms");
        BTN_SmsConfirm.click();
        DtAutomationContext.getUser().setValid(false);
        RestUserService.getInstance().putUser();
    }

    public void clickVodContent(String vodType) {
        JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
        BeinButton BTN_EstvodContent = null;
        // TXT_BoxOfficePageLoadItem.waitUntilLoad();
        boolean tryNewContent = true;
        int rowNum = 1;
      /*  BeinButton BTN_EstvodContent = null;
        String[][] contentId = DBQueryUtil.getInstance().getVodID(vodType);
        while (tryNewContent) {
           // BTN_EstvodContent = new BeinButton(PageElementModel.selectorNames.XPATH, "//img[contains(@src,'" + contentId[rowNum][0] + "')]");
            BTN_EstvodContent = new BeinButton(PageElementModel.selectorNames.XPATH, "//img[contains(@src,'PT0000174508')]");


            try {
                BTN_EstvodContent.waitUntilVisible(1);
                tryNewContent = false;
            } catch (TimeoutException e) {
                rowNum += 1;
                if (rowNum == 10)
                    throw new AutomationException("VOD content not found");
            }
        }
        String movieName = BTN_EstvodContent.getAttribute("alt");*/
       if(vodType.contains("ESTVOD_IQ")){
           BTN_EstvodContent = new BeinButton(PageElementModel.selectorNames.XPATH, "//img[contains(@src,'PT0000033215')]");
           BTN_EstvodContent.waitUntilVisible();
           WebElement BTN_EstvodContent1 = Driver.webDriver.findElement(By.xpath("//img[contains(@src,'PT0000033215')]"));
           js.executeScript("arguments[0].scrollIntoView();", BTN_EstvodContent1);
           js.executeScript("arguments[0].click();", BTN_EstvodContent1);
       }
       else{
           BTN_EstvodContent = new BeinButton(PageElementModel.selectorNames.XPATH, "//img[contains(@src,'PT0000027854')]");
           BTN_EstvodContent.waitUntilVisible();
           WebElement BTN_EstvodContent2 = Driver.webDriver.findElement(By.xpath("//img[contains(@src,'PT0000027854')]"));
           js.executeScript("arguments[0].scrollIntoView();", BTN_EstvodContent2);
           js.executeScript("arguments[0].click();", BTN_EstvodContent2);
       }
        BTN_EstvodContent.waitUntilVisible();
        String movieName = BTN_EstvodContent.getAttribute("alt");
        log.info("ENTERING clickMovieContent");
        DtAutomationContext.addContext(ContextKeys.CONTENT_TITLE, movieName);
    }

    public void clickToPageSection(String section) {
        JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
        log.info("Choose Payment Method Free Trial");
        WebElement BTN_Section = Driver.webDriver.findElement(By.xpath("//h2[text()='"+section+"']/.."));
        js.executeScript("arguments[0].scrollIntoView();", BTN_Section);
        js.executeScript("arguments[0].click();", BTN_Section);
    }




    public void clickToBuyContentPage(){
        BTN_BUY.waitUntilVisibleAndClick();
    }

    public void findBoxOfficeContent(){
        String[][] longNames =   DBQueryUtil.getInstance().getVodName("TVOD_IQ");
        log.info("Content: "+ longNames[0][0]);
        DtAutomationContext.addContext(ContextKeys.CONTENT_TITLE,longNames[0][0]);
    }

    public void clickToWatchedContent(){
        log.info("Click to watched content");
        log.info("Contetnt name: "+ DtAutomationContext.getContextValue(ContextKeys.CONTENT_TITLE));
        BeinButton BTN_WatchedContent = new BeinButton(PageElementModel.selectorNames.XPATH,"//a[@data-item-title='"+DtAutomationContext.getContextValue(ContextKeys.CONTENT_TITLE)+"']" );
        BTN_WatchedContent.waitUntilVisibleAndClick();
    }




}
=end