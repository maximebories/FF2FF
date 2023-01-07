# Font-Files-2-Font-Faces, A Font Face Generator

A shell script to generate a CSS file with @font-face declarations for web fonts in a given directory.

## Usage

Run the script with the following options:

- **-d, --directory**: The directory containing the web fonts. Default is the current directory.
- **-o, --output**: The name of the output CSS file. Default is "fonts.css".
- **-e, --exclude**: A directory to exclude from the search.

For example:

```
./ff2ff.sh -d /path/to/fonts -o my-fonts.css -e /path/to/fonts/excluded-directory
```

## Note

The script sorts @font-face declarations alphabetically by font family name.
