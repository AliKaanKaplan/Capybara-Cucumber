#package com.dt.standalone.pages;
# import com.dt.standalone.backend.AutomationException;
# import com.dt.standalone.backend.DtAutomationContext;
# import com.dt.standalone.model.VoucherCode;
# import com.dt.standalone.pageElement.BeinButton;
# import com.dt.standalone.pageElement.BeinLabel;
# import com.dt.standalone.pageElement.BeinTextBox;
# import com.dt.standalone.pageElement.PageElementModel;
# import com.dt.standalone.utils.WebService.RestVoucherService;
# import org.apache.commons.logging.Log;
# import org.apache.commons.logging.LogFactory;
# import java.util.HashMap;
# import java.util.Map;
#
#
# public class SbcVoucherPage extends SbcMasterPage {
#
#     private static final Log log = LogFactory.getLog(SbcVoucherPage.class);
#     private static String error;
#     private static SbcVoucherPage instance;
#     private static  BeinTextBox TXT_VOUCHER_CODE = new BeinTextBox(PageElementModel.selectorNames.ID,"promotionCode");
#     private static BeinButton BTN_SHOW_VOUCHER_CODE= new BeinButton(PageElementModel.selectorNames.ID,"promotionBtn");
#     private static BeinLabel LBL_ERROR = new BeinLabel(PageElementModel.selectorNames.XPATH,"//div[@class='error-message txt-left']");
#     private static BeinButton BTN_VOUCHER_CODE_LINK_FOOTER = new BeinButton(PageElementModel.selectorNames.XPATH,"//footer[@class='bc-footer']//a[text()='Kupon Kodu']");
#     private static BeinLabel LBL_PROMOTION_PRICE = new BeinLabel(PageElementModel.selectorNames.XPATH,"((//div[@class='part part-price']//div)[2]//div)[2]");
#     private static BeinButton BTN_ADD_BASKET = new BeinButton(PageElementModel.selectorNames.XPATH,"//a[@class='link-area']");
#     private static BeinButton BTN_FreeTrialBuy = new BeinButton(PageElementModel.selectorNames.ID, "btnBuy");
#     private static BeinLabel LBL_PRICE_TEXT = new BeinLabel(PageElementModel.selectorNames.XPATH,"//input[@id='btnBuy']//..//p");
#
#     public static synchronized SbcVoucherPage getInstance() {
#         if (instance == null)
#             instance = new SbcVoucherPage();
#         return instance;
#     }
#
#
#     public void enterVoucherCode(String type){
#         Map<String,String> queryParams = new HashMap<String,String>();
#         if (type.equals("isNotUsed")) {
#             queryParams.put("isUsed","false");
#         }
#         else{
#             queryParams.put("isUsed","true");
#         }
#         if(!type.equals("entered")){
#             queryParams.put("countryCode", "TR");
#             VoucherCode voucherCode = RestVoucherService.getInstance().getVoucherCode(queryParams);
#             DtAutomationContext.setVoucherCode(voucherCode);
#         }
#         log.info("ENTER VOUCHER CODE: " + DtAutomationContext.getVoucherCode().getVoucherCode());
#         TXT_VOUCHER_CODE.waitUntilVisibleAndType(DtAutomationContext.getVoucherCode().getVoucherCode());
#         BTN_SHOW_VOUCHER_CODE.waitUntilVisibleAndClick();
#         setUserVoucherPage();
#     }
#
#     public void clickPromation(String catalog, String price){
#         log.info("Click promation catalog name: " + catalog + "price: "+ price);
#         LBL_PROMOTION_PRICE.waitUntilVisible(5);
#         String promotionPrice  = LBL_PROMOTION_PRICE.getLabelText();
#         if(!promotionPrice.equals(price)){
#             log.error("Promotion price wrong");
#             throw new AutomationException("Promotion price wrong");
#         }
#         BTN_ADD_BASKET.waitUntilVisibleAndClick();
#     }
#
#
#     public void checkErrorMessage(String message){
#         LBL_ERROR.waitFor(5);
#         LBL_ERROR.waitUntilVisible(8);
#         String errorMessage = LBL_ERROR.getLabelText();
#         if(!errorMessage.equals(message)){
#             errorMessage = "Used message not found page message: " +errorMessage;
#             log.error(errorMessage);
#             throw new AutomationException(errorMessage);
#         }
#     }
#
#     public void setUserVoucherPage(){
#         log.info("UPDATE VOUCHER CODE isUsed TRUE");
#        RestVoucherService.getInstance().putVoucherCode("true");
#     }
#
#     public void clickToVoucherOnFooter(){
#         log.info("CLICK TO FOOTER LINK ON FOOTER");
#         BTN_VOUCHER_CODE_LINK_FOOTER.waitUntilVisibleAndClick();
#     }
#
#     public void BuyPackageWithWoucherCode(){
#         log.info("BUY PACKAGE WITH VOUCHER CODE");
#         LBL_PRICE_TEXT.waitUntilVisible();
#         String priceAll = LBL_PRICE_TEXT.getLabelText();
#         if(!priceAll.contains("0,00 TL")){
#             log.info("All price wrong");
#             throw new AutomationException("All price wrong");
#         }
#         BTN_FreeTrialBuy.waitUntilVisibleAndClick();
#
#     }
# }
# =