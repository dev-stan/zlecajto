---
applyTo: '**'
---
ZlecajTo – Copilot Guardrails

## Project
Stack: Ruby 3.3.5, Rails 7.1, Postgres, ViewComponent, Slim, Tailwind (tailwindcss-ruby/rails), Hotwire (Turbo+Stimulus), Devise, ActiveStorage, Foreman, RuboCop, I18n (pl), image_processing.  
Domain: marketplace for tasks and reviews. Users post tasks, apply to complete them, and exchange reviews. Scale target: production-ready for hundreds of thousands of users.

## Core Principle
Code must be extremely clean, production-grade, and maintainable. It should read like a well-written book. Favor clarity, explicitness, and conventional Ruby. Avoid premature abstractions. Do things the Rails way. This repository should exemplify clean code in Ruby on Rails.

## Architecture
- Readable, explicit, conventional code.  
- Thin controllers, expressive models.  
- View logic in ViewComponents, not helpers.  
- Extract to service objects only when logic is too heavy for a model.  
- Prefer pure, side-effect-light methods.  
- No metaprogramming unless absolutely required.  

## Style
- `# frozen_string_literal: true` at file tops.  
- Keyword args for components and services.  
- Guard clauses and safe navigation.  
- Predicates end with `?`; positive naming.  
- Constants frozen; no monkey patches.  
- Use `presence`; avoid manual nil/blank checks.  
- I18n for all user-facing text (Polish default).  

## ViewComponents
- Base: `ApplicationComponent`.  
- Naming: `<Namespace>::ThingComponent`.  
- Public API = initializer. Others private.  
- Keep templates minimal; move logic to private methods.  
- Encapsulate formatting (dates, currency, labels) inside components.  
- CSS classes merged via helpers, never string concat.  
- No unsafe HTML unless sanitized.  

## Slim + Tailwind
- Class order: layout > spacing > sizing > typography > color > state > animation.  
- Extract reused utilities.  
- Semantic HTML + ARIA.  

## Models
- Validations grouped with constants.  
- Callbacks minimal, only for defaults.  
- Heavy operations in services.  
- Scopes descriptive, return relations.  
- Use frozen constants or enums where justified.  
- Add indexes for queried fields.  

## Controllers
- Minimal CRUD + orchestration.  
- No business logic.  
- Strong params only.  
- Devise for auth.  
- Explicit status codes.  
- Centralized flash messages.  
- Wizard orchestration in PORO, not controller.  

## Wizards
- PORO manages steps, bounds, and params.  
- Centralize permitted attributes.  
- No branching in controllers.  
- Ephemeral state until final persistence.  

## Forms
- Strong params whitelist only.  
- Never mass-assign user-owned keys.  
- Compose with components.  
- Stimulus for enhancements.  

## ActiveStorage
- Rescue and log variant errors.  
- Provide fallbacks.  
- Avoid N+1 by using `with_attached_*`.  

## I18n
- All strings localized.  
- Keys short and consistent.  
- Use interpolation.  

## Errors & Logging
- Rescue narrowly.  
- Log class and message.  
- No silent failures.  
- Services return clear `Success/Failure` style objects.  

## Security
- Derive ownership from authenticated user.  
- Escape user-generated content.  
- Validate uploads (type and size).  

## Performance
- Preload associations.  
- Add pagination when needed.  
- Cache expensive components.  
- Use cache keys with `updated_at`.  

## Testing
- Fast, isolated tests.  
- Components: assert HTML/CSS output.  
- Models: validations, scopes, logic.  
- Requests: only critical flows.  
- Prefer factories over fixtures.  

## Naming & Organization
- Group components by domain.  
- Services in `app/services/`, verb-first.  

## RuboCop
- Follow configured cops.  
- Inline disable with rationale only.  

## Migrations
- Reversible.  
- Add indexes.  
- `safety_assured` only with documented reason.  

## AI Do / Avoid
DO: idiomatic concise Ruby, ≤15 line methods, keyword args, guard clauses, explicit logic, localized text, minimal necessary tests.  
DON’T: metaprogramming, premature abstraction, large dependencies, inline SQL, mixing business/presentation logic, scaffold bloat.  

## Review Checklist
- Single, focused scope  
- No unrelated style drift  
- All strings localized  
- Component logic encapsulated  
- Strong params safe  
- No N+1 issues  
- Tests updated and passing  
- RuboCop clean  
- Security concerns addressed  

## When Unsure
Default to simplest, most conventional Rails solution.  
