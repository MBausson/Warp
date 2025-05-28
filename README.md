# ✨Warp

This short powershell script addresses a recurring issue I face when programming : **slow navigation to frequently used directories**.

**Warp** lets you assign an alias to a directory in your file system, allowing you to quickly access a given directory in your system with a simple name.

## Usage

_Create a warp_

```powershell
# Given we're in /path/to/my/project
$ warp set myProject
# ✨ Added warp 'myProject' here.
```

_Navigate to a warp_

```powershell
# Given we're in /another/location
$ warp to myProject
# ✨ Warped to myProject.
# Now, the current working directory is /path/to/my/project
```

_List all registered warps_

```powershell
$ warp list
# 📖 Registered warps
#
# 'myProject' ➡️ /path/to/my/project
#
# Total: 1 warps.
```

_Remove a warp_

```powershell
$ warp remove myProject
# ✅ Removed warp
```

## Installation

A python installation script is provided in the repository:

```bash
#  In warp's directory
$ python3 ./install.py --shell <bash | powershell> --location ~
```

The Warp script will be installed at the given `location`, which defaults to your home directory (`~`).

For powershell users: ⚠️ Don't forget to set powershell's **execution policy** to `RemoteSigned` (see [this](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.5))

**If you do not want to use this script, please proceed to a manual installation described below.**

### Windows

**Note:** This script requires Powershell (**>= 7.1**) in order to be executed.

You will need to add the script location to your `PATH`.

⚠️ Don't forget to set powershell's **execution policy** to `RemoteSigned` (see [this](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.5))

### Linux / MacOs

In the following example, warp will be installed in **user's home** (`~`). If you want to install warp somewhere else, please adapt the filepaths accordingly.

1. Place the `warp.sh` file to a certain location, for example, your home (`~`)
2. Add permissions to the script: `chmod u+x warp.sh`
3. Edit your `~/.bashrc` file to include this code

   ```bash
   warp {
        source ~/warp.sh # Adapt this part to your installation location
    }
   ```

## Future improvements

- Testing (both powershell & bash versions)
