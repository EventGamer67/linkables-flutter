import 'package:flatsharing_linkable/shared/constants.dart';
import 'package:flatsharing_linkable/types/link.dart';
import 'package:flatsharing_linkable/parsers/parser.dart';

class FtpParser implements Parser {
  String text;

  FtpParser(this.text);

  @override
  parse() {
    String pattern =
        r"(ftp(s)?:\/\/)?(www.)?[a-zA-Z0-9]{2,256}\.[a-zA-Z0-9]{2,256}(\.[a-zA-Z0-9]{2,256})?([-a-zA-Z0-9@:%_\+~#?&//=.]*)([-a-zA-Z0-9@:%_\+~#?&//=]+)";

    RegExp regExp = RegExp(pattern, caseSensitive: false);

    Iterable<RegExpMatch> allMatches = regExp.allMatches(text);
    List<Link> links = <Link>[];
    for (RegExpMatch match in allMatches) {
      links.add(Link(regExpMatch: match, type: http));
    }
    return links;
  }
}