# Script to fill missing localization keys for he/de/fr/es using English placeholders
import os, re, sys, pathlib, shutil

ROOT_DIR = pathlib.Path(__file__).resolve().parent
BASE_KEYS_FILE = ROOT_DIR / 'base_keys.txt'
LANG_CODES = ['he', 'de', 'fr', 'es']
PROJECT_DIR = ROOT_DIR / 'SeniorNutritionApp'
BASE_LPROJ_FILE = PROJECT_DIR / 'Base.lproj' / 'Localizable.strings'

if not BASE_KEYS_FILE.exists():
    print('base_keys.txt not found', file=sys.stderr)
    sys.exit(1)

# Load base keys
with BASE_KEYS_FILE.open(encoding='utf-8') as f:
    base_keys = [line.strip().strip('" ') for line in f if line.strip()]

for lang in LANG_CODES:
    lproj_dir = PROJECT_DIR / f'{lang}.lproj'
    localizable_path = lproj_dir / 'Localizable.strings'
    if not localizable_path.exists():
        # Create file from Base.lproj English if available
        if BASE_LPROJ_FILE.exists():
            print(f'{lang}: creating new Localizable.strings from Base')
            shutil.copy(BASE_LPROJ_FILE, localizable_path)
        else:
            # create empty file
            localizable_path.parent.mkdir(parents=True, exist_ok=True)
            localizable_path.touch()
        continue

    with localizable_path.open(encoding='utf-8') as f:
        existing_content = f.read()

    existing_keys = set(re.findall(r'"(.*?)"\s*=\s*"', existing_content))
    missing = [k for k in base_keys if k not in existing_keys]

    if not missing:
        print(f'{lang}: no missing keys')
        continue

    print(f'{lang}: adding {len(missing)} keys')
    with localizable_path.open('a', encoding='utf-8') as f:
        f.write('\n\n/* Auto-filled missing keys */\n')
        for key in missing:
            # Use English as placeholder translation
            placeholder = key
            f.write(f'"{key}" = "{placeholder}";\n')

print('Localization files updated.') 