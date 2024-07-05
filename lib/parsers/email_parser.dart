import 'package:flatsharing_linkable/shared/constants.dart';
import 'package:flatsharing_linkable/types/link.dart';
import 'package:flatsharing_linkable/parsers/parser.dart';

class EmailParser implements Parser {
  String text;

  EmailParser(this.text);

  @override
  parse() {
    String pattern = r"[\w-\.]+@([\w-]+\.)+[\w-]{2,4}";

    RegExp regExp = RegExp(pattern);

    Iterable<RegExpMatch> allMatches = regExp.allMatches(text);
    List<Link> links = <Link>[];
    for (RegExpMatch match in allMatches) {
      links.add(Link(regExpMatch: match, type: email));
    }
    return links;
  }
}
