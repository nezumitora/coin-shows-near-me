# Coin Show & Dealer Scrapers

Scripts to scrape coin show and dealer data from public sources.

## Setup

```bash
pip install -r requirements.txt
```

## Show Scraper

Scrapes coin show listings from publicly accessible sources:
- CoinZip.com state pages
- CoinShows-USA.com state pages
- Numismatic association event pages

```bash
python scrape_shows.py --state CA
python scrape_shows.py --all
python scrape_shows.py --all --output ../data/scraped_shows.yml
```

## Dealer Scraper

Scrapes coin dealer listings from publicly accessible directories:
- ANA member dealer directories
- PCGS/NGC authorized dealer lists
- State numismatic association member pages

```bash
python scrape_dealers.py --state CA
python scrape_dealers.py --all
python scrape_dealers.py --all --output ../data/scraped_dealers.yml
```

## Ethics & Legal

- Respect `robots.txt` on all sites
- Rate-limit requests (2-second minimum between requests)
- Cache responses to avoid repeated hits
- Only scrape publicly available data (no login-walled content)
- Attribute data sources in output
- Do NOT scrape sites that explicitly prohibit it in their ToS

## Output Format

Both scrapers output YAML compatible with the site's `_data/` structure, making it
easy to review diffs and merge new shows/dealers into the canonical data files.
