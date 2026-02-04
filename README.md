## Domain Mapper
<details>
  <summary>Что нового (нажать, чтобы открыть)</summary>

- Доабвлены некоторые [оналйн кинотеатры](https://github.com/Ground-Zerro/DomainMapper/blob/main/platforms/dns-onlinetheater.txt). Запрос @Andrey_schumacher
- Добавлены списки от [ITDog](https://t.me/itdoginfo/36).
- Added xBox service. Request @Deni5c
- Запуск в докере. Запрос [Запрос @andrejs82git](https://github.com/Ground-Zerro/DomainMapper/issues/21), [Реализация @MrEagle123](https://github.com/Ground-Zerro/DomainMapper/issues/21#issuecomment-2509565392)
- Опция в config.ini: не добавлять comment="%SERVICE_NAME%" при сохранении IP-адресов в mikrotik формате. [Запрос @ITNetSystem](https://github.com/Ground-Zerro/DomainMapper/issues/45) 
- Изменена кодиовка файла результатов на UTF-8 без BOM. [Запрос @Savanture](https://github.com/Ground-Zerro/DomainMapper/issues/54) 
- [Конвертер маршутов](https://github.com/Ground-Zerro/DomainMapper/tree/main/utilities) как отдельная утилита. [Запрос @Andrey999r](https://github.com/Ground-Zerro/DomainMapper/discussions/43) 
- Добавлен сервис Jetbrains. [Запрос @SocketSomeone](https://github.com/Ground-Zerro/DomainMapper/issues/40)
- Добавлен сервис Discord. [Запрос @AHuMex](https://github.com/Ground-Zerro/DomainMapper/issues/38)
- [Комбинированный режим объединения IP-адресов в подсеть.](https://github.com/Ground-Zerro/DomainMapper/issues/36)
- Возможность загрузки списков сервисов и DNS-серверов из локального файла. [Запрос @Noksa](https://github.com/Ground-Zerro/DomainMapper/issues/26) 
- Вспомагательные [утилиты](https://github.com/Ground-Zerro/DomainMapper/tree/main/utilities) для поиска субдоменов.
- Добавлен сервис Twitch. [Запрос @shevernitskiy](https://github.com/Ground-Zerro/DomainMapper/issues/31)
- Добавлен Yandex DNS сервер. [Запрос @Noksa](https://github.com/Ground-Zerro/DomainMapper/issues/26)
- Option in config.ini: Disable display of information about the loaded configuration.
- Передача имени конфигурационного файла ключом в терминале/командной строке. [Запрос @Noksa](https://github.com/Ground-Zerro/DomainMapper/issues/25)
- Добавлен сервис Github Copilot. [Запрос @aspirisen](https://github.com/Ground-Zerro/DomainMapper/issues/23)
- Keenetic CLI формат сохранения. [Запрос @vchikalkin](https://github.com/Ground-Zerro/DomainMapper/pull/20)
- Wireguard формат сохранения. [Запрос @sanikroot](https://github.com/Ground-Zerro/DomainMapper/issues/18)
- Агрегация маршрутов до /24, /16. [Запрос @sergeeximius](https://github.com/Ground-Zerro/DomainMapper/issues/8)
- OVPN формат сохранения. [Запрос @SonyLo](https://github.com/Ground-Zerro/DomainMapper/pull/13)
- Mikrotik формат сохранения. [Запрос @Shaman2010](https://github.com/Ground-Zerro/DomainMapper/pull/9)

</details>

**Description:** A Python tool designed to resolve DNS names of popular web services to IP addresses.


<details>
  <summary>Поддерживаемые сервисы (нажать, чтобы открыть)</summary>

- [Antifilter - community edition](https://community.antifilter.download/)
- [ITDog Inside](https://github.com/itdoginfo/allow-domains)
- [ITDog Outside](https://github.com/itdoginfo/allow-domains)
- Youtube
- Facebook
- Openai
- Tik-Tok
- Instagram
- Twitter
- Netflix
- Bing
- Adobe
- Apple
- Google
- Torrent Trackers
- Search engines
- [Github сopilot](https://github.com/features/copilot)
- Twitch
- Discord
- Jetbrains
- Xbox
- Telegram
- Personal list

</details>


**Features:**
- Converting domain names of popular services into IP addresses.
- Aggregation of routes in /16 (255.255.0.0) and /24 (255.255.255.0) subnets. Combined mode /24 + /32.
- Cloudflare IP address filtering (optional).
- Eight options for saving results.


**Key Features**
- Ability to select a system, public DNS server or a combination of both.
- Domain name resolution uses each of the specified DNS servers and continues the process until all possible IP addresses are obtained rather than stopping at the first successful response.
- Automatic exclusion of duplicate IP addresses, as well as “stubs” (for example, IP of the DNS servers themselves, redirects to `0.0.0.0` and `localhost`).
- Support for working in "quiet" mode without user interaction - setting through a configuration file.
- In the configuration file, you can specify a command to automatically launch another script or program upon completion of work.


###  Usage:

1. Install dependencies:

   ```bash
   pip install -r requirements.txt
   ```
2. Edit `config.ini` to suit your needs (optional)

3. Run the script:

   ```bash
   python main.py
   ```


<details>
  <summary>Локальный режим работы (нажать, чтобы открыть)</summary>

In this mode, lists of DNS servers and services are loaded from local files in the folder with the script, and not from the network.

To enable loading a list of services from the local `platformdb` file, specify `localplatform = yes` in config.ini.
- `platformdb` file format: service name and path to the local file separated by a colon.
Поддерживается работа как с файлами на локальной машине, так и их загрузка из сети по http(s).
Example:
```
Torrent Truckers: platforms/dns-ttruckers.lst
Search engines: dns-search-engines.txt
Twitch: platforms/service/dns-twitch.txt
Adobe: https://raw.githubusercontent.com/Ground-Zerro/DomainMapper/main/platforms/dns-adobe.txt
```

To enable loading a list of DNS servers from the local `dnsdb` file, specify `localdns = yes` in config.ini.
- `dnsdb` file format: the name of the DNS server and its IP address separated by a colon and a space.
Important - you must specify two IP addresses for each name (you can have the same one), this is necessary for the code to work correctly.
Example:
```
SkyDNS: 77.88.8.8 77.88.8.8
Alternate DNS: 76.76.19.19 76.223.122.150
AdGuard DNS: 94.140.14.14 94.140.15.15
```

Important: the names of services and numbering of DNS servers in config.ini must match those specified in the `platformdb` and `dnsdb` files.

- Domain names file format: one domain per line.
Example:
```
ab.chatgpt.com
api.openai.com
arena.openai.com
```
Specifying a URL instead of a domain name (for example, `ab.chatgpt.com/login` instead of `ab.chatgpt.com`) will result in an error.
</details>


<details>
  <summary>Запуск скрипта с файлом конфигурации, отличным от `config.ini` (нажать, чтобы открыть)</summary>

- You can specify the path to another configuration file when running the script using the `-c` (or `--config`) option. If the parameter is not specified, the `config.ini` file will be used by default.

Example usage: `main.py -c myconfig.ini`, `python main.py -c config2.ini` or `main.py -c srv5.ini`, etc.
</details>


<details>
  <summary>Личный (локальный) список с доменными именами (нажать, чтобы открыть)</summary>

- Create a file `custom-dns-list.txt`, write down the domain names in it and place it next to the script. The list will be automatically picked up upon startup and will appear in the menu as "Custom DNS list".

- Example of a `custom-dns-list.txt` file:
```
ab.chatgpt.com
api.openai.com
arena.openai.com
```
Specifying a URL instead of a domain name (for example, `ab.chatgpt.com/login` instead of `ab.chatgpt.com`) will result in an error.
</details>


<details>
  <summary>Запуск в Docker (нажать, чтобы открыть)</summary>

```
curl -L -s "https://raw.githubusercontent.com/Ground-Zerro/DomainMapper/refs/heads/main/dm-docker.sh" > /tmp/dm-docker.sh && chmod +x /tmp/dm-docker.sh && sh /tmp/dm-docker.sh
```
</details>


<details>
  <summary>Для пользователей Windows, не знающих "How", но кому "really needed" (нажать, чтобы открыть)</summary>

- Загляните в директорию [Windows](https://github.com/Ground-Zerro/DomainMapper/tree/main/Windows) репозитория.
</details>


##### Tested on Ubuntu 20.04, macOS Sonoma and Windows 10/11

## IMPORTANT:
Использование сделанных "someone", а не Вами лично IP-листов и готовых файлов марштутов - **плохая идея** [ЖМИ](https://github.com/Ground-Zerro/DomainMapper/discussions/50)
