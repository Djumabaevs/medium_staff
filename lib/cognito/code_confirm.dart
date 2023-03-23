if (confirmCode == null || confirmCode.isEmpty) {
  return;
}

// Verify the entered confirmation code.
try {
  final result = await AuthService.sendConfirmResetPassword(
    currentEmail,
    newPasswordController.text,
    confirmCode,
  );

  // If the code is correct, navigate to the success route.
  context.router.navigate(
    SuccessRoute(
      redirectRoute: SignInRoute(isInitialRoute: false),
      description: "Password was reset",
      buttonText: 'Go to Sign In Page',
    ),
  );
} on CodeMismatchException catch (_) {
  // If the code does not match, show the try again window.
  showTryAgainWindow();

  // You can add a button in the try again window to resend the verification code
  // by calling the sendPasswordResetEmail function:
  // final resultEmail = await AuthService.sendPasswordResetEmail(currentEmail);
} on AmplifyException catch (ex) {
  showSnackbar(ex.toString());

  debugPrint(ex.toString());
} catch (ex) {
  debugPrint(ex.toString());

  context.router.navigate(
    SuccessRoute(
      redirectRoute: SignInRoute(isInitialRoute: false),
      description: "Error",
      extraText: 'Something went wrong',
      buttonText: 'Go to Sign In Page',
    ),
  );
}




\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\



// Assuming you have a TextEditingController called confirmCodeController
// to get the input from the user.

ElevatedButton(
  onPressed: () async {
    String confirmCode = confirmCodeController.text.trim();
    if (confirmCode.isNotEmpty) {
      try {
        // Call confirmSignUp API with the provided code.
        await AuthService.confirmSignUp(username: currentEmail, confirmationCode: confirmCode);
        
        // If the code is correct, navigate to the sign-in page or directly sign the user in.
        Navigator.pushReplacementNamed(context, '/signIn');
      } on CodeMismatchException catch (_) {
        // If the code does not match, show an error message and allow the user to try again.
        showTryAgainWindow();
      } catch (ex) {
        // Handle other exceptions.
        debugPrint(ex.toString());
      }
    } else {
      // Show an error message if the user hasn't entered any code.
      showSnackbar("Please enter a confirmation code.");
    }
  },
  child: Text("Submit Confirmation Code"),
),