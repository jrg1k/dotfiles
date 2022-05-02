#!/usr/bin/env python3

from subprocess import run
from json import loads
import os

def main():
    with open("gnome-setup.json", "r") as file:
        settings = loads(file.read())

        for category, subcategory in settings.items():
            print(f"setting {category}:")
            for setting, commands in subcategory.items():
                print(f"{' ':4}applying {setting}:")
                for c in commands:
                    print(f"{' ':8}{c}")
                    run(c, shell=True)
                print()
            print()


if __name__ == "__main__":
    os.chdir(os.path.dirname(__file__))
    main()
