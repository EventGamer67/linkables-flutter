library linkable;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flatsharing_linkable/parsers/codes_parser.dart';
import 'package:flatsharing_linkable/shared/constants.dart';
import 'package:flatsharing_linkable/types/copyable.dart';
import 'package:flatsharing_linkable/parsers/email_parser.dart';
import 'package:flatsharing_linkable/parsers/ftp_parser.dart';
import 'package:flatsharing_linkable/parsers/http_parser.dart';
import 'package:flatsharing_linkable/types/interactable.dart';
import 'package:flatsharing_linkable/types/link.dart';
import 'package:flatsharing_linkable/parsers/parser.dart';
import 'package:flatsharing_linkable/parsers/tel_parser.dart';
import 'package:url_launcher/url_launcher.dart';

class Linkable extends StatelessWidget {
  final String text;

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

  final List<Parser> _parsers = <Parser>[];
  final List<Interactable> _links = <Interactable>[];

  Linkable({
    Key? key,
    required this.text,
    this.textColor = Colors.black,
    this.style,
    this.copystyle,
    this.linkstyle = const TextStyle(color: Colors.blue),
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    init();
    return SelectableText.rich(
      TextSpan(
        text: '',
        style: style,
        children: _getTextSpans(),
      ),
      textAlign: textAlign,
      textDirection: textDirection,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  //Я не знаю что тут происходит, но оно преобразует монолитный текст в лист TextSpan с заданным форматированием
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

  //В зависимости от типа ссылки Interactable возвращает TextSpan
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

  //Форматирование как дверной код
  _code(String text) {
    return TextSpan(
        text: text,
        style: copystyle,
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            await Clipboard.setData(ClipboardData(text: text));
          });
  }

  //Фомратирование как обычный текст
  _text(String text) {
    return TextSpan(text: text, style: TextStyle(color: textColor));
  }

  //Форматирование как ссылка
  _link(String text, String type) {
    return TextSpan(
        text: text,
        style: linkstyle,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            _launch(_getUrl(text, type));
          });
  }

  //Запуск заданной url ссылки
  _launch(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  //Получение ссылки
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
}
