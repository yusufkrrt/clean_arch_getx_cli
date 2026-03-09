extension StringExt on String {
  String toPascalCase() {
    return split(RegExp(r'[_\-\s]+'))
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join();
  }

  String toCamelCase() {
    final pascal = toPascalCase();
    return pascal.isEmpty ? '' : '${pascal[0].toLowerCase()}${pascal.substring(1)}';
  }

  String toSnakeCase() {
    return replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (m) => '${m[1]}_${m[2]}',
        )
        .replaceAll(RegExp(r'[\-\s]+'), '_')
        .toLowerCase();
  }
}
