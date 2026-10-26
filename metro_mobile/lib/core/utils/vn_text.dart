const _from =
    'àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡ'
    'ùúụủũưừứựửữỳýỵỷỹđ';
const _to =
    'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooo'
    'uuuuuuuuuuuyyyyyd';

/// Bỏ dấu + chữ thường để tìm kiếm, giống `norm()` của chatbot web.
String normalizeVn(String input) {
  final lower = input.toLowerCase().trim();
  final buf = StringBuffer();
  for (final rune in lower.runes) {
    final ch = String.fromCharCode(rune);
    final i = _from.indexOf(ch);
    buf.write(i >= 0 ? _to[i] : ch);
  }
  return buf.toString().replaceAll(RegExp(r'\s+'), ' ');
}

/// `true` nếu [text] chứa [query], không phân biệt dấu và hoa thường.
bool vnContains(String text, String query) =>
    normalizeVn(text).contains(normalizeVn(query));
