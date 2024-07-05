import 'package:flatsharing_linkable/linkable_tools.dart';
import 'package:flutter/material.dart';
import 'package:flatsharing_linkable/linkable.dart';

void main() => runApp(new LinkableExample());

class LinkableExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Linkable example',
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text.rich(LinkableTools.getLinkedTextSpan(
                "A Flutter widget to add links to your text. By default, the Text or RichText widgets render the URLs in them as simple text which are not clickable. So, Linkable widget is a wrapper over RichText which allows you to render links that can be clicked to redirect to the URL. That means that a Linkable widget supports all the attributes of a RichText Widget. Currently linkable supports the following types: Web URL (https://www.github.com/anupkumarpanwar) Emails (mailto:1anuppanwar@gmail.com) Phone numbers (tel:+918968894728) Note: You don't need to specify the URL scheme (mailto, tel etc). The widget will parse it automatically. Вас приветствует компания Как Дома Вы забронировали апартаменты по адресу: г. Нижний Новгород, ул. Совнаркомовская, д. 6А, На срок: 13.06.2024, 15:00 - 14.06.2024, 12:00. Оплата Для получения кодов доступа оплатите 4 500 ₽ – Залог 0 ₽ – Арендная плата 4 500 ₽ приведенным способом: Ваши данные для доступа Адрес: г. Нижний Новгород, ул. Совнаркомовская, д. 6А, кв 1, подъезд 1, этаж 1/3 Код от кейбокса: 248 одновременно нажимайте Код от замка: *6361# Вас приветствует коp.\n\nYo https://web.flatsharing.mobi/rent/DmSBMdx5wlUbaOKVkbxp  ftp://cgdvxhrjc.ffffffffff u can 2342 sdfs3 email me at 1anuppanwar@gmail.com.\nOr just whatsapp me @ +91-8968894728.\n\nFor more info visit: \ngithub.com/anupkumarpanwar \nor\nhttps://www.linkedin.com/in/anupkumarpanwar/",
                LinkableStyle(
                    style: TextStyle(color: Colors.red),
                    linkstyle: TextStyle(
                      color: Colors.blue,
                    )))),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Linkable(
                copystyle: TextStyle(
                  color: Colors.red,
                  background: Paint()
                    ..strokeJoin = StrokeJoin.bevel
                    ..color = Color.fromRGBO(
                        0, 0, 0, 0.1) // Черный цвет с 30% прозрачностью
                    ..style = PaintingStyle.fill
                    ..strokeWidth = 1
                    ..maskFilter = MaskFilter.blur(BlurStyle.solid, 1.0)
                    ..strokeCap = StrokeCap.round, // Добавляем закругление
                ),
                text:
                    "A Flutter widget to add links to your text. By default, the Text or RichText widgets render the URLs in them as simple text which are not clickable. So, Linkable widget is a wrapper over RichText which allows you to render links that can be clicked to redirect to the URL. That means that a Linkable widget supports all the attributes of a RichText Widget. Currently linkable supports the following types: Web URL (https://www.github.com/anupkumarpanwar) Emails (mailto:1anuppanwar@gmail.com) Phone numbers (tel:+918968894728) Note: You don't need to specify the URL scheme (mailto, tel etc). The widget will parse it automatically. Вас приветствует компания Как Дома Вы забронировали апартаменты по адресу: г. Нижний Новгород, ул. Совнаркомовская, д. 6А, На срок: 13.06.2024, 15:00 - 14.06.2024, 12:00. Оплата Для получения кодов доступа оплатите 4 500 ₽ – Залог 0 ₽ – Арендная плата 4 500 ₽ приведенным способом: Ваши данные для доступа Адрес: г. Нижний Новгород, ул. Совнаркомовская, д. 6А, кв 1, подъезд 1, этаж 1/3 Код от кейбокса: 248 одновременно нажимайте Код от замка: *6361# Вас приветствует коp.\n\nYo https://web.flatsharing.mobi/rent/DmSBMdx5wlUbaOKVkbxp  ftp://cgdvxhrjc.ffffffffff u can 2342 sdfs3 email me at 1anuppanwar@gmail.com.\nOr just whatsapp me @ +91-8968894728.\n\nFor more info visit: \ngithub.com/anupkumarpanwar \nor\nhttps://www.linkedin.com/in/anupkumarpanwar/",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
