class Home_Page

  def initialize
    super
    @BTN_AFF_LOGO5 = "//div[@class='aff-logo']//a"
    @LBL_FavouriteModulMessage = "//div[@class='content-slider-async-favourite']//p"
    @BTN_SEARCH =  'bc-btn-search'
    @BTN_SEARCH_LOGIN =  'bc-btn-search'
    @TXT_SEARCH = 'bc-input-search'
    @BTN_FAVOURITE_CONTENT ="(//div[@class='container favourite-slider pt30']//a[@class='swiper-slide-item'])[1]"
    @LBL_CONTENT_HEADER = "//h1[@class='content-header']"
    @BTN_PAGE_FAVOURITE_CONTENT =  "((//a[@href='/favorilerim'])[3]//..//..//..//a)[3]"
    @LBL_FAV_MESSAGE_CONTENT_PAGE =  "//div[@class='nodata-content']"
    @LBL_PAGE_HEADER = '//h4'
    @BTN_USER_LIST_MENU_ALL = "//ul[@class='user-links-menu']//li"
    @BTN_USER_ACCOUNT_MENU_ALL = "//ul[@class='user-actions-menu']//li"
    @LBL_QUICKSEARCH_INFO =  "//div[@id='bc-search-results']//div"
    @BTN_FirstMovieCWL = "(//a[@data-component-info='sushi/İzlemeye Devam Et'])[1]"
    @PAGE_SCROLL  = ''
    @BTN_NETMERA_POPUP_ALLOW = 'btn-allow'
  end
  
  def navigateHomepage
    visit '/mac-basliyor'
  end

  def login_successfully
    fill_in(@BTN_AFF_LOGO5, 'abc')
  end

end
