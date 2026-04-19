# Odin Book

Odin Book is a social feed web app built with Ruby on Rails.

It supports account authentication, follow requests, posts, likes, comments, image uploads, and retweets.

## Features

- User authentication with Devise
- Optional GitHub OAuth sign in
- Follow system with request and accept flow
- Feed built from followed users and your own posts
- Create and delete posts
- Like and unlike posts
- Comment and delete comments
- Upload images for posts and comments via Active Storage
- Retweet and unretweet with self-referential post links

## Tech Stack

- Ruby on Rails 8
- PostgreSQL
- Hotwire and Turbo
- Stimulus
- Propshaft
- Devise
- Active Storage
- RSpec

## Data Model Highlights

- Post can have many photos
- Comment can have one photo
- Retweet is stored as a Post row that points to another Post through original_post_id
- Database uniqueness index prevents duplicate retweets by the same user for the same original post

## Local Setup

1. Clone the project and go to the app directory.
2. Install dependencies.
3. Set environment variables.
4. Create and migrate the database.
5. Start the app.

Commands:

bin/setup
bin/rails db:create db:migrate
bin/dev

If you are not using bin/dev, you can run:

bin/rails server

## Environment Variables

For development and test, use dotenv with a .env file.

Common values used in this app:

- GITHUB_CLIENT_ID
- GITHUB_CLIENT_SECRET

Add any additional credentials needed by your deployment environment.

## Image Uploads

The app uses Active Storage.

- Development uses local disk storage
- Production should use a cloud object storage provider

If deploying on Render, avoid relying on local disk for long-term media persistence.

## Retweet Behavior

- Retweet targets the original post
- Retweet button toggles on and off
- Retweet counts are shown on the original post content in feed cards
- Retweet guardrails prevent duplicate and nested retweets

## Testing

Run test suite:

bundle exec rspec

You can also use Guard in development:

bundle exec guard

## Deployment Notes

- Render is supported
- Configure production database and secrets in Render environment settings
- Configure production Active Storage service to cloud storage for reliable image persistence

## Roadmap

- Quote retweet
- Better media storage setup for production demo
- Additional request specs for retweet and feed behavior

## Author

Built as part of a portfolio project.
