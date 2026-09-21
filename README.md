# RPS Central

RPS Central is the company app for RootPulse Solutions, a business that performs drone scans. It is the place to run day-to-day operations: one app, with separate areas for each part of the work.

## How the app is organized

RPS Central is a hub. The home of the app is a set of **sub-apps**. Each sub-app owns one area of the business and can grow on its own. New sub-apps are added as those areas are built. They are not separate products; they live inside this app so flight work, records, and the rest of the business stay in one place.

## Flight logging

The first sub-app is **flight logging**. It is where a flight is recorded from preparation through the work that follows it.

That includes:

- **Preflight checks** — the checks completed before a flight.
- **Post-flight logs** — what happened on the flight, recorded after landing.
- **Maintenance** — upkeep and service tied to the aircraft and the flights it flies.
- **Other flight records** that belong with logging, as that work is defined.

Flight logging is one sub-app among others. It is the one being built first.

## Later sub-apps

Other sub-apps will cover the rest of running the business. Those areas are not specified yet. The app should stay open to them: a new operational need becomes another sub-app in the same hub, alongside flight logging.

## Project

This repository is a SwiftUI app for iOS, opened in Xcode as `RPS Central.xcodeproj`. The home screen is the hub. It opens flight logging, which lists preflight checks, post-flight logs, and maintenance. Those records are still to be built, along with the other sub-apps.
