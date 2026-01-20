name: Build and deploy Jekyll to /docs
on:
  push:
    branches: [ main ]
  workflow_dispatch:

permissions:
  contents: write

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.1'

      - name: Cache gems
        uses: actions/cache@v4
        with:
          path: vendor/bundle
          key: ${{ runner.os }}-gems-${{ hashFiles('jekyll-src/Gemfile.lock', 'jekyll-src/Gemfile') }}
          restore-keys: |
            ${{ runner.os }}-gems-

      - name: Install dependencies
        run: |
          gem install bundler
          bundle config set --local path 'vendor/bundle'
          bundle install --gemfile=jekyll-src/Gemfile --jobs 4 --retry 3

      - name: Build the site
        run: bundle exec jekyll build -s jekyll-src -d docs

      - name: Commit and push changes
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          if [ -n "$(git status --porcelain docs)" ]; then
            git add docs
            git commit -m "chore: rebuild site [skip ci]"
            git push origin HEAD:main
          else
            echo "No changes to commit"
          fi
