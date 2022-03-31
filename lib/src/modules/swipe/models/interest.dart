import 'package:equatable/equatable.dart';

class Interest extends Equatable {
  final String id;
  final String title;
  final String body;

  const Interest({required this.id, required this.title, required this.body});

  @override
  List<Object> get props => [id, title, body];

  @override
  String toString() => 'Interest { id: $id }';
}