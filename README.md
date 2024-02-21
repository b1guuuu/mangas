# mangas
A flutter-based mobile application to manage your manga collection

## Table of Contents
- [Screenshots](#screenshots)
- [What can it do](#what-can-it-do)
- [How to install](#how-to-install)
    - [Pre-compiled](#pre-compiled)
    - [Compile the project](#compile-the-project)
- [Post install](#post-install)


## Screenshots
![Main screens screenshots](./.github/images/combined.png "Main screens schreenshots")


## What can it do
- Create a local database from a .json file with this structure:
```json
[
    {
        "title": "title",
        "status": "status",
        "publisher": "publisher",
        "volumes": [
            {
                "volumeNumber": 1,
                "release": "release",
                "price": 0,
                "cover": "cover"
            },...
        ],
        "totalVolumes": 1
    },...
]
```

- Filter mangas by title
- List all volumes of a manga
- Add mangas to collection
- Add invidual volumes to a collection or all the volumes
- Display missing volumes in all collections
- Update local database from a .json file with this structure:
```json
{
    "insert": [
        {
            "title": "title",
            "status": "status",
            "publisher": "publisher",
            "volumes": [
                {
                    "volumeNumber": 1,
                    "release": "release",
                    "price": 0,
                    "cover": "cover"
                },...
            ],
            "totalVolumes": 1
        },...
    ],
    "update": [
        {
            "title": "title",
            "status": "status",
            "publisher": "publisher",
            "volumes": [
                {
                    "volumeNumber": 1,
                    "release": "release",
                    "price": 0,
                    "cover": "cover"
                },...
            ],
            "totalVolumes": 1
        },...
    ]
}
```
- Export collection to .json file and all related mangas and volumes

## How to install
### Pre-compiled
You can download a pre-compiled .apk from the [releases](https://github.com/b1guuuu/mangas/releases) page.

### Compile the project
> **REQUIREMENTS:** You will need to setup a flutter development enviroment. See their [docs](https://docs.flutter.dev/get-started/install).

Clone the repository, open the folder and compile it yourself:
- Android: <code>flutter build apk --split-per-abi</code>

## Post install
>After installation you **must provide a .json file** to create the local database.

1. Go to settings (gear icon on top left corner of screen)
2. Tap "Iniciar banco de dados (db.json)"
3. Select a .json with this structure:
    ```json
    [
        {
            "title": "title",
            "status": "status",
            "publisher": "publisher",
            "volumes": [
                {
                    "volumeNumber": 1,
                    "release": "release",
                    "price": 0,
                    "cover": "cover"
                },...
            ],
            "totalVolumes": 1
        },...
    ]
    ```
    - You can find an example of a full db.json file [here](https://github.com/b1guuuu/mangas-scrapper/blob/main/db.json)
4. Wait the completion of the database setup
5. Done