# Changelog

Languages: **English** | [简体中文](CHANGELOG.zh-CN.md) | [日本語](CHANGELOG.ja.md)

This file records the notable changes of the シネコ (otaku_movie) app.

## [1.0.2+3] - 2026-06-15

### Added
- Showtime list and detail now display the special-screening / event name (e.g. stage greetings) for decorated showtimes.

### Changed
- Sold-out showtimes are now non-purchasable: tapping shows a toast hint instead of opening the official ticketing site.
- Redesigned the "Select Seat" button on the showtime detail page by seat status — blue when available, orange when limited, red when sold out, and gray for other non-purchasable states (pre-sale / sale ended / closed / unknown); the button icon and label switch with the state, and the seat icon is enlarged.
- The showtime list no longer auto-selects your current area after locating; it only refreshes to sort cinemas by distance and keeps any area filter you chose manually.

### Other
- Bumped the version to `1.0.2+3`.

## [1.0.1+2] - 2026-06-12

### Added
- Expanded analytics across the benefit funnel: "view available cinemas", benefit sharing, benefit image preview, benefit feedback submission, cinema filtering and cinema clicks, making the benefit conversion path easier to track.
- Added benefit feedback submission tracking on the order detail page.
- Improved the information reported by API error tracking.
- Extended movie list data fields; movie detail, showtime list, search and cinema list now show more complete movie and cinema information.

### Changed
- Localization updates: password rule hint changed to "8–32 characters, including letters and numbers, special characters allowed", added password strength labels "Weak/Medium/Strong", and updated the contact email in the copyright and data disclaimer.
- Renamed the benefit phase status label from "Before" to "Upcoming" for clarity.
- More accurate dictionary display across languages.
- Unified the global AppBar to white, fixing the Material 3 issue where the title bar was tinted gray while scrolling.
- Unified the size and alignment of the prefix icons in the registration form inputs, and enlarged the icon and text of the verification code "Send" button.
- Enlarged the field fonts on the profile page for better readability.

### Fixed
- Fixed the layout overflow on the right side of the password input on the registration page; long error messages now wrap correctly.

### Other
- Adjusted the Android build configuration to keep local debug and release builds clearly separated.
- Bumped the version to `1.0.1+2`.
