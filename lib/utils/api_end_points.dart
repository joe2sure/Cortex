class APIEndPoints {
  static const String appConfiguration = 'app-configuration';
  static const String aboutPages = 'page-list';
  //Auth & User
  static const String register = 'register';
  static const String socialLogin = 'social-login';
  static const String login = 'login';
  static const String logout = 'logout';
  static const String changePassword = 'change-password';
  static const String forgotPassword = 'forgot-password';
  static const String userDetail = 'user-detail';
  static const String updateProfile = 'update-profile';
  static const String deleteUserAccount = 'delete-account';
  static const String getNotification = 'notification-list';
  static const String removeNotification = 'notification-remove';
  static const String clearAllNotification = 'notification-deleteall';

  //TO Check limit for free plan based on ip address
  static const String checkDailyLimit = 'check-daily-limit';

  //TO Check limit based on current subscription
  static const String checkLimits = 'check-limits';

  //TO notify admin whenever openai,cutout.pro, picsart keys etc. needs recharge
  static const String rechargeReminder = 'recharge-reminder';

  //Dashboard
  static const String getDashboard = 'dashboard-detail';

  //History
  static const String getUserHistory = 'get-user-history';
  static const String clearUserHistory = 'clear-user-history';
  static const String saveHistory = 'save-history';
  static const String saveRecentChat = 'save-recent-chat';
  static const String editRecentChat = 'edit-recent-chat';
  static const String deleteRecentChat = 'delete-recent-chat';
  static const String saveMessage = 'save-message';
  static const String recentChatList = 'recent-chat-list';
  static const String messageList = 'message-list';

  //Report Or Flag
  static const String saveReportOrFlag = 'save-report-or-flag';

  //Category-list
  static const String categoryList = 'category-list';
  static const String customTemplateList = 'customtemplate-list';

  //Save Images to Database
  static const String uploadImages = 'upload-image';

  //OPEN AI
  static const String chatCompletions = 'v1/chat/completions';
  static const String imagesGenerations = 'v1/images/generations';
  static const String audioTranscriptions = 'v1/audio/transcriptions';

  //PICS ART
  static const String faceEnhance = 'https://api.picsart.io/tools/1.0/enhance/face';

  //PICS ART
  static const String photoEnhance = 'https://www.cutout.pro/api/v1/photoEnhance';

  //region Favourite
  static const String favouriteList = 'wishlist-list';
  static const String addToFavouriteList = 'add-wishlist';
  static const String removeFromFavouriteList = 'remove-wishlist';

  //endregion subscription plan

  static const String subscriptionPlanList = 'plans';
  static const String saveSubscriptionDetails = 'save-subscription-details';
  static const String userSubscriptionHistory = 'user-subscription-history';
  static const String cancleSubscription = 'cancel-subscription';

  //region
}
