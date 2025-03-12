# ✨Warp

This short powershell script addresses a recurring issue I face when programming : **slow navigation to frequently used directories**.

**Warp** lets you assign an alias to a directory in your file system, to speed up the navigation to this directory.

## Usage

_Create a warp_

```powershell
/path/to/my/project $ warp set myProject
# ✨ Added warp 'myProject' here.
```

_Navigate to a warp_

```powershell
/another/location $ warp to myProject
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

_Remove a warp _

```powershell
$ warp remove myProject
# ✅ Removed warp
```

## Installation

### Windows

This script requires Powershell (**>= 7.1**) in order to be executed.
Don't forget to set powershell's **execution policy** to `RemoteSigned` (see [this](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.5))

⚠️ Don't forget to add the the script to your PATH variable.
You can either clone the project, or simply download the `warp.ps1` file.

### Linux / MacOs

This script requires bash in order to be executed.In the following example, warp will be installed in **user's home** (`~`). If you want to install warp somewhere else, please adapt the filepaths accordingly.

1. You can either clone this repository or simply download the `warp.sh` file.

2. If needed, add permissions to execute `warp.sh`

   - `chmod u+x warp.sh`

3. Edit your `~/.bashrc` file to include this code

   - ```bash
     		 warp(){
          source ~/warp.sh # Adapt this part to your installation location and/or method
      }
     ```

## Future improvements

- Remove the necessity of the `to` keyword when navigating to a warp. This syntax should become possible: `warp myProject`
- Unit testing
