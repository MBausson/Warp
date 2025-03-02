# ✨Warp

This short powershell script addresses a recurring issue I face when programming : **slow navigation to frequently used directories**.

**Warp** lets you assign an alias to a directory in your file system, to speed up the navigation to this directory.

## Usage

*Create a warp*

```powershell
/path/to/my/project $ warp set myProject
# ✨ Added warp 'myProject' here.
```

*Navigate to a warp*

```powershell
/another/location $ warp to myProject
# ✨ Warped to myProject.
# Now, the current working directory is /path/to/my/project
```

*List all registered warps*

```powershell
$ warp list
# 📖 Registered warps
# 
# 'myProject' ➡️ /path/to/my/project
# 
# Total: 1 warps.
```

*Remove a warp*

```powershell
$ warp remove myProject
# ✅ Removed warp
```


## Installation

This script requires Powershell to be installed on your system.  
You can either clone the project, or simply download the `warp.ps1` file.  

⚠️ Don't forget to add the the script to your PATH variable.

## Future improvements

- Remove the necessity of the `to` keyword when navigating to a warp. This syntax should become possible: `warp myProject`
- Implementation in `bash`. For now, warp requires Powershell to be installed on your system.
- Unit testing
