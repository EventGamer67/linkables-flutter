// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flatsharing_linkable/parsers/codes_parser.dart';
import 'package:flatsharing_linkable/parsers/email_parser.dart';
import 'package:flatsharing_linkable/parsers/ftp_parser.dart';
import 'package:flatsharing_linkable/parsers/http_parser.dart';
import 'package:flatsharing_linkable/parsers/parser.dart';
import 'package:flatsharing_linkable/parsers/tel_parser.dart';
import 'package:flatsharing_linkable/shared/constants.dart';
import 'package:flatsharing_linkable/types/copyable.dart';
import 'package:flatsharing_linkable/types/interactable.dart';
import 'package:flatsharing_linkable/types/link.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Класс хранения стилей для использования в методе класса [LinkableTools] [LinkableTools.getLinkedTextSpan]
class LinkableStyle {
  final Color? textColor;
  final TextStyle? style;
  final TextStyle? copystyle;
  final TextStyle? linkstyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int? maxLines;
  final double? textScaleFactor;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  LinkableStyle({
    this.textColor,
    this.style,
    this.copystyle,
    this.linkstyle,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.textScaleFactor,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
  });
}

/// Класс инструментария для форматирования текста с поддержкой в них ссылок
abstract class LinkableTools {
  static TextSpan getLinkedTextSpan(String text, LinkableStyle style) {
    return TextSpan(
      text: '',
      style: style.style,
      children: _Converter(text: text, styles: style)._getTextSpans(),
    );
  }
}

//По хорошему надо вынести все преобразования отдельно, но пока для тестов просто скопировал
class _Converter {
  final List<Parser> _parsers = <Parser>[];
  final List<Interactable> _links = <Interactable>[];
  final String text;
  final LinkableStyle styles;
  late final TextStyle? copystyle;
  late final TextStyle? linkstyle;
  late final Color? textColor;

  _Converter({required this.text, required this.styles}) {
    linkstyle = styles.linkstyle;
    copystyle = styles.copystyle;
    textColor = styles.textColor;
    init();
  }

  init() {
    _addParsers();
    _parseLinks();
    _filterLinks();
  }

  _addParsers() {
    _parsers.add(EmailParser(text));
    _parsers.add(HttpParser(text));
    _parsers.add(FtpParser(text));
    _parsers.add(TelParser(text));
    _parsers.add(CodeParser(text));
  }

  _parseLinks() {
    for (Parser parser in _parsers) {
      _links.addAll(parser.parse().toList());
    }
  }

  //Не знаю что тут происходит, взял с либы Linkable
  _filterLinks() {
    _links.sort((Interactable a, Interactable b) =>
        a.regExpMatch.start.compareTo(b.regExpMatch.start));

    List<Interactable> filteredLinks = <Interactable>[];
    if (_links.isNotEmpty) {
      filteredLinks.add(_links[0]);
    }

    for (int i = 0; i < _links.length - 1; i++) {
      if (_links[i + 1].regExpMatch.start > _links[i].regExpMatch.end) {
        filteredLinks.add(_links[i + 1]);
      }
    }
    _links.clear();
    _links.addAll(filteredLinks);
  }

  _getTextSpans() {
    List<TextSpan> textSpans = <TextSpan>[];
    int i = 0;
    int pos = 0;
    while (i < text.length) {
      textSpans.add(_text(text.substring(
          i,
          pos < _links.length && i <= _links[pos].regExpMatch.start
              ? _links[pos].regExpMatch.start
              : text.length)));
      if (pos < _links.length && i <= _links[pos].regExpMatch.start) {
        textSpans.add(_define(_links[pos], pos));
        i = _links[pos].regExpMatch.end;
        pos++;
      } else {
        i = text.length;
      }
    }
    return textSpans;
  }

  //Фомратирование как обычный текст
  _text(String text) {
    return TextSpan(text: text, style: TextStyle(color: textColor));
  }

  dynamic _define(Interactable interact, int pos) {
    if (interact is Link) {
      return _link(
          text.substring(
              _links[pos].regExpMatch.start, _links[pos].regExpMatch.end),
          _links[pos].type);
    }
    if (interact is CopyAble) {
      return _code(text.substring(
          _links[pos].regExpMatch.start, _links[pos].regExpMatch.end));
    }
  }

  _link(String text, String type) {
    return TextSpan(
        text: text,
        style: linkstyle,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            _launch(_getUrl(text, type));
          });
  }

  _code(String text) {
    return TextSpan(
        text: text,
        style: copystyle,
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            await Clipboard.setData(ClipboardData(text: text));
          });
  }

  _launch(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  _getUrl(String text, String type) {
    switch (type) {
      case http:
        return text.substring(0, 4) == 'http' ? text : 'http://$text';
      case ftp:
        return text.substring(0, 3) == 'ftp' ? text : 'ftp://$text';
      case email:
        return text.substring(0, 7) == 'mailto:' ? text : 'mailto:$text';
      case tel:
        return text.substring(0, 4) == 'tel:' ? text : 'tel:$text';
      default:
        return text;
    }
  }
}
