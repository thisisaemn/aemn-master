import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aemn/src/modules/authentication/sign_up/sign_up.dart';
import 'package:formz/formz.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpCubitState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          Navigator.of(context).pop();
        } else if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Sign Up Failure')),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _EmailInput(),
            const SizedBox(height: 16),
            _PasswordInput(),
            const SizedBox(height: 16),
            _ConfirmPasswordInput(),
            const SizedBox(height: 50),
            _SignUpButton(),
          ],
        )),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpCubitState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Container(
            padding: EdgeInsets.fromLTRB(25,2,25,2),
            child:TextField(
          key: const Key('signUpForm_emailInput_textField'),
          onChanged: (email) => context.read<SignUpCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          cursorColor: Colors.grey,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            labelText: 'email',
            helperText: '',
            errorText: state.email.invalid ? 'invalid email' : null,
          ),
        ));
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpCubitState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return Container(
            padding: EdgeInsets.fromLTRB(25,2,25,2),
        child:
          TextField(
          key: const Key('signUpForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<SignUpCubit>().passwordChanged(password),
          obscureText: true,
          cursorColor: Colors.grey,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            labelText: 'password',
            helperText: '',
            errorText: state.password.invalid ? 'invalid password' : null,
          ),
        ));
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpCubitState>(
      buildWhen: (previous, current) =>
      previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) {
        return Container(
            padding: EdgeInsets.fromLTRB(25,2,25,2),
            child:TextField(
          key: const Key('signUpForm_confirmedPasswordInput_textField'),
          onChanged: (confirmPassword) => context
              .read<SignUpCubit>()
              .confirmedPasswordChanged(confirmPassword),
          obscureText: true,
          cursorColor: Colors.grey,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            labelText: 'confirm password',
            helperText: '',
            errorText: state.confirmedPassword.invalid
                ? 'passwords do not match'
                : null,
          ),
        ));
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpCubitState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
          key: const Key('signUpForm_continue_raisedButton'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.fromLTRB(50,20,50,20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            primary: Colors.orangeAccent,
          ),
          onPressed: state.status.isValidated
              ? () => context.read<SignUpCubit>().signUpFormSubmitted()
              : null,
          child: const Text('SIGN UP'),
        );
      },
    );
  }
}