import 'package:flatsharing_linkable/shared/constants.dart';
import 'package:flatsharing_linkable/types/copyable.dart';
import 'package:flatsharing_linkable/parsers/parser.dart';

class CodeParser implements Parser {
  String text;

  CodeParser(this.text);

  @override
  parse() {
    String pattern = r"\b\d{4,8}\b";

    RegExp regExp = RegExp(pattern);

    Iterable<RegExpMatch> allMatches = regExp.allMatches(text);
    List<CopyAble> copyable = <CopyAble>[];
    for (RegExpMatch match in allMatches) {
      copyable.add(CopyAble(regExpMatch: match, type: tel));
    }
    return copyable;
  }
}
