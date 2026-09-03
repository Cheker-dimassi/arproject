import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Complete application strings localized for French, English, and Arabic.
class AppStrings {
  // Navigation & Core
  final String catalog;
  final String search;
  final String ar;
  final String cart;
  final String favorites;
  final String profile;

  // Catalog & Filters
  final String furniture;
  final String all;
  final String filter;
  final String featuredOnly;
  final String featuredBadge;
  final String placement;
  final String floor;
  final String wall;
  final String apply;
  final String sortRecent;
  final String sortNameAsc;
  final String sortPriceAsc;
  final String sortPriceDesc;
  final String sortFeatured;
  final String articlesCount;

  // Search
  final String searchHint;
  final String searchSubtitle;
  final String noResults;
  final String noResultsSubtitle;

  // Cart & Quotes
  final String myCart;
  final String cartSubtitle;
  final String emptyCart;
  final String emptyCartSubtitle;
  final String totalEstimated;
  final String requestGroupQuote;
  final String requestSingleQuote;
  final String addToCart;
  final String removeFromCart;
  final String inCart;

  // Admin Dashboard
  final String adminPortal;
  final String adminSubtitle;
  final String adminLoginTitle;
  final String adminLoginSubtitle;
  final String username;
  final String password;
  final String login;
  final String logout;
  final String loginError;
  final String statusUpdated;
  final String totalQuotes;
  final String pendingQuotes;
  final String inProgressQuotes;
  final String processedQuotes;
  final String filterAll;
  final String updateStatus;
  final String clientInfo;
  final String offlineModeNotice;
  // Quotes History
  final String myQuotes;
  final String quotesSubtitle;
  final String noQuotes;
  final String noQuotesSubtitle;
  final String statusSent;
  final String statusInProgress;
  final String statusProcessed;
  final String quoteNumber;
  final String exploreCatalog;
  // Quote Form
  final String quoteTitle;
  final String quoteArticles;
  final String fullName;
  final String email;
  final String phone;
  final String messageNotes;
  final String messageHint;
  final String sendQuote;
  final String quoteSent;
  final String fieldRequired;
  final String invalidEmail;
  final String invalidPhone;
  final String sending;

  // Article Details & AR
  final String dimensions;
  final String material;
  final String view3d;
  final String tapArHint;
  final String wallMounted;
  final String floorMounted;
  final String addToFavorites;
  final String removeFromFavorites;
  final String share;
  final String shareText;
  final String chooseArArticle;
  final String chooseArSubtitle;
  final String noArticlesAvailable;
  final String emptyCatalogSubtitle;

  // Favorites
  final String noFavorites;
  final String noFavoritesSubtitle;

  // Onboarding
  final String onboardingTitle1;
  final String onboardingBody1;
  final String onboardingTitle2;
  final String onboardingBody2;
  final String onboardingTitle3;
  final String onboardingBody3;
  final String getStarted;
  final String skip;

  // Profile & System
  final String language;
  final String about;
  final String aboutBody;
  final String loadError;
  final String retry;
  final String version;

  const AppStrings({
    required this.catalog,
    required this.search,
    required this.ar,
    required this.cart,
    required this.favorites,
    required this.profile,
    required this.furniture,
    required this.all,
    required this.filter,
    required this.featuredOnly,
    required this.featuredBadge,
    required this.placement,
    required this.floor,
    required this.wall,
    required this.apply,
    required this.sortRecent,
    required this.sortNameAsc,
    required this.sortPriceAsc,
    required this.sortPriceDesc,
    required this.sortFeatured,
    required this.articlesCount,
    required this.searchHint,
    required this.searchSubtitle,
    required this.noResults,
    required this.noResultsSubtitle,
    required this.myCart,
    required this.cartSubtitle,
    required this.emptyCart,
    required this.emptyCartSubtitle,
    required this.totalEstimated,
    required this.requestGroupQuote,
    required this.requestSingleQuote,
    required this.addToCart,
    required this.removeFromCart,
    required this.inCart,
    required this.adminPortal,
    required this.adminSubtitle,
    required this.adminLoginTitle,
    required this.adminLoginSubtitle,
    required this.username,
    required this.password,
    required this.login,
    required this.logout,
    required this.loginError,
    required this.statusUpdated,
    required this.totalQuotes,
    required this.pendingQuotes,
    required this.inProgressQuotes,
    required this.processedQuotes,
    required this.filterAll,
    required this.updateStatus,
    required this.clientInfo,
    required this.offlineModeNotice,
    required this.myQuotes,
    required this.quotesSubtitle,
    required this.noQuotes,
    required this.noQuotesSubtitle,
    required this.statusSent,
    required this.statusInProgress,
    required this.statusProcessed,
    required this.quoteNumber,
    required this.exploreCatalog,
    required this.quoteTitle,
    required this.quoteArticles,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.messageNotes,
    required this.messageHint,
    required this.sendQuote,
    required this.quoteSent,
    required this.fieldRequired,
    required this.invalidEmail,
    required this.invalidPhone,
    required this.sending,
    required this.dimensions,
    required this.material,
    required this.view3d,
    required this.tapArHint,
    required this.wallMounted,
    required this.floorMounted,
    required this.addToFavorites,
    required this.removeFromFavorites,
    required this.share,
    required this.shareText,
    required this.chooseArArticle,
    required this.chooseArSubtitle,
    required this.noArticlesAvailable,
    required this.emptyCatalogSubtitle,
    required this.noFavorites,
    required this.noFavoritesSubtitle,
    required this.onboardingTitle1,
    required this.onboardingBody1,
    required this.onboardingTitle2,
    required this.onboardingBody2,
    required this.onboardingTitle3,
    required this.onboardingBody3,
    required this.getStarted,
    required this.skip,
    required this.language,
    required this.about,
    required this.aboutBody,
    required this.loadError,
    required this.retry,
    required this.version,
  });
}

const _fr = AppStrings(
  catalog: 'Catalogue',
  search: 'Recherche',
  ar: 'AR',
  cart: 'Panier',
  favorites: 'Favoris',
  profile: 'Profil',
  furniture: 'Mobilier',
  all: 'Tout',
  filter: 'Filtrer',
  featuredOnly: 'Vedette uniquement',
  featuredBadge: 'Vedette',
  placement: 'Placement',
  floor: 'Sol',
  wall: 'Mur',
  apply: 'Appliquer',
  sortRecent: 'Récents',
  sortNameAsc: 'Nom (A-Z)',
  sortPriceAsc: 'Prix croissant',
  sortPriceDesc: 'Prix décroissant',
  sortFeatured: "Vedette d'abord",
  articlesCount: 'articles',
  searchHint: 'Rechercher par nom, matière...',
  searchSubtitle: 'Trouvez rapidement un meuble par son nom ou son matériau.',
  noResults: 'Aucun résultat',
  noResultsSubtitle: 'Essayez un autre mot-clé ou réinitialisez la recherche.',
  myCart: 'Mon panier',
  cartSubtitle: 'Regroupez plusieurs articles dans une seule demande de devis.',
  emptyCart: 'Votre panier est vide',
  emptyCartSubtitle: 'Ajoutez des articles depuis le catalogue pour demander un devis groupé.',
  totalEstimated: 'Total estimé',
  requestGroupQuote: 'Demander un devis groupé',
  requestSingleQuote: 'Demander un devis',
  addToCart: 'Ajouter au panier',
  removeFromCart: 'Retirer du panier',
  inCart: 'Dans le panier',
  adminPortal: 'Espace Administrateur',
  adminSubtitle: 'Gerez les demandes de devis et le suivi des clients.',
  adminLoginTitle: 'Connexion Admin',
  adminLoginSubtitle: 'Entrez vos identifiants pour acceder au tableau de bord.',
  username: 'Nom d\'utilisateur',
  password: 'Mot de passe',
  login: 'Se connecter',
  logout: 'Deconnexion',
  loginError: 'Identifiants invalides ou serveur inaccessible.',
  statusUpdated: 'Statut du devis mis a jour avec succes.',
  totalQuotes: 'Total devis',
  pendingQuotes: 'En attente',
  inProgressQuotes: 'En cours',
  processedQuotes: 'Traites',
  filterAll: 'Tous',
  updateStatus: 'Modifier le statut',
  clientInfo: 'Informations client',
  offlineModeNotice: 'Catalogue hors ligne (mode cache)',
  myQuotes: 'Mes devis',
  quotesSubtitle: 'Consultez le statut et les details de vos demandes de devis.',
  noQuotes: 'Aucun devis envoye',
  noQuotesSubtitle: 'Vos demandes de devis apparaitront ici apres leur envoi.',
  statusSent: 'Envoye',
  statusInProgress: 'En cours',
  statusProcessed: 'Traite',
  quoteNumber: 'Devis n°',
  exploreCatalog: 'Explorer le catalogue',
  quoteTitle: 'Demande de devis',
  quoteArticles: 'Articles concernés',
  fullName: 'Nom complet *',
  email: 'Email *',
  phone: 'Téléphone *',
  messageNotes: 'Message / Précisions',
  messageHint: 'Dimensions spéciales, coloris souhaité, adresse de livraison...',
  sendQuote: 'Envoyer la demande',
  quoteSent: 'Demande envoyée ! Nous vous recontactons vite.',
  fieldRequired: 'Ce champ est obligatoire',
  invalidEmail: 'Veuillez saisir un email valide',
  invalidPhone: 'Veuillez saisir un numéro de téléphone valide',
  sending: 'Envoi en cours...',
  dimensions: 'Dimensions',
  material: 'Matériau',
  view3d: 'Visualisation 3D',
  tapArHint: "Touchez l'icône AR ci-dessous",
  wallMounted: 'Se pose au mur',
  floorMounted: 'Se pose au sol',
  addToFavorites: 'Ajouter aux favoris',
  removeFromFavorites: 'Retirer des favoris',
  share: 'Partager',
  shareText: 'Découvrez ce meuble sur Smart Room',
  chooseArArticle: 'Visualiser en AR',
  chooseArSubtitle: 'Choisissez un article à poser dans votre pièce.',
  noArticlesAvailable: 'Aucun article disponible',
  emptyCatalogSubtitle: 'Le catalogue est vide pour le moment.',
  noFavorites: 'Aucun favori pour le moment',
  noFavoritesSubtitle: "Appuyez sur le cœur d'un article pour le retrouver ici.",
  onboardingTitle1: 'Bienvenue sur Smart Room',
  onboardingBody1: 'Explorez notre catalogue de mobilier haut de gamme directement depuis votre smartphone.',
  onboardingTitle2: 'Visualisez en Réalité Augmentée',
  onboardingBody2: "Placez virtuellement n'importe quel meuble dans votre pièce à l'échelle réelle avant d'acheter.",
  onboardingTitle3: 'Demandez un devis sur mesure',
  onboardingBody3: 'Trouvé votre meuble idéal ? Obtenez votre devis direct en un tap, sans inscription requise.',
  getStarted: 'Commencer',
  skip: 'Passer',
  language: 'Langue',
  about: 'À propos',
  aboutBody: "Smart Room vous permet d'explorer et d'essayer virtuellement du mobilier en Réalité Augmentée avant toute commande. Aucun compte n'est requis pour parcourir le catalogue ou demander un devis.",
  loadError: 'Impossible de joindre le serveur',
  retry: 'Réessayer',
  version: 'Version',
);

const _en = AppStrings(
  catalog: 'Catalog',
  search: 'Search',
  ar: 'AR',
  cart: 'Cart',
  favorites: 'Favorites',
  profile: 'Profile',
  furniture: 'Furniture',
  all: 'All',
  filter: 'Filter',
  featuredOnly: 'Featured only',
  featuredBadge: 'Featured',
  placement: 'Placement',
  floor: 'Floor',
  wall: 'Wall',
  apply: 'Apply',
  sortRecent: 'Recent',
  sortNameAsc: 'Name (A-Z)',
  sortPriceAsc: 'Price: Low to High',
  sortPriceDesc: 'Price: High to Low',
  sortFeatured: 'Featured first',
  articlesCount: 'items',
  searchHint: 'Search by name, material...',
  searchSubtitle: 'Quickly find furniture by name, style or material.',
  noResults: 'No results found',
  noResultsSubtitle: 'Try another keyword or clear your search query.',
  myCart: 'My Cart',
  cartSubtitle: 'Group multiple items in a single quote request.',
  emptyCart: 'Your cart is empty',
  emptyCartSubtitle: 'Add items from the catalog to request a grouped quote.',
  totalEstimated: 'Estimated Total',
  requestGroupQuote: 'Request Group Quote',
  requestSingleQuote: 'Request a Quote',
  addToCart: 'Add to cart',
  removeFromCart: 'Remove from cart',
  inCart: 'In cart',
  adminPortal: 'Admin Portal',
  adminSubtitle: 'Manage customer quote requests and tracking.',
  adminLoginTitle: 'Admin Login',
  adminLoginSubtitle: 'Enter your credentials to access the merchant dashboard.',
  username: 'Username',
  password: 'Password',
  login: 'Sign In',
  logout: 'Sign Out',
  loginError: 'Invalid credentials or server unreachable.',
  statusUpdated: 'Quote status updated successfully.',
  totalQuotes: 'Total Quotes',
  pendingQuotes: 'Pending',
  inProgressQuotes: 'In Review',
  processedQuotes: 'Processed',
  filterAll: 'All',
  updateStatus: 'Change Status',
  clientInfo: 'Customer Information',
  offlineModeNotice: 'Offline catalog (cached)',
  myQuotes: 'My Quotes',
  quotesSubtitle: 'Check the status and details of your quote requests.',
  noQuotes: 'No quotes submitted yet',
  noQuotesSubtitle: 'Your quote requests will appear here once submitted.',
  statusSent: 'Submitted',
  statusInProgress: 'In Review',
  statusProcessed: 'Processed',
  quoteNumber: 'Quote #',
  exploreCatalog: 'Explore Catalog',
  quoteTitle: 'Quote Request',
  quoteArticles: 'Selected Items',
  fullName: 'Full Name *',
  email: 'Email Address *',
  phone: 'Phone Number *',
  messageNotes: 'Message / Details',
  messageHint: 'Custom dimensions, preferred color, delivery location...',
  sendQuote: 'Submit Request',
  quoteSent: 'Request submitted! We will contact you shortly.',
  fieldRequired: 'This field is required',
  invalidEmail: 'Please enter a valid email address',
  invalidPhone: 'Please enter a valid phone number',
  sending: 'Sending...',
  dimensions: 'Dimensions',
  material: 'Material',
  view3d: '3D Visualization',
  tapArHint: 'Tap the AR icon below to view in room',
  wallMounted: 'Wall mounted',
  floorMounted: 'Floor standing',
  addToFavorites: 'Add to favorites',
  removeFromFavorites: 'Remove from favorites',
  share: 'Share',
  shareText: 'Check out this furniture on Smart Room',
  chooseArArticle: 'View in AR',
  chooseArSubtitle: 'Choose an item to place in your room.',
  noArticlesAvailable: 'No items available',
  emptyCatalogSubtitle: 'The catalog is currently empty.',
  noFavorites: 'No favorites yet',
  noFavoritesSubtitle: 'Tap the heart on any item to save it here.',
  onboardingTitle1: 'Welcome to Smart Room',
  onboardingBody1: 'Explore our premium furniture collection right from your smartphone.',
  onboardingTitle2: 'Visualize in Augmented Reality',
  onboardingBody2: 'Virtually place any furniture in your room at true-to-life scale before buying.',
  onboardingTitle3: 'Instant Quote Requests',
  onboardingBody3: 'Found your ideal piece? Get an instant quote in one tap, no sign-up required.',
  getStarted: 'Get Started',
  skip: 'Skip',
  language: 'Language',
  about: 'About',
  aboutBody: 'Smart Room lets you explore and preview luxury furniture in Augmented Reality right in your space. No account is required to browse or submit quote requests.',
  loadError: 'Unable to connect to server',
  retry: 'Retry',
  version: 'Version',
);

const _ar = AppStrings(
  catalog: 'الكتالوج',
  search: 'بحث',
  ar: 'واقع معزز',
  cart: 'السلة',
  favorites: 'المفضلة',
  profile: 'حسابي',
  furniture: 'الأثاث',
  all: 'الكل',
  filter: 'تصفية',
  featuredOnly: 'المميز فقط',
  featuredBadge: 'مميز',
  placement: 'الموضع',
  floor: 'أرضي',
  wall: 'جداري',
  apply: 'تطبيق',
  sortRecent: 'الأحدث',
  sortNameAsc: 'الاسم (أ-ي)',
  sortPriceAsc: 'السعر: من الأقل للأعلى',
  sortPriceDesc: 'السعر: من الأعلى للأقل',
  sortFeatured: 'المميز أولاً',
  articlesCount: 'عناصر',
  searchHint: 'ابحث بالاسم أو الخامة أو الفئة...',
  searchSubtitle: 'اعثر بسرعة على قطع الأثاث المناسبة لذوقك.',
  noResults: 'لا توجد نتائج مطابقة',
  noResultsSubtitle: 'جرب البحث بكلمة أخرى أو أفرغ خانة البحث.',
  myCart: 'سلتي',
  cartSubtitle: 'اجمع عدة قطع في طلب عرض سعر موحد بكل سهولة.',
  emptyCart: 'السلة فارغة حالياً',
  emptyCartSubtitle: 'أضف قطعاً من الكتالوج لطلب عرض سعر مجمع.',
  totalEstimated: 'المجموع التقديري',
  requestGroupQuote: 'طلب عرض سعر للمجموعة',
  requestSingleQuote: 'طلب عرض سعر',
  addToCart: 'أضف إلى السلة',
  removeFromCart: 'إزالة من السلة',
  inCart: 'في السلة',
  adminPortal: 'لوحة الإدارة',
  adminSubtitle: 'إدارة وتتبع طلبات عروض أسعار العملاء.',
  adminLoginTitle: 'تسجيل دخول المشرف',
  adminLoginSubtitle: 'أدخل بيانات الاعتماد للوصول إلى لوحة التحكم.',
  username: 'اسم المستخدم',
  password: 'كلمة المرور',
  login: 'تسجيل الدخول',
  logout: 'تسجيل الخروج',
  loginError: 'بيانات غير صحيحة أو يتعذر الاتصال بالخادم.',
  statusUpdated: 'تم تحديث حالة الطلب بنجاح.',
  totalQuotes: 'إجمالي الطلبات',
  pendingQuotes: 'قيد الانتظار',
  inProgressQuotes: 'قيد المراجعة',
  processedQuotes: 'المكتملة',
  filterAll: 'الكل',
  updateStatus: 'تعديل الحالة',
  clientInfo: 'بيانات العميل',
  offlineModeNotice: 'الكتالوج محفوظ (وضع عدم الاتصال)',
  myQuotes: 'طلباتي',
  quotesSubtitle: 'تابع حالة وتفاصيل طلبات عروض الأسعار الخاصة بك.',
  noQuotes: 'لا توجد طلبات حتى الآن',
  noQuotesSubtitle: 'ستظهر جميع طلبات عروض الأسعار هنا بعد إرسالها.',
  statusSent: 'تم الإرسال',
  statusInProgress: 'قيد المراجعة',
  statusProcessed: 'تمت المعالجة',
  quoteNumber: 'طلب رقم #',
  exploreCatalog: 'تصفح الكتالوج',
  quoteTitle: 'طلب عرض سعر',
  quoteArticles: 'القطع المختارة',
  fullName: 'الاسم الكامل *',
  email: 'البريد الإلكتروني *',
  phone: 'رقم الهاتف *',
  messageNotes: 'ملاحظات / تفاصيل إضافية',
  messageHint: 'مقاسات خاصة، اللون المفضل، عنوان التوصيل...',
  sendQuote: 'إرسال الطلب',
  quoteSent: 'تم إرسال طلبك بنجاح! سنتواصل معك قريباً.',
  fieldRequired: 'هذا الحقل مطلوب',
  invalidEmail: 'يرجى إدخال بريد إلكتروني صالح',
  invalidPhone: 'يرجى إدخال رقم هاتف صالح',
  sending: 'جاري الإرسال...',
  dimensions: 'الأبعاد',
  material: 'الخامة',
  view3d: 'معاينة ثلاثية الأبعاد',
  tapArHint: 'اضغط أيقونة AR أدناه للمعاينة داخل الغرفة',
  wallMounted: 'يثبت على الجدار',
  floorMounted: 'يوضع على الأرض',
  addToFavorites: 'أضف للمفضلة',
  removeFromFavorites: 'إزالة من المفضلة',
  share: 'مشاركة',
  shareText: 'اكتشف هذا الأثاث الرائع على Smart Room',
  chooseArArticle: 'معاينة في الواقع المعزز',
  chooseArSubtitle: 'اختر قطعة أثاث لتجربتها مباشرة في غرفتك.',
  noArticlesAvailable: 'لا توجد قطع متاحة',
  emptyCatalogSubtitle: 'الكتالوج فارغ في الوقت الحالي.',
  noFavorites: 'قائمة المفضلة فارغة',
  noFavoritesSubtitle: 'اضغط على القلب لحفظ أي قطعة تهمك هنا.',
  onboardingTitle1: 'مرحباً بك في Smart Room',
  onboardingBody1: 'استكشف تشكيلتنا الفاخرة من الأثاث العصري مباشرة من هاتفك.',
  onboardingTitle2: 'شاهد بالواقع المعزز',
  onboardingBody2: 'ضع أي قطعة أثاث داخل غرفتك بأبعادها الحقيقية قبل اتخاذ قرار الشراء.',
  onboardingTitle3: 'طلب عرض سعر فوري',
  onboardingBody3: 'وجدت القطعة المناسبة؟ اطلب سعرك بنقرة واحدة بدون الحاجة لإنشاء حساب.',
  getStarted: 'ابدأ الآن',
  skip: 'تخطي',
  language: 'اللغة',
  about: 'حول التطبيق',
  aboutBody: 'يتيح لك تطبيق Smart Room تجربة واستعراض الأثاث الفاخر في مساحتك الخاصة بتقنية الواقع المعزز. لا يشترط أي حساب لتصفح الكتالوج أو طلب عروض الأسعار.',
  loadError: 'تعذر الاتصال بالخادم',
  retry: 'إعادة المحاولة',
  version: 'الإصدار',
);

enum AppLanguage { fr, en, ar }

class AppL10n {
  static final ValueNotifier<AppLanguage> notifier = ValueNotifier<AppLanguage>(AppLanguage.fr);
  static AppLanguage get currentLanguage => notifier.value;

  static AppStrings get s {
    switch (notifier.value) {
      case AppLanguage.fr:
        return _fr;
      case AppLanguage.en:
        return _en;
      case AppLanguage.ar:
        return _ar;
    }
  }

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('app_language');
    if (saved != null) {
      for (final l in AppLanguage.values) {
        if (l.name == saved) {
          notifier.value = l;
          break;
        }
      }
    }
  }

  static Future<void> setLanguage(AppLanguage lang) async {
    notifier.value = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', lang.name);
  }

  static String get languageName {
    switch (notifier.value) {
      case AppLanguage.fr:
        return 'Français';
      case AppLanguage.en:
        return 'English';
      case AppLanguage.ar:
        return 'العربية';
    }
  }
}
