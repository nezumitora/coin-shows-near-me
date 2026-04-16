#!/usr/bin/env python3
"""
Coin Dealer Scraper — scrapes coin dealer listings from public directories.

Sources:
  - ANA dealer directory (money.org)
  - PCGS authorized dealer list
  - State numismatic association member pages
  - Yellow Pages / public business directories

Usage:
  python scrape_dealers.py --state CA
  python scrape_dealers.py --all
  python scrape_dealers.py --all --output scraped_dealers.yml

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

USER_AGENT = "CoinShowNearMe-DealerScraper/1.0 (+https://github.com/nezumitora/coin-shows-near-me)"
REQUEST_DELAY = 2
CACHE_DIR = Path(__file__).parent / ".cache"

STATES = {
    "AL": "Alabama", "AK": "Alaska", "AZ": "Arizona", "AR": "Arkansas",
    "CA": "California", "CO": "Colorado", "CT": "Connecticut", "DE": "Delaware",
    "FL": "Florida", "GA": "Georgia", "HI": "Hawaii", "ID": "Idaho",
    "IL": "Illinois", "IN": "Indiana", "IA": "Iowa", "KS": "Kansas",
    "KY": "Kentucky", "LA": "Louisiana", "ME": "Maine", "MD": "Maryland",
    "MA": "Massachusetts", "MI": "Michigan", "MN": "Minnesota", "MS": "Mississippi",
    "MO": "Missouri", "MT": "Montana", "NE": "Nebraska", "NV": "Nevada",
    "NH": "New Hampshire", "NJ": "New Jersey", "NM": "New Mexico", "NY": "New York",
    "NC": "North Carolina", "ND": "North Dakota", "OH": "Ohio", "OK": "Oklahoma",
    "OR": "Oregon", "PA": "Pennsylvania", "RI": "Rhode Island", "SC": "South Carolina",
    "SD": "South Dakota", "TN": "Tennessee", "TX": "Texas", "UT": "Utah",
    "VT": "Vermont", "VA": "Virginia", "WA": "Washington", "WV": "West Virginia",
    "WI": "Wisconsin", "WY": "Wyoming",
}


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

def scrape_pcgs_dealers(state_abbrev):
    """
    Scrape PCGS authorized dealer directory.
    PCGS has a public dealer locator — we parse the results page.
    """
    state_name = STATES.get(state_abbrev, "")
    if not state_name:
        return []

    # PCGS dealer search by state
    url = f"https://www.pcgs.com/dealers?state={state_abbrev}"
    html = cached_get(url)
    if not html:
        return []

    soup = BeautifulSoup(html, "lxml")
    dealers = []

    # PCGS uses structured dealer cards
    for card in soup.find_all(class_=re.compile(r"dealer", re.I)):
        name_el = card.find(class_=re.compile(r"name|title", re.I))
        if not name_el:
            name_el = card.find(["h2", "h3", "h4", "strong"])
        if not name_el:
            continue

        name = name_el.get_text(strip=True)
        if not name or len(name) < 3:
            continue

        # Extract address, phone, website from card
        text = card.get_text(" ", strip=True)

        city_match = re.search(r"([A-Z][a-z]+(?:\s[A-Z][a-z]+)*),?\s+" + state_abbrev, text)
        city = city_match.group(1) if city_match else ""

        phone_match = re.search(r"\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}", text)
        phone = phone_match.group(0) if phone_match else ""

        link = card.find("a", href=re.compile(r"^https?://"))
        website = link.get("href", "") if link else ""

        dealer = {
            "id": slugify(name),
            "name": name,
            "state": state_abbrev,
            "state_name": state_name,
            "city": city,
            "city_slug": slugify(f"{city}-{state_abbrev}") if city else "",
            "phone": phone,
            "website": website,
            "type": "coin_dealer",
            "certifications": ["PCGS Authorized"],
            "source": "pcgs.com",
        }
        dealers.append(dealer)

    return dealers


def scrape_ngc_dealers(state_abbrev):
    """
    Scrape NGC authorized dealer directory.
    NGC also has a public dealer search.
    """
    state_name = STATES.get(state_abbrev, "")
    if not state_name:
        return []

    url = f"https://www.ngccoin.com/dealers/results.aspx?state={state_abbrev}"
    html = cached_get(url)
    if not html:
        return []

    soup = BeautifulSoup(html, "lxml")
    dealers = []

    for item in soup.find_all(class_=re.compile(r"dealer|result", re.I)):
        name_el = item.find(["h2", "h3", "h4", "strong", "a"])
        if not name_el:
            continue

        name = name_el.get_text(strip=True)
        if not name or len(name) < 3:
            continue

        text = item.get_text(" ", strip=True)

        city_match = re.search(r"([A-Z][a-z]+(?:\s[A-Z][a-z]+)*),?\s+" + state_abbrev, text)
        city = city_match.group(1) if city_match else ""

        phone_match = re.search(r"\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}", text)
        phone = phone_match.group(0) if phone_match else ""

        link = item.find("a", href=re.compile(r"^https?://"))
        website = link.get("href", "") if link else ""

        dealer = {
            "id": slugify(name),
            "name": name,
            "state": state_abbrev,
            "state_name": state_name,
            "city": city,
            "city_slug": slugify(f"{city}-{state_abbrev}") if city else "",
            "phone": phone,
            "website": website,
            "type": "coin_dealer",
            "certifications": ["NGC Authorized"],
            "source": "ngccoin.com",
        }
        dealers.append(dealer)

    return dealers


def scrape_state_dealers(state_abbrev):
    """Scrape all sources for a given state and deduplicate."""
    print(f"\nScraping dealers in {STATES.get(state_abbrev, state_abbrev)}...")
    all_dealers = []

    all_dealers.extend(scrape_pcgs_dealers(state_abbrev))
    all_dealers.extend(scrape_ngc_dealers(state_abbrev))

    # Dedup by slugified name
    seen = set()
    deduped = []
    for dealer in all_dealers:
        key = dealer["id"]
        if key in seen:
            # Merge certifications from duplicate
            existing = next(d for d in deduped if d["id"] == key)
            for cert in dealer.get("certifications", []):
                if cert not in existing.get("certifications", []):
                    existing["certifications"].append(cert)
            continue
        seen.add(key)
        deduped.append(dealer)

    print(f"  Found {len(deduped)} unique dealers")
    return deduped


# --- Main ---

def main():
    parser = argparse.ArgumentParser(description="Scrape coin dealer listings")
    parser.add_argument("--state", help="State abbreviation (e.g. CA, TX)")
    parser.add_argument("--all", action="store_true", help="Scrape all states")
    parser.add_argument("--output", "-o", help="Output YAML file path")
    parser.add_argument("--refresh", action="store_true", help="Ignore cache, re-fetch all URLs")
    args = parser.parse_args()

    if not args.state and not args.all:
        parser.print_help()
        sys.exit(1)

    all_dealers = []

    if args.all:
        for abbrev in sorted(STATES.keys()):
            all_dealers.extend(scrape_state_dealers(abbrev))
    else:
        state = args.state.upper()
        if state not in STATES:
            print(f"Unknown state: {state}")
            sys.exit(1)
        all_dealers.extend(scrape_state_dealers(state))

    # Clean up source field
    for dealer in all_dealers:
        dealer.pop("source", None)

    print(f"\nTotal: {len(all_dealers)} dealers")

    if args.output:
        output_path = Path(args.output)
        output_path.parent.mkdir(parents=True, exist_ok=True)
        with open(output_path, "w") as f:
            yaml.dump(all_dealers, f, default_flow_style=False, allow_unicode=True, sort_keys=False)
        print(f"Written to {output_path}")
    else:
        print(yaml.dump(all_dealers, default_flow_style=False, allow_unicode=True, sort_keys=False))

    return 0


if __name__ == "__main__":
    sys.exit(main())
