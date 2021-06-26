=begin
package com.dt.standalone.pages;

import com.amazonaws.services.dynamodbv2.document.Page;
import com.dt.standalone.backend.AutomationException;
import com.dt.standalone.pageElement.BeinButton;
import com.dt.standalone.pageElement.BeinLabel;
import com.dt.standalone.pageElement.PageElementModel;
import com.dt.standalone.utils.driver.Driver;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebElement;


public abstract class SbcMasterPage {
    private static final Log log = LogFactory.getLog(SbcMasterPage.class);
    public static String error;
    static BeinButton BTN_UserMenu = new BeinButton(PageElementModel.selectorNames.XPATH, "(//div[@class='bc-user-nav-desktop']//li[@class='bc-nav-item']/button)[2]");
    static BeinButton BTN_UserMenuResponsive = new BeinButton(PageElementModel.selectorNames.ID, "openNav-right");
    static BeinButton BTN_ListsMenu = new BeinButton(PageElementModel.selectorNames.XPATH, "(//div[@class='bc-user-nav-desktop']//button)[1]");
    static BeinButton BTN_Logout = new BeinButton(PageElementModel.selectorNames.XPATH, "//ul[@id='bc-nav-user-desktop']//a[@id=\"lnkLogOut\"]");
    static BeinButton BTN_LogoutResponsive = new BeinButton(PageElementModel.selectorNames.XPATH, "//ul[@class='navbar-nav']//a[contains(text(),'Çıkış')]");
    private static BeinButton BTN_MembershipInfo = new BeinButton(PageElementModel.selectorNames.XPATH, "(//ul[@id='bc-nav-user-desktop']//a[@href='/kullanici/uyelik-bilgileri'] )[1]");
    private static BeinButton BTN_MembershipInfoResponsive = new BeinButton(PageElementModel.selectorNames.XPATH, "//ul[@id='bcUserNavDesktop']//a[@data-item-title='Üyelik Bilgilerim']");
    private static BeinButton BTN_OnlineTransactions = new BeinButton(PageElementModel.selectorNames.ID, "lnkOnlineTransaction");
    private static BeinButton BTN_OnlineTransactionsResponsive = new BeinButton(PageElementModel.selectorNames.XPATH, "//ul[@id='bcUserNavDesktop']//a[@data-item-title='Online İşlemler']");
    private static BeinButton BTN_Favorites = new BeinButton(PageElementModel.selectorNames.XPATH, "//div[@class='bc-user-nav-desktop']//a[@data-item-title='Favorilerim']");
    private static BeinButton BTN_RecentlyPlayed = new BeinButton(PageElementModel.selectorNames.XPATH, "//div[@class='bc-user-nav-desktop']//a[@data-item-title='Son İzlediklerim']");
    private static BeinButton BTN_RentedContent = new BeinButton(PageElementModel.selectorNames.XPATH, "//div[@class='bc-user-nav-desktop']//a[@data-item-title='Kiraladıklarım']");
    private static BeinButton BTN_MyPurchases = new BeinButton(PageElementModel.selectorNames.XPATH, "//div[@class='bc-user-nav-desktop']//a[@data-item-title='Satın Aldıklarım']");
    private static BeinButton BTN_MenuResponsive = new BeinButton(PageElementModel.selectorNames.XPATH, "//div[@class='h-menu-left']//button");
    static BeinButton BTN_GoTop = new BeinButton(PageElementModel.selectorNames.ID, "gotop");
    private static BeinButton BTN_FilterSubMenu = new BeinButton(PageElementModel.selectorNames.XPATH, "//div[@class='tab-category-selection']");
    private static BeinLabel LBL_Loading = new BeinLabel(PageElementModel.selectorNames.ID, "loading");

    private static BeinButton BTN_ContinueToBeinConnect = new BeinButton(PageElementModel.selectorNames.XPATH, "//button[contains(text(),'Anasayfa')]");
    private static BeinButton BTN_HomepageLogo = new BeinButton(PageElementModel.selectorNames.XPATH, "//a[@data-dt-gtm='menu-logo']");
    private static BeinButton BTN_ChildMode = new BeinButton(PageElementModel.selectorNames.ID, "menuChildMode");
    private static BeinButton BTN_DISCOVER_CONTENT = new BeinButton(PageElementModel.selectorNames.ID, "bc-btn-mega-nav-trigger");
    private static BeinButton BTN_MY_ACCOUNT = new BeinButton(PageElementModel.selectorNames.XPATH, "//li[@class='bc-nav-item']//button[@class='nav-btn btn btn-ghost']");

    public void selectTabAndSubMenu(String tabName, String subMenu) {
        BTN_MY_ACCOUNT.waitFor(15);
        BeinButton BTN_Tab = new BeinButton(PageElementModel.selectorNames.XPATH, "(//a[@data-item-title='" + tabName + "'])[1]");
        BeinButton BTN_SubMenu = new BeinButton(PageElementModel.selectorNames.XPATH, "");
        if (subMenu.equals("Betimleme")) {
            if (tabName.equals("FİLM")) {
                BTN_SubMenu = new BeinButton(PageElementModel.selectorNames.XPATH, "(//a[@data-item-title='" + subMenu + "'])[1]");
            } else {
                BTN_SubMenu = new BeinButton(PageElementModel.selectorNames.XPATH, "(//a[@data-item-title='" + subMenu + "'])[2]");
            }

        } else if (subMenu.equals("Belgesel")) {
            if (tabName.equals("CANLI TV")) {
                BTN_SubMenu = new BeinButton(PageElementModel.selectorNames.XPATH, "(//a[@data-item-title='" + subMenu + "'])[1]");
            } else {
                BTN_SubMenu = new BeinButton(PageElementModel.selectorNames.XPATH, "//a[@data-item-title='" + subMenu + "']");
            }
        } else {
            BTN_SubMenu = new BeinButton(PageElementModel.selectorNames.XPATH, "(//a[@data-item-title='" + subMenu + "'])[1]");
        }
        BTN_Tab.waitUntilVisible();
        BTN_Tab.hoverOn();
        BTN_SubMenu.waitUntilVisibleAndClick();


    }


    public void selectTabMenu(String tabMenu) {
        SbcHomePage.getInstance().affLogoClick();
        BeinButton BTN_Tab = new BeinButton(PageElementModel.selectorNames.XPATH, "//a[@data-item-title='" + tabMenu + "']");
        BTN_Tab.waitUntilVisibleAndClick();

    }

    public void selectTabMenuLogout(String tabMenu) {
        SbcHomePage.getInstance().affLogoClick();
        BTN_DISCOVER_CONTENT.waitUntilVisibleAndClick();
        BeinButton BTN_Tab = new BeinButton(PageElementModel.selectorNames.XPATH, "//a[@data-item-title='" + tabMenu + "']");
        BTN_Tab.waitUntilVisibleAndClick();

    }

    public void selectTabMenuFromPage(String tabMenu) {
        JavascriptExecutor js = (JavascriptExecutor) Driver.webDriver;
        log.info("Choose selectTabMenuFromPage");
        WebElement BTN_Tab = Driver.webDriver.findElement(By.xpath("//a[@data-item-title='" + tabMenu + "']"));
        js.executeScript("arguments[0].scrollIntoView();", BTN_Tab);
        js.executeScript("arguments[0].click();", BTN_Tab);
    }

    public void dontShowHeaderMenu(String tabMenu) {
        BTN_MenuResponsive.waitFor(2);
        BTN_MenuResponsive.waitUntilLoad();
        BeinButton BTN_Tab;
        if (BTN_MenuResponsive.isDisplayed()) {
            BTN_MenuResponsive.clickAndWait(1);
            BTN_Tab = new BeinButton(PageElementModel.selectorNames.XPATH, "//li[@class='nav-item']//a[normalize-space(text())='" + tabMenu + "']");

        } else {
            BTN_Tab = new BeinButton(PageElementModel.selectorNames.XPATH, "//a[text()='" + tabMenu + "']");
        }
        if (BTN_Tab.isDisplayed()) {
            error = tabMenu + " is display";
            log.error(error);
            throw new AutomationException(error);
        }
    }

    public void selectBoxOfficeTab() {

        BeinButton BTN_Tab = new BeinButton(PageElementModel.selectorNames.XPATH, "//nav[@class='bc-nav-desktop']//a[@data-item-title='BOX OFFICE']");
        BTN_Tab.waitUntilVisibleAndClick();

    }

    public void waitForScreenMessage(String message) {
        log.info("Check blackout cancel message");
        BeinLabel LBL_ScreenMesssage = new BeinLabel(PageElementModel.selectorNames.XPATH, "//div[contains(text(),'" + message + "')]");
        LBL_ScreenMesssage.waitUntilVisible();
        LBL_ScreenMesssage.waitFor(2);
    }

    public void waitForcheckPPVBlackoutCancelMessage(String message){
        log.info("Check blackout cancel message");
        BeinLabel LBL_ScreenMesssage = new BeinLabel(PageElementModel.selectorNames.XPATH, "//span[contains(text(),'" + message + "')]");
        LBL_ScreenMesssage.waitUntilVisible();
    }

    public void goToMembershipInfo() {
        BTN_UserMenu.waitUntilVisibleAndClick();
        BTN_MembershipInfo.waitUntilVisibleAndClick();

    }

    public void validateOnlineTrx() {
        BTN_UserMenu.waitUntilVisible();
        BTN_UserMenu.hoverOn();
        BTN_OnlineTransactions.waitUntilVisible();

    }

    public void goToFavorites() {
        BTN_ListsMenu.waitUntilVisibleAndClick();
        BTN_Favorites.waitUntilVisibleAndClick();
    }

    public void goToRecentlyPlayed() {
        BTN_ListsMenu.waitUntilVisibleAndClick();
        BTN_RecentlyPlayed.waitUntilVisibleAndClick();
    }

    public void goToRentedContent() {
        BTN_ListsMenu.waitUntilVisibleAndClick();
        BTN_RentedContent.waitUntilVisibleAndClick();
    }

    public void goToMyPurchases() {
        BTN_ListsMenu.waitUntilVisibleAndClick();
        BTN_MyPurchases.waitUntilVisibleAndClick();
    }

    protected void waitLoadingToDisappear() {
        try {
            LBL_Loading.waitUntilVisible();
            LBL_Loading.waitUntilInvisible();
        } catch (TimeoutException e) {
            log.error(e.getMessage());
        }
    }

    public void clickContinueToBeinConnect() {
        log.info("ENTERING clickContinueToBeinConnect");
        BTN_ContinueToBeinConnect.waitUntilVisible();
        BTN_ContinueToBeinConnect.click();
        log.info("Tıklandı");
    }

    public void checkMatchStartPageOpened() {
        String currentUrl = Driver.webDriver.getCurrentUrl();
        if (currentUrl.contains("mac-basliyor")) {
            clickContinueToBeinConnect();
        }
    }


    public void clickHomepageLogo() {
        BTN_HomepageLogo.waitUntilVisibleAndClick();
    }

    public void hoverOnMyAccount() {
        log.info("Hover on my account");
        BTN_UserMenu.waitUntilVisible();
        BTN_UserMenu.click();
    }

    public void clickToChildMode() {
        log.info("Click to child mode");
        BTN_ChildMode.waitUntilVisibleAndClick();
    }

    public void hoverOnAffMyAccount() {
        log.info("Hover on my account");
        BTN_MY_ACCOUNT.waitUntilVisible();
        BTN_MY_ACCOUNT.hoverOn();
    }

    public void goToAccountInformation() {
        log.info("Click to account information from my account");
        BTN_MY_ACCOUNT.waitUntilVisibleAndClick();
    }


}


=end
