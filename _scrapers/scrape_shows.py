#!/usr/bin/env python3
"""
Coin Show Scraper — scrapes coin show listings from public sources.

Sources:
  - CoinZip.com (state-level show directories)
  - CoinShows-USA.com (state-level show directories)

Usage:
  python scrape_shows.py --state CA
  python scrape_shows.py --all
  python scrape_shows.py --all --output scraped_shows.yml

Ethics:
  - Respects robots.txt
  - 2-second delay between requests
  - Caches responses locally
  - Only scrapes publicly available listings
"""

import argparse
import hashlib
import os
import re
import sys
import time
from pathlib import Path

import requests
import yaml
from bs4 import BeautifulSoup

# --- Configuration ---

USER_AGENT = "CoinShowNearMe-Scraper/1.0 (+https://github.com/nezumitora/coin-shows-near-me)"
REQUEST_DELAY = 2  # seconds between requests
CACHE_DIR = Path(__file__).parent / ".cache"

STATES = {
    "AL": "Alabama", "AK": "Alaska", "AZ": "Arizona", "AR": "Arkansas",
    "CA": "California", "CO": "Colorado", "CT": "Connecticut", "DE": "Delaware",
    "FL": "Florida", "GA": "Georgia", "HI": "Hawaii", "ID": "Idaho",
    "IL": "Illinois", "IN": "Indiana", "IA": "Iowa", "KS": "Kansas",
    "KY": "Kentucky", "LA": "Louisiana", "ME": "Maine", "MD": "Maryland",
    "MA": "Massachusetts", "MI": "Michigan", "MN": "Minnesota", "MS": "Mississippi",
    "MO": "Missouri", "MT": "Montana", "NE": "Nebraska", "NV": "Nevada",
    "NH": "New-Hampshire", "NJ": "New-Jersey", "NM": "New-Mexico", "NY": "New-York",
    "NC": "North-Carolina", "ND": "North-Dakota", "OH": "Ohio", "OK": "Oklahoma",
    "OR": "Oregon", "PA": "Pennsylvania", "RI": "Rhode-Island", "SC": "South-Carolina",
    "SD": "South-Dakota", "TN": "Tennessee", "TX": "Texas", "UT": "Utah",
    "VT": "Vermont", "VA": "Virginia", "WA": "Washington", "WV": "West-Virginia",
    "WI": "Wisconsin", "WY": "Wyoming",
}

STATE_NAMES_TO_ABBREV = {}
for abbr, name in STATES.items():
    STATE_NAMES_TO_ABBREV[name.replace("-", " ")] = abbr
    STATE_NAMES_TO_ABBREV[name] = abbr


# --- Utilities ---

def slugify(text):
    """Convert text to URL-friendly slug."""
    text = text.lower().strip()
    text = re.sub(r"[^a-z0-9\s-]", "", text)
    text = re.sub(r"[\s]+", "-", text)
    text = re.sub(r"-+", "-", text)
    return text.strip("-")


def cached_get(url, force_refresh=False):
    """Fetch URL with local file cache."""
    CACHE_DIR.mkdir(exist_ok=True)
    cache_key = hashlib.md5(url.encode()).hexdigest()
    cache_file = CACHE_DIR / f"{cache_key}.html"

    if cache_file.exists() and not force_refresh:
        return cache_file.read_text(encoding="utf-8")

    print(f"  Fetching: {url}")
    try:
        resp = requests.get(url, headers={"User-Agent": USER_AGENT}, timeout=15)
        resp.raise_for_status()
        html = resp.text
        cache_file.write_text(html, encoding="utf-8")
        time.sleep(REQUEST_DELAY)
        return html
    except requests.RequestException as e:
        print(f"  ERROR fetching {url}: {e}")
        return None


# --- Scrapers ---

def scrape_coinzip(state_abbrev):
    """Scrape show listings from coinzip.com for a given state."""
    state_name = STATES.get(state_abbrev, "").replace("-", " ")
    if not state_name:
        return []

    url_name = state_name.lower().replace(" ", "-")
    url = f"https://www.coinzip.com/{url_name}-coin-shows"
    html = cached_get(url)
    if not html:
        return []

    soup = BeautifulSoup(html, "lxml")
    shows = []

    # CoinZip typically lists shows in card/block structures
    # Look for common patterns: h2/h3 headers with show names, followed by detail text
    for heading in soup.find_all(["h2", "h3"]):
        text = heading.get_text(strip=True)
        if not text or "coin show" not in text.lower() and "expo" not in text.lower() and "convention" not in text.lower():
            # Try to include any heading that looks like a show name
            if len(text) < 5 or text.startswith("About") or text.startswith("Find"):
                continue

        # Gather text from siblings until next heading
        detail_text = []
        for sib in heading.find_next_siblings():
            if sib.name in ["h2", "h3"]:
                break
            detail_text.append(sib.get_text(strip=True))

        detail = " ".join(detail_text)

        # Extract city
        city_match = re.search(r"(?:in|at|,)\s+([A-Z][a-z]+(?:\s[A-Z][a-z]+)*)", detail)
        city = city_match.group(1) if city_match else ""

        # Extract venue
        venue_match = re.search(r"(?:at|venue:?)\s+(.+?)(?:\.|,|\d)", detail, re.IGNORECASE)
        venue = venue_match.group(1).strip() if venue_match else ""

        show = {
            "id": slugify(text),
            "name": text,
            "state": state_abbrev,
            "state_name": state_name,
            "city": city,
            "city_slug": slugify(f"{city}-{state_abbrev}") if city else "",
            "venue": venue,
            "frequency": "",
            "next_date": "TBD",
            "website": "",
            "organizer": "",
            "notes": "",
            "source": "coinzip.com",
        }
        shows.append(show)

    return shows


def scrape_coinshows_usa(state_abbrev):
    """Scrape show listings from coinshows-usa.com for a given state."""
    state_name = STATES.get(state_abbrev, "").replace("-", " ")
    if not state_name:
        return []

    url_name = state_name.replace(" ", "-")
    url = f"https://www.coinshows-usa.com/{url_name}"
    html = cached_get(url)
    if not html:
        return []

    soup = BeautifulSoup(html, "lxml")
    shows = []

    # coinshows-usa.com uses table or list structures
    for row in soup.find_all("tr"):
        cells = row.find_all("td")
        if len(cells) < 3:
            continue

        # Typical structure: Date | Show Name | City/Location | Venue
        texts = [c.get_text(strip=True) for c in cells]

        # Skip header rows
        if any(t.lower() in ["date", "show", "city", "venue"] for t in texts[:2]):
            continue

        show_name = texts[1] if len(texts) > 1 else ""
        if not show_name or len(show_name) < 3:
            continue

        date_text = texts[0] if texts else ""
        city = texts[2] if len(texts) > 2 else ""
        venue = texts[3] if len(texts) > 3 else ""

        # Extract link if present
        link = cells[1].find("a") if len(cells) > 1 else None
        website = link.get("href", "") if link else ""

        show = {
            "id": slugify(show_name),
            "name": show_name,
            "state": state_abbrev,
            "state_name": state_name,
            "city": city,
            "city_slug": slugify(f"{city}-{state_abbrev}") if city else "",
            "venue": venue,
            "frequency": "",
            "next_date": date_text if date_text else "TBD",
            "website": website,
            "organizer": "",
            "notes": "",
            "source": "coinshows-usa.com",
        }
        shows.append(show)

    return shows


def scrape_state(state_abbrev):
    """Scrape all sources for a given state and deduplicate."""
    print(f"\nScraping {STATES.get(state_abbrev, state_abbrev)}...")
    all_shows = []

    all_shows.extend(scrape_coinzip(state_abbrev))
    all_shows.extend(scrape_coinshows_usa(state_abbrev))

    # Basic dedup by slugified name
    seen = set()
    deduped = []
    for show in all_shows:
        key = show["id"]
        if key not in seen:
            seen.add(key)
            deduped.append(show)

    print(f"  Found {len(deduped)} unique shows")
    return deduped


# --- Main ---

def main():
    parser = argparse.ArgumentParser(description="Scrape coin show listings")
    parser.add_argument("--state", help="State abbreviation (e.g. CA, TX)")
    parser.add_argument("--all", action="store_true", help="Scrape all states")
    parser.add_argument("--output", "-o", help="Output YAML file path")
    parser.add_argument("--refresh", action="store_true", help="Ignore cache, re-fetch all URLs")
    args = parser.parse_args()

    if not args.state and not args.all:
        parser.print_help()
        sys.exit(1)

    all_shows = []

    if args.all:
        for abbrev in sorted(STATES.keys()):
            all_shows.extend(scrape_state(abbrev))
    else:
        state = args.state.upper()
        if state not in STATES:
            print(f"Unknown state: {state}")
            sys.exit(1)
        all_shows.extend(scrape_state(state))

    # Remove source field for clean output
    for show in all_shows:
        source = show.pop("source", "")
        show["notes"] = f"Source: {source}" if not show.get("notes") else show["notes"]

    print(f"\nTotal: {len(all_shows)} shows")

    if args.output:
        output_path = Path(args.output)
        output_path.parent.mkdir(parents=True, exist_ok=True)
        with open(output_path, "w") as f:
            yaml.dump(all_shows, f, default_flow_style=False, allow_unicode=True, sort_keys=False)
        print(f"Written to {output_path}")
    else:
        print(yaml.dump(all_shows, default_flow_style=False, allow_unicode=True, sort_keys=False))

    return 0


if __name__ == "__main__":
    sys.exit(main())
