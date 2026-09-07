# 🏛️ Smart Room AR Architecture Specifications

## Overview
Smart Room AR connects a Flutter client with a Spring Boot REST API:
- **Mobile Stack**: Flutter 3.24+, Material 3 luxury dark tokens, ARCore SceneViewer.
- **Backend Stack**: Spring Boot 3.4, Spring Security HTTP Basic Auth, OpenAPI 3.1 Swagger UI.
- **Network Sync**: USB port forwarding via `adb reverse tcp:8080 tcp:8080`, local H2 profile.
- **Quote Lifecycle**: `SENT` → `IN_PROGRESS` → `PROCESSED` with live status sync and pull-to-refresh.
