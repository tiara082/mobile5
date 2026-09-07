# Week 2: Declarative UI & Responsive Design

Mobile Application Development Lab Assignment - Week 2 Academic Overview & Responsive Dashboard Report.

---

## 👨‍🎓 Student Details
* **Name:** Tiara Febrianie
* **Student ID (NIM):** 244107020097
* **Class:** TI-3I
* **Department:** Information Technology - State Polytechnic of Malang (Polinema)

---

## 📱 Assignment Overview

This project implements an **Academic Overview & Responsive Dashboard** in Flutter. It demonstrates responsive layout adaptation, custom widget extraction, adaptive light/dark theme switching, and accessibility semantics.

### Key Features
1. **Student Profile Summary Header:** Displays Student Name, NIM (`244107020097`), and Class (`TI-3I`).
2. **Four Academic Information Cards:**
   - Cumulative GPA (IPK): `3.85 / 4.00`
   - Enrolled Credits: `22 SKS`
   - Attendance Rate: `98.5%`
   - Active Semester Status: `Semester 4 (Active)`
3. **Adaptive Breakpoint Layout (`kWideBreakpoint = 700.0`):**
   - **Narrow Screens (< 700px):** Single-column layout for mobile phones.
   - **Wide Screens (>= 700px):** Two-column grid layout for tablets and desktop displays.
4. **Extracted Reusable `InfoCard` Widget:** Standardizes card layout and eliminates widget duplication.
5. **Light & Dark Theme Switcher:** Uses `Switch.adaptive` paired with `Theme.of(context)` styling.
6. **Accessibility Support:** Key information and theme controls wrapped with `Semantics` labels for screen readers.

---

## 🤖 AI Prompt Challenge Documentation

### 1. Design Prompt Challenge
* **Prompt Submitted:**
  > "Compare two Flutter academic dashboard layouts: a GridView version and a LayoutBuilder + Column version. Explain the responsive and accessibility trade-offs."

* **Comparison & Decision:**
  * **`GridView` Version:** Forces fixed child aspect ratios (`childAspectRatio`). On narrow mobile screens or when system font scaling is enlarged, fixed height constraints cause vertical text overflow errors (`A RenderFlex overflowed by X pixels`).
  * **`LayoutBuilder + Column/Row` Version (Selected):** Allows cards to calculate intrinsic height based on text content. It smoothly adapts from 1 column on narrow screens to 2 columns on wide screens without clipping text.
  * **Accessibility Trade-off:** `LayoutBuilder + Column` provides a linear reading order for screen readers (top-to-bottom on mobile), whereas `GridView` can jump across columns unpredictably.

---

### 2. Concept-Reinforcement Prompt Challenge
* **Prompt Submitted:**
  > "Explain when using Expanded actually causes an overflow inside a Row; show failing example code and its fix."

* **Technical Explanation:**
  `Expanded` instructs a child widget to fill available space along the main axis of a `Row` or `Column`. However, if the `Row` is placed inside a horizontally scrollable container like `SingleChildScrollView(scrollDirection: Axis.horizontal)`, the parent provides **unbounded (infinite) width**. Placing an `Expanded` inside an unbounded parent throws an assertion exception: `RenderFlex children have non-zero flex but incoming width constraints are unbounded.`

* **Failing Code Example:**
  ```dart
  // FAILING EXAMPLE: Expanded inside horizontally scrollable Row (Unbounded Width)
  SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        Expanded( // Throws error: incoming width constraints are unbounded!
          child: Text('Academic GPA: 3.85'),
        ),
      ],
    ),
  )
  ```

* **Fixed Code Example:**
  ```dart
  // FIXED EXAMPLE: Use LayoutBuilder or ConstrainedBox to bound width before flexing
  LayoutBuilder(
    builder: (context, constraints) {
      return Row(
        children: [
          Expanded( // Works correctly because LayoutBuilder provides bounded width
            child: Text('Academic GPA: 3.85'),
          ),
        ],
      );
    },
  )
  ```

---

### 3. Verification Prompt Challenge
* **Prompt Submitted:**
  > "Review the layout recommendation above: does it stay responsive below 600px, does it reduce accessibility, and are all widgets available in the current stable Flutter?"

* **Verification Evidence:**
  - **Responsiveness below 600px:** Verified down to 320px width. Single column stacks vertically with zero overflow.
  - **Accessibility Audit:** Validated with `Semantics(label: ...)` tags on cards and theme switchers.
  - **Stable Widget Availability:** All utilized widgets (`LayoutBuilder`, `Row`, `Column`, `Expanded`, `Card`, `Switch.adaptive`, `Semantics`) are standard core Flutter widgets.

---

## 🛠️ Refactoring & Code Quality

1. **Extracted Reusable `InfoCard` Widget:** Replaced repeated card code with a single reusable `InfoCard` widget accepting `title`, `value`, `icon`, and `semanticsLabel`.
2. **Single Named Breakpoint Constant:** Defined `const double kWideBreakpoint = 700.0;` at top-level.
3. **Theme Enforcement:** Replaced hardcoded colors with `Theme.of(context)` color scheme and text themes.

---

## 🧪 Automated Testing Verification

Automated widget tests were implemented in `test/widget_test.dart` to verify screen size responsiveness:

```bash
flutter test
```

### Test Cases Passed:
- ✅ `Dashboard shows one column on a narrow screen (400x800)`
- ✅ `Dashboard shows two columns on a wide screen (1200x800)`
- ✅ `flutter analyze` completed with 0 errors / 0 warnings.

---

## 📷 Screenshots

| Narrow Screen (< 700px) | Wide Screen (>= 700px) |
|-------------------------|------------------------|
| ![Narrow Screen](screenshots/narrow.png) | ![Wide Screen](screenshots/wide.png) |
