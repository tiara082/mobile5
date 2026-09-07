# Week 1: Mobile Development Ecosystem & Flutter Refresh

Mobile Application Development Lab Assignment - Week 1 Student Profile Application Report.

---

## 👨‍🎓 Student Details
* **Name:** Tiara Febrianie
* **Student ID (NIM):** 244107020097
* **Class:** TI-3I
* **Department:** Information Technology - State Polytechnic of Malang (Polinema)

---

## 📱 Application Overview
This project is a simple Student Profile application built using Flutter. Key features include:
1. **Student Profile Card:** Displays Name, NIM, Class, Department, Email, and Hobbies with an interactive edit dialog.
2. **Dark & Light Theme:** Toggle switch to swap between Dark Mode and Light Mode.
3. **Hot Reload vs Hot Restart Visualizer:** Interactive counter demonstrating state preservation during Hot Reload vs resetting state during Hot Restart.
4. **Lab Reflections Reader:** Accordion menu displaying answers to Week 1 lab reflection questions.

---

## 🛠️ Setup Problem & Solution

### Problem Encountered
When running commands like `flutter doctor` or `flutter create`, the terminal hung indefinitely without printing any error logs.

Upon checking, the issue was caused by locked `flutter.bat.lock` and `lockfile` files in the Flutter cache directory (`G:\Program Files\flutter\bin\cache\`). Because the Flutter SDK was installed in `Program Files`, normal terminal processes without administrator privileges were unable to delete or update these lock files.

### Solution
1. Opened PowerShell as **Administrator**.
2. Force deleted the stuck lock files:
   ```powershell
   Remove-Item -Force "G:\Program Files\flutter\bin\cache\lockfile", "G:\Program Files\flutter\bin\cache\flutter.bat.lock"
   ```
3. Granted full modify permissions for the `Users` group on the Flutter folder so locks can be written and released cleanly:
   ```powershell
   icacls "G:\Program Files\flutter" /grant "Users:(OI)(CI)M" /T
   ```
After completing these steps, `flutter doctor` and `flutter run` executed smoothly.

---

## 🔄 Hot Reload vs Hot Restart

* **Hot Reload (`r`):**
  * **Mechanism:** Injects updated code changes directly into the running Dart VM and rebuilds the widget tree.
  * **State:** **Preserves application state** (e.g. form entries, active counter values remain intact).
  * **Speed:** Extremely fast (under 1 second). Best for UI tweaks and layout adjustments.

* **Hot Restart (`R`):**
  * **Mechanism:** Reloads the code changes into the Dart VM and restarts the app execution from scratch.
  * **State:** **Resets application state** back to its initial state.
  * **Speed:** Slightly slower (around 1-3 seconds). Required when modifying static variables, `main()`, or initial state logic.

---

## 🧠 Lab Reflections

### 1. When is native development more appropriate than cross-platform development?
Native development (Kotlin/Java for Android, Swift/Objective-C for iOS) is preferred when:
* **Deep Hardware Integration:** The app requires direct access to platform-specific hardware, custom Bluetooth peripherals, or low-level background services not fully exposed by cross-platform plugins.
* **High-Performance Graphics:** Game development, heavy 3D rendering, or intensive real-time video processing engines.
* **Strict Platform-Specific UI/UX:** The app must strictly adhere to Apple Human Interface Guidelines or Google Material Design with zero cross-platform UI compromises.

### 2. How does a state change relate to the widget tree and declarative UI?
* In a **Declarative UI** framework like Flutter, the user interface is defined as a function of its current state: `UI = f(State)`.
* Flutter widgets are immutable configuration objects. When data changes, calling `setState()` marks the widget as "dirty".
* Flutter then triggers the widget's `build()` method to construct a new widget subtree and efficiently diffs it against the old tree, updating only the parts of the UI that changed.

### 3. Why are small commits with clear messages useful for teamwork and a portfolio?
* **For Teamwork:**
  * **Easier Debugging:** Helps isolate bugs quickly using tools like `git bisect`.
  * **Faster Code Reviews:** Small, single-purpose commits make Pull Requests (PRs) much easier for teammates to review.
  * **Fewer Conflicts:** Reduces the risk and complexity of merge conflicts.
* **For Portfolios:**
  * Demonstrates structured problem-solving habits and clean version control practices to reviewers.
  * Provides a clear step-by-step history of how the project evolved from setup to completion.

---

## 📷 App Screenshot

![Student Profile Application Screenshot](screenshots/screenshot.jpg)
