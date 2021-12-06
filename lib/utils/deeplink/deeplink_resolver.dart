class DeeplinkResolver {

  static final String host = "fdtweekly://";
  static final chapterArgument = "chapter";
  static final arcArgument = "arc";
  static final argumentsDivisor = "&";
  static final valueDivisor = "=";

  static Map<String, int> getPath(String deeplink) {
    var dictionary = Map<String, int>();

    var parts = deeplink.split(host);
    if (parts.length <= 1) return dictionary;
    var arguments = parts[1];

    var parameters = arguments.split(argumentsDivisor);
    if (parameters.length <= 1) return dictionary;


    for (var part in parameters) {
      var argumentParts = part.split(valueDivisor);
      dictionary[argumentParts[0]] = int.parse(argumentParts[1]);
    }
    return dictionary;
  }
}