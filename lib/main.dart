import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:convert';

void main() {
  runApp(const ProviderScope(child: MyApp()));

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const AddVerseResponseWidget(),
    );
  }
}

class AddVerseResponseWidget  extends ConsumerWidget {
  const AddVerseResponseWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: ref.watch(markVerseResponseProvider).when(
            loading: () => const CircularProgressIndicator(),
            error: (err, stack) => Text('Error: $err'),
            data: (verseResponseList) {
              final thirdVerse = verseResponseList.firstWhere((element) => element.chapterNumber == 5);
              return Center(child:Text(thirdVerse.value ?? ''));
            }));

  }
}

// TODO: Get each book nto just john
// with drag and drop
// it's only 10mb
// also. use familyProvider since name of the book is in the string.
final johnVerseResponseProvider = FutureProvider<List<WebLocalBookItem>>((ref) async {
  String jsonString = await rootBundle.loadString('assets/books/john.json');
  return webLocalBookItemFromJson(jsonString);
});

final markVerseResponseProvider = FutureProvider<List<WebLocalBookItem>>((ref) async {
  String jsonString = await rootBundle.loadString('assets/books/mark.json');
  return webLocalBookItemFromJson(jsonString);
});
// 1% battery at 2:36pm at joes pizzak, showe don pixel5a jon 1:1

// from https://github.com/TehShrike/world-english-bible

// To parse this JSON data, do
//
//     final webLocalBookItem = webLocalBookItemFromJson(jsonString);


List<WebLocalBookItem> webLocalBookItemFromJson(String str) => List<WebLocalBookItem>.from(json.decode(str).map((x) => WebLocalBookItem.fromJson(x)));

//String webLocalBookItemToJson(List<WebLocalBookItem> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WebLocalBookItem {
  WebLocalBookItem({
    required this.type,
    this.chapterNumber,
    this.verseNumber,
    //this.sectionNumber,
    this.value,
  });

  Type type;
  int? chapterNumber;
  int? verseNumber;
  //int? sectionNumber;
  String? value;

  factory WebLocalBookItem.fromJson(Map<String, dynamic> json) => WebLocalBookItem(
    type: typeValues.map[json["type"]]!,
    chapterNumber: json["chapterNumber"],
    verseNumber: json["verseNumber"] == null ? null : json["verseNumber"],
    //sectionNumber: json["sectionNumber"] == null ? null : json["sectionNumber"],
    value: json["value"],
  );
/*
  Map<String, dynamic> toJson() => {
    "type": typeValues.reverse![type],
    "chapterNumber": chapterNumber == null ? null : chapterNumber,
    "verseNumber": verseNumber == null ? null : verseNumber,
    "sectionNumber": sectionNumber == null ? null : sectionNumber,
    "value": value == null ? null : value,
  };

   */
}

enum Type { PARAGRAPH_START, PARAGRAPH_TEXT, PARAGRAPH_END, STANZA_START, LINE_TEXT, LINE_BREAK, STANZA_END }

final typeValues = EnumValues({
  "line break": Type.LINE_BREAK,
  "line text": Type.LINE_TEXT,
  "paragraph end": Type.PARAGRAPH_END,
  "paragraph start": Type.PARAGRAPH_START,
  "paragraph text": Type.PARAGRAPH_TEXT,
  "stanza end": Type.STANZA_END,
  "stanza start": Type.STANZA_START
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}


