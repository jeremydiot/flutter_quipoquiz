String removeHtml(String data){
  final RegExp exp = RegExp(
      r'<[^>]*>|&[^;]+;|\n|\r',
      multiLine: true,
      caseSensitive: true
  );

  return data
      .replaceAll(exp, ' ')
      .replaceAll(' .', '.')
      .replaceAll(' ,', ',')
      .replaceAll('  ', ' ')
      .trim();
}