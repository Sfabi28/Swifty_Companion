# swifty_companion

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
# Swifty Companion

Mobile Initiation — Swifty Companion

Summary
-------
Swifty Companion is a mobile application project for learning mobile development and the 42 API. The app retrieves and displays profile information for users of the 42 network (42 API), showing personal details, skills, and project results.

Key Goals
---------
- Learn mobile programming and frameworks (Flutter/Dart used in this repository).
- Integrate with the 42 API using OAuth2 (intra) to fetch user data.
- Build modern, responsive UI with at least two views.

Mandatory Features
------------------
- At least two views (search/list and profile detail).
- Proper error handling (login not found, network errors, invalid responses).
- Profile view showing at least four user details (e.g., login, email, location, wallet) and profile picture.
- Display skills with level and percentage.
- Display user projects (including failed ones).
- Navigation back to the first view.
- Use a flexible, modern layout so UI adapts to multiple screen sizes.
- Use intra OAuth2; do not create a token per query.

Bonus (optional)
----------------
- Refresh and recreate access tokens when they expire so the app remains functional.

Environment & Security
----------------------
- Store secrets (client id/secret, redirect URIs, etc.) locally in a `.env` file and never commit them to source control. Ensure `.env` is listed in `.gitignore`.
- Do NOT include the `.env` file in app assets or in the repository. Secrets packaged in the app can be extracted from the binary.
- The app must use the latest 42 API and follow the OAuth2 flow described by 42 (intra). Prefer moving sensitive token exchanges to a backend service when possible.

Setup (Flutter)
---------------
1. Install Flutter (stable channel) and required SDKs for target platforms.
2. From the project root run:

```bash
flutter pub get
flutter run
```

3. Add a `.env` file in the project root with your OAuth2 credentials and any other sensitive configuration while developing locally. Example keys (this project looks for `UID` and `SECRET` by default):

```
UID=your_client_id
SECRET=your_client_secret
REDIRECT_URI=your_redirect_uri
```

Alternative: pass secrets at build/run time using `--dart-define` so they are not stored in source-controlled files. Example:

```bash
flutter run --dart-define=UID=your_client_id --dart-define=SECRET=your_client_secret
flutter build apk --dart-define=UID=$UID --dart-define=SECRET=$SECRET
```

Code fallback: the app will first read `UID`/`SECRET` from `--dart-define` (compile-time defines) and then fall back to reading `.env` via `flutter_dotenv`.

If neither is present the app will not attempt OAuth token exchange and will log a debug warning.

Usage
-----
- Launch the app and use the search or login screen to request a profile from the 42 API.
- The app will navigate to the profile view on success and display details, skills, and projects.

Notes for Submission
--------------------
- Only the repository contents will be evaluated during the defense. Ensure `.env` is listed in `.gitignore` and credentials are not committed.
- The mandatory part must be fully working for the bonus to be considered.

Credits
-------
This project was created as part of the Mobile Initiation curriculum. The project brief and requirements were provided by the course materials.

License
-------
See repository license, or add one if needed.

# Swifty_Companion
