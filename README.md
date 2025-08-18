# **JexaVM**

**JexaVM** is a Bash script to initialize custom Linux containers using
**proot**, with support for multiple distros, nickname customization,
and rainbow prompts.

------------------------------------------------------------------------

``` text
       _             __      ____  __
      | |            \ \    / /  \/  |
      | | _____  ____ \ \  / /| \  / |
  _   | |/ _ \ \/ / _` \ \/ / | |\/| |
 | |__| |  __/>  < (_| |\  /  | |  | |
  \____/ \___/_/\_\__,_| \/   |_|  |_|
```

------------------------------------------------------------------------

## ✨ Features

-   ✅ Multi-distro support (Debian, Void, Arch, Alpine, Fedora)\
-   ✅ Automatic **rootfs download & extraction**\
-   ✅ **Rainbow prompt** with distro name and nickname\
-   ✅ **Nickname system** (persistent, stored in `config.ini`)
    -   Command `:changenick` to update nickname live\
-   ✅ Detects if a distro is already installed\
-   ✅ Simple and interactive usage

------------------------------------------------------------------------

## 📦 Supported Distros

  Distro          Status
  --------------- ----------
  Debian Trixie   ✅ Ready
  Void Linux      ✅ Ready
  Arch Linux      ✅ Ready
  Alpine Linux    ✅ Ready
  Fedora 39       ✅ Ready

------------------------------------------------------------------------

## 🚀 Usage

1.  Clone or download the repository.\

2.  Make the script executable:

    ``` bash
    chmod +x install.sh
    ```

3.  Run it:

    ``` bash
    ./install.sh
    ```

------------------------------------------------------------------------

## ⚙️ Workflow

1.  On startup, the script will:
    -   Ask for a **nickname** (saved in `config.ini`).\
    -   Show the list of supported distros.\
    -   Download the selected rootfs if not present.\
    -   Extract and initialize the container.
2.  Inside the container:
    -   Prompt looks like:

            Nickname@Distro:~

        (rainbow-colored ✨)

    -   Use `:changenick` to change your nickname live.

------------------------------------------------------------------------

## 📝 Notes

-   Rootfs files are downloaded from
    [termux/proot-distro](https://github.com/termux/proot-distro/releases).\
-   Extraction ignores `/dev` for safety.\
-   Works without root privileges.

------------------------------------------------------------------------
