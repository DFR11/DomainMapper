# Helper utilities:
- [subdomain - search for subdomains](#subdomain)
- [verified - checking domain activity](#verified)
- [convert - route converter](#convert)

## subdomain

Скрипт представляет собой парсер, который собирает субдомены (A-записи) указанного пользователем домена используя веб-сайт [rapiddns.io](https://rapiddns.io/subdomain/).
The results are saved to a file.

### Functions

- Loads the page at the specified URL and retrieves subdomains from tables where the record type is "A".
- Tries to repeat the request up to 3 times in case of an error or missing data.
- Stops if the data on the last three pages is the same or if three pages in a row are empty.

### Usage

1. Установите [зависимости](https://github.com/Ground-Zerro/DomainMapper/blob/main/requirements.txt):

   ```bash
   pip install -r requirements.txt
   ```

2. Run the script:

   ```bash
   python subdomain.py
   ```

3. Enter the URL of the domain whose subdomains you want to parse, for example:

   ```
   example.com
   ```

4. The script will start parsing pages and save the found subdomains to the `result.txt` file.

## verified

The script is designed to check domains for their delegation.

### Functions

- Checks domains using DNS servers: Google Public DNS, Cloudflare DNS and Yandex. The thread pool is limited to 40 worker threads.
- Returns the domain status: delegated, parked/inactive, or error.
- If the domain's status has not been confirmed as delegated, it carries out a control check.

### Usage

1. Установите [зависимости](https://github.com/Ground-Zerro/DomainMapper/blob/main/requirements.txt):

   ```bash
   pip install -r requirements.txt
   ```

2. Place the `result.txt` file in the project root directory. The file should contain a list of domains, each on a new line.

3. Run the script:

   ```bash
   python verified.py
   ```

4. The script will check the domains and save the result to the `verified_domains.txt` file.

## convert

A script for processing IP addresses, aggregating them into subnets and formatting routes for various types of network devices.

### Functions

- Loading a list of IP addresses from a file.
- Aggregation of IP addresses in a subnet with masks `/16`, `/24`, or combining several subnets.
- Exclude Cloudflare IP addresses from the final list (if necessary).
- Supports various routing formats:
  - Windows (`route add`)
  - Unix (`ip route`)
  - Keenetic (`ip route` with interface)
  - Mikrotik (`/ip firewall`)
  - WireGuard
  - OpenVPN
  - CIDR (with mask specified)

### Usage

1. Установите [зависимости](https://github.com/Ground-Zerro/DomainMapper/blob/main/requirements.txt):

   ```bash
   pip install -r requirements.txt
   ```

2. Place the file with IP addresses `ip.txt` in the root directory of the project. The file can contain any text and IP addresses in any form - excess will be removed automatically.

3. Run the script:

   ```bash
   python convert.py
   ```

4. Follow the prompts on the screen.
