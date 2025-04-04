# Skroutzly - URL Shortener

> **Note:** This repository was created for educational purposes as part of a workshop. It is intended for demonstration only and not for production use.

Skroutzly is a user-friendly URL shortening service built with Ruby on Rails. This application allows users to create shortened versions of long URLs, making them easier to share and track.

## What is a URL Shortener?

A URL shortener is a web service that creates shorter aliases for long URLs. When users click on these shortened links, they are automatically redirected to the original URL. URL shorteners provide several benefits:

- **Improved Readability**: Long, complex URLs are converted into concise, easy-to-read links
- **Better Sharing**: Shortened URLs are ideal for platforms with character limitations like Twitter
- **Click Tracking**: Track how many times your link has been clicked
- **Custom Slugs**: Create memorable, branded links instead of random characters

## Getting Started

### Prerequisites

- Ruby (version recommended by `.ruby-version`)
- Rails 8.x
- SQLite

### Installation

1. Clone the repository
   ```
   git clone https://github.com/skroutz/skroutzly.git
   cd skroutzly
   ```

2. Install dependencies
   ```
   bundle install
   ```

3. Set up the database
   ```
   bin/rails db:create db:migrate
   ```

4. Start the server
   ```
   bin/dev
   ```

5. Visit `http://localhost:3000` in your browser

## Usage

1. Sign up for an account
2. Enter a long URL to create a shortened version
3. Optionally provide a custom slug and title
4. Share your shortened URL
5. Track clicks through the dashboard
6. Edit or delete your URLs as needed

## Environment Variables

- `APP_HOST`: The host URL for your application (default: 'localhost:3000')
