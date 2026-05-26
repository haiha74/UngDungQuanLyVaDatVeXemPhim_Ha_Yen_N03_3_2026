class GenericClass<T> {
  T id;
  String name;
  String description;
  int runtime;
  String posterUrl;
  String status;

  GenericClass({
    required this.id,
    required this.name,
    required this.description,
    required this.runtime,
    required this.posterUrl,
    required this.status,
  });

  T getId() => id;
  String getName() => name;
  String getDescription() => description;
}