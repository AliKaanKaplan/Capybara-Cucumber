=begin
package com.dt.standalone.pages;

import com.dt.standalone.backend.AutomationException;
import com.dt.standalone.backend.ContextKeys;
import com.dt.standalone.backend.DtAutomationContext;
import com.dt.standalone.pageElement.BeinButton;
import com.dt.standalone.pageElement.BeinLabel;
import com.dt.standalone.pageElement.BeinTextBox;
import com.dt.standalone.pageElement.PageElementModel;
import com.dt.standalone.utils.driver.Driver;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebElement;


public class SbcHomePage extends SbcMasterPage {
    private static final Log log = LogFactory.getLog(SbcHomePage.class);
    private static SbcHomePage instance;

    private static BeinButton BTN_AFF_LOGO = new BeinButton(PageElementModel.selectorNames.XPATH, "//div[@class='aff-logo']//a");
    private static BeinLabel LBL_FavouriteModulMessage = new BeinLabel(PageElementModel.selectorNames.XPATH, "//div[@class='content-slider-async-favourite']//p");
    private static BeinButton BTN_SEARCH = new BeinButton(PageElementModel.selectorNames.ID, "bc-btn-search");
    private static BeinButton BTN_SEARCH_LOGIN = new BeinButton(PageElementModel.selectorNames.ID, "bc-btn-search");
    private static BeinTextBox TXT_SEARCH = new BeinTextBox(PageElementModel.selectorNames.ID, "bc-input-search" );
    private static BeinButton BTN_FAVOURITE_CONTENT = new BeinButton(PageElementModel.selectorNames.XPATH, "(//div[@class='container favourite-slider pt30']//a[@class='swiper-slide-item'])[1]");
    private static BeinLabel LBL_CONTENT_HEADER = new BeinLabel(PageElementModel.selectorNames.XPATH, "//h1[@class='content-header']");
    private static BeinButton BTN_PAGE_FAVOURITE_CONTENT = new BeinButton(PageElementModel.selectorNames.XPATH, "((//a[@href='/favorilerim'])[3]//..//..//..//a)[3]");
    private static BeinLabel LBL_FAV_MESSAGE_CONTENT_PAGE = new BeinLabel(PageElementModel.selectorNames.XPATH, "//div[@class='nodata-content']");
    private static BeinLabel LBL_PAGE_HEADER = new BeinLabel(PageElementModel.selectorNames.XPATH, "//h4");
    private static BeinButton BTN_USER_LIST_MENU_ALL = new BeinButton(PageElementModel.selectorNames.XPATH, "//ul[@class='user-links-menu']//li");
    private static BeinButton BTN_USER_ACCOUNT_MENU_ALL = new BeinButton(PageElementModel.selectorNames.XPATH, "//ul[@class='user-actions-menu']//li");
    private static BeinLabel LBL_QUICKSEARCH_INFO = new BeinLabel(PageElementModel.selectorNames.XPATH, "//div[@id='bc-search-results']//div");
    private static BeinButton BTN_FirstMovieCWL = new BeinButton(PageElementModel.selectorNames.XPATH, "(//a[@data-component-info='sushi/İzlemeye Devam Et'])[1]");
    private static BeinButton PAGE_SCROLL  =new BeinButton(PageElementModel.selectorNames.XPATH,"");
    private static BeinButton BTN_NETMERA_POPUP_ALLOW = new BeinButton(PageElementModel.selectorNames.ID,"btn-allow");

    public static synchronized SbcHomePage getInstance() {
        if (instance == null)
            instance = new SbcHomePage();
        return instance;
    }

    public void checkEmptyFavouriteModuleMessage(String message) {
        LBL_FavouriteModulMessage.waitUntilVisible();
        String lblMessage = LBL_FavouriteModulMessage.getLabelText();
        if (!lblMessage.equals(lblMessage)) {
            error = "EMPYT FAVOURITE MESSAGE WRONG :" + lblMessage;
            log.error(error);
            throw new AutomationException(error);
        }
        log.info("Favourite emty message: " + lblMessage);
    }


    public void checkFavoriteModulContent() {
        BTN_FAVOURITE_CONTENT.waitUntilVisible();
        BTN_FAVOURITE_CONTENT.click();
        LBL_CONTENT_HEADER.waitUntilVisible();
        String favContent = LBL_CONTENT_HEADER.getLabelText();
        if (!favContent.equals(DtAutomationContext.getContextValue(ContextKeys.CONTENT_TITLE))) {
            error = "Content name wrong: " + favContent + "expected content name: " + DtAutomationContext.getContextValue(ContextKeys.CONTENT_TITLE);
            log.error(error);
            throw new AutomationException(error);
        }
    }

    public void checkFavouriteContentOnContentPage() {
        BTN_PAGE_FAVOURITE_CONTENT.waitUntilVisibleAndClick();
        LBL_CONTENT_HEADER.waitUntilVisible();
        String favContent = LBL_CONTENT_HEADER.getLabelText();
        if (!favContent.equals(DtAutomationContext.getContextValue(ContextKeys.CONTENT_TITLE))) {
            error = "Content name wrong: " + favContent + "expected content name: " + DtAutomationContext.getContextValue(ContextKeys.CONTENT_TITLE);
            log.error(error);
            throw new AutomationException(error);
        }
    }

    public void searchContent(String content) {
        log.info("Search VOD content");
        BTN_SEARCH.waitUntilVisibleAndClick();
        TXT_SEARCH.waitUntilVisibleAndType(content);
        TXT_SEARCH.type("");
        BeinButton BTN_SEARCH_CONTENT = new BeinButton(PageElementModel.selectorNames.XPATH, "//a[@data-item-title='"+content+"']");
        BTN_SEARCH_CONTENT.waitUntilVisibleAndClick();
    }

    public void searchBoxofficeContent() {
        log.info("Search TVOD_IQ content");
        BTN_SEARCH.waitUntilVisibleAndClick();
        TXT_SEARCH.waitUntilVisibleAndType(DtAutomationContext.getContextValue(ContextKeys.CONTENT_TITLE));
    }

    public void noContentFound() {
        LBL_QUICKSEARCH_INFO.waitUntilVisible();
        String noFound = LBL_QUICKSEARCH_INFO.getLabelText();
        log.info("Label text: "+ noFound);
        if (!noFound.contains("Sonuç bulunamadı")) {
            throw new AutomationException("Show boxoffice content to BB user " + ContextKeys.CONTENT_TITLE);
        }

        refreshPage();
    }

    public void searchBoxofficeContentwithLogin() {
        log.info("Search TVOD_IQ content");
        BTN_SEARCH_LOGIN.waitUntilVisibleAndClick();
        TXT_SEARCH.waitUntilVisibleAndType(DtAutomationContext.getContextValue(ContextKeys.CONTENT_TITLE));
    }

    public void searchContentForLogin(String content) {
        BTN_SEARCH_LOGIN.waitUntilVisibleAndClick();
        TXT_SEARCH.waitUntilVisibleAndType(content);
        TXT_SEARCH.type(" ");
        BeinButton BTN_SEARCH_CONTENT = new BeinButton(PageElementModel.selectorNames.XPATH, "//a[@data-item-title='" + content + "']");
        BTN_SEARCH_CONTENT.waitUntilVisibleAndClick();

    }

    public void searchContentForChildMode(String content){
        BTN_SEARCH_LOGIN.waitFor(5);
        BTN_SEARCH_LOGIN.waitUntilVisibleAndClick();
        TXT_SEARCH.waitUntilVisibleAndType(content);
    }

    public void checkFavouriteModuleMessageContentPage(String message) {
        LBL_FAV_MESSAGE_CONTENT_PAGE.waitUntilVisible();
        String favMessage = LBL_FAV_MESSAGE_CONTENT_PAGE.getLabelText();
        if (!favMessage.equals(message)) {
            log.error("MESSAGE IS NOT CORRET: " + favMessage);
            throw new AutomationException("MESSAGE IS NOT CORRET: " + favMessage);
        }

    }


    public void checkListMenuLevel(int menuLevel) {
        BTN_ListsMenu.waitUntilVisible();
        BTN_ListsMenu.hoverOn();
        int count = BTN_USER_LIST_MENU_ALL.getSize();
        if (count != menuLevel) {
            error = "WRONG MENU LEVEL SIZE";
            log.error(error);
            throw new AutomationException(error);
        }
        log.info("Size: " + count);
    }


    public void clickToHeaderMenuList(String menuName) {

        BTN_ListsMenu.waitUntilVisible();
        BTN_ListsMenu.hoverOn();
        log.info("Size: " + BTN_USER_LIST_MENU_ALL.getSize());
        BeinButton BTN_LIST_MENU = new BeinButton(PageElementModel.selectorNames.XPATH, "//ul[@class='user-links-menu']//a[text()= '" + menuName + "']");
        BTN_LIST_MENU.click();

    }

    public void checkMenuPage(String menuName) {
        LBL_PAGE_HEADER.waitUntilVisible();
        String pageHeader = LBL_PAGE_HEADER.getLabelText();
        if (!pageHeader.equals(menuName)) {
            error = "WRONG PAGE HEADER";
            log.error(error);
            throw new AutomationException(error);
        }
    }

    public void checkAccountMenuLevel(int menuLevel) {
        BTN_UserMenu.waitUntilVisible();
        BTN_UserMenu.hoverOn();
        int count = BTN_USER_ACCOUNT_MENU_ALL.getSize();
        if (count != menuLevel) {
            error = "WRONG MENU LEVEL SIZE " + count;
            log.error(error);
            throw new AutomationException(error);
        }
        log.info("Size: " + count);
    }

    public void checkLevelNameAccountList(String levelName) {
        BTN_UserMenu.waitUntilVisible();
        BTN_UserMenu.click();

        if (levelName.contains("Online İşlemler") || levelName.contains("Canlı Yardım")) {
            BeinLabel LBL_LIST_MENU = new BeinLabel(PageElementModel.selectorNames.XPATH, "//ul[@class='user-actions-menu']//a[text()= '" + levelName + "']");
            String labelName = LBL_LIST_MENU.getLabelText();
            if (!labelName.contains(levelName)) {
                error = "WRONG MENu NAME";
                log.error(error);
                throw new AutomationException(error);
            }
        } else {
            BeinButton BTN_LIST_MENU = new BeinButton(PageElementModel.selectorNames.XPATH, "//ul[@id='bc-nav-user-desktop']//a[@data-item-title='" + levelName + "']");
            BTN_LIST_MENU.waitUntilVisible();
            BTN_LIST_MENU.click();

        }
    }
    public void checkHeaderLevel(String menuName, int menuLevel) {
        BeinButton BTN_HEADER_MENU = new BeinButton(PageElementModel.selectorNames.XPATH, "//ul[@class='menu-main']//a[text()='" + menuName + "']");
        BTN_HEADER_MENU.waitUntilVisible();
        BTN_HEADER_MENU.hoverOn();
        BeinLabel lblAttirubut = new BeinLabel(PageElementModel.selectorNames.XPATH, "//ul[@class='menu-main']//a[text()='" + menuName + "']//..");
        String menuLineNumber = lblAttirubut.getAttribute("data-menu");
        BeinButton BTN_SUB_MENU = new BeinButton(PageElementModel.selectorNames.XPATH, "//div[@class='menu-detail' and @data-menu='" + menuLineNumber + "']//a");
        if (menuLevel == 0) {
            Boolean hasSubMenu = BTN_SUB_MENU.isDisplayed();
            if (hasSubMenu) {
                error = menuName + "have sub menu";
                log.error(error);
                throw new AutomationException(error);
            }
        } else {
            int count = BTN_SUB_MENU.getSize();
            if (count != menuLevel) {
                error = "Menu level don't true";
                log.error(error);
                throw new AutomationException(error);
            }
        }


    }

    public void checkUrlSlug(String slug) {
        String url = Driver.webDriver.getCurrentUrl();
        String[] arrOfStr = url.split("tr/", 2);
        if (!arrOfStr[1].equals(slug)) {
            error = "wrong url slug expected: " + slug + "happened: " + arrOfStr[1];
            log.error(error);
            throw new AutomationException(error);
        }
    }

    public void refreshPage() {
        Driver.webDriver.navigate().refresh();
    }

    public void waitPage() {
        BTN_SEARCH.waitFor(20);
    }

    public void affLogoClick() {
        if (BTN_AFF_LOGO.isDisplayed())
            BTN_AFF_LOGO.waitUntilVisibleAndClick();
    }

    public void acceptNetmeraPopup(){
        log.info("Allow netmera popup");
        try{
            BTN_NETMERA_POPUP_ALLOW.waitFor(5);
            Driver.webDriver.switchTo().frame(0);
            if (BTN_NETMERA_POPUP_ALLOW.isDisplayed()) {
                BTN_NETMERA_POPUP_ALLOW.waitUntilVisibleAndClick();
            }
            Driver.webDriver.switchTo().parentFrame();
        }catch (Exception e){
            log.info("DONT Change iframe");
        }




    }


    public void clickFirstContentCWL() {
        log.info("ENTERING ");
        int retryCount = 3;
        boolean isFound = false;
        while (!isFound && retryCount-- > 0) {
            try {
                BTN_FirstMovieCWL.waitUntilVisible(10);
                isFound = true;
                BTN_FirstMovieCWL.click();
            } catch (TimeoutException e) {
                PAGE_SCROLL.scrollPage();
               // Driver.webDriver.navigate().refresh();
            }
        }
        if (!isFound) {
            log.info("CONTENT NOT FOUNT CONTINUE WATCH LIST");
            throw new AutomationException("CONTENT NOT FOUNT CONTINUE WATCH LIST");
        }
    }
}

=end


