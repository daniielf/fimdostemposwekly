import 'package:share_plus/share_plus.dart';

class ShareManager {

  static final String baseTitle = "Veja o resumo do capítulo: \"";
  static final String baseDeeplink = "fdtweekly://";

  static void share(int arcIndex, int chapterIndex, String title) {
    Share.share(baseTitle + "$title\".\n" + baseDeeplink + "arc=$arcIndex&chapter=$chapterIndex");
  }
}