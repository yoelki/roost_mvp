# roost_mvp

A new Flutter project.

## Firebase Configuration

To set up Firebase in your local development environment:

1. Download the configuration files from Firebase Console:

   - For Android: `google-services.json` → place in `android/app/`
   - For iOS/macOS: `GoogleService-Info.plist` → place in `ios/Runner/` and `macos/Runner/`
   - Copy `lib/firebase_options.template.dart` to `lib/firebase_options.dart` and fill in your Firebase configuration values

2. These files contain sensitive information and should not be committed to source control. They are already added to `.gitignore`.

3. For CI/CD environments, you'll need to set up these files as secrets in your pipeline.
