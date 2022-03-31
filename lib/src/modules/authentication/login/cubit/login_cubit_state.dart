part of 'login_cubit.dart';

class LoginCubitState extends Equatable {
  const LoginCubitState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  final Email email;
  final Password password;
  final FormzStatus status;
  final String? errorMessage;

  @override
  List<Object> get props => [email, password, status];

  LoginCubitState copyWith({
    Email? email,
    Password? password,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return LoginCubitState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}