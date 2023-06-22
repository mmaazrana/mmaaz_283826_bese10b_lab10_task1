const keyUrl = 'url';
const keyContentType = 'contentType';
const keyTitle = 'title';
const keyDate = 'date';
const keyTags = 'tags';

class Search {
  final String url;
  final String contentType;
  final String title;
  final String date;
  final List<dynamic> tags;

  Search(
      {required this.url,
      required this.contentType,
      required this.title,
      required this.date,
      required this.tags});

  factory Search.fromJson(Map<String, dynamic> data) {
    final url = (data[keyUrl] != null) ? data[keyUrl].toString() : '';
    final contentType =
        (data[keyContentType] != null) ? data[keyContentType].toString() : '';
    final title = (data[keyTitle] != null) ? data[keyTitle].toString() : '';
    final date = (data[keyDate] != null) ? data[keyDate].toString() : '';
    final tags = (data[keyTags] != null) ? data[keyTags] as List<dynamic> : [];

    return (Search(
        url: url,
        contentType: contentType,
        title: title,
        date: date,
        tags: tags));
  }
}
