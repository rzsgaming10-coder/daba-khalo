# DABA KHALO

A professional online chess tournament platform with a Flutter client and a separate Next.js web application. A shared NestJS backend is planned.

## Current implementation

- Dark charcoal and metallic gold Material 3 theme
- Responsive five-section app shell
- Home, tournaments, play, ranking, and profile prototypes
- Tournament details and registration screens
- Responsive square chessboard prototype
- Separate Next.js web application in [`website/`](./website/) with landing, searchable/filtered tournaments, tournament details, rankings, Swiss/round-robin roadmaps, and a knockout bracket preview
- Configurable fixed, percentage, and tiered prize previews using integer minor-unit calculations
- Payment-provider interface with an explicit unconfigured implementation; no test payment is marked successful
- Admin route locked until authentication and server-side role authorization are implemented

Server-authoritative chess, tournament algorithms, authentication, payments, realtime gameplay, PostgreSQL, and the admin panel are foundation phases rather than claimed production capabilities yet.

## Requirements

- Flutter stable SDK 3.x
- Dart 3.x

## Run the Flutter app

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

## Run the web app

Requires Node.js 20.9 or newer.

```bash
cd website
npm install
npm run dev
npm test
npm run lint
npm run build
```

The website currently uses local development data and preview-only prize and registration interactions. It does not process payments or confirm seats. Prize, bracket, player, and admin financial actions must be recalculated and authorized by a server before production use.

## Project layout

```text
lib/
  app/                 App composition, theme, and navigation
  core/                Shared technical infrastructure
  features/            Player-facing feature modules
  shared/widgets/      Reusable responsive UI widgets
```

## Development status

Local UI prototypes use static development data. The web registration action only changes the local preview and does not reserve a seat or collect money. No credentials are required and no external backend is simulated as a real service. Server-authoritative tournament registration, payment verification, authentication, WebSocket game authority, and PostgreSQL configuration must be added using environment-based adapters before those systems can be treated as operational.
