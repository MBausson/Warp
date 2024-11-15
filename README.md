# ✨Warp

This short powershell script addresses a recurring issue I face when programming : **slow navigation through directories**, especially through frequently accessed directories.

**Warp** lets you assign a name to a directory in your file system, and navigate directly to a directory via its name.

## Examples

*Create a warp*

```powershell
PS C:/path/to/my/project> warp set myProject
# ✨ Added warp 'myProject' here.
```

*Navigate to a warp*

```powershell
PS C:/another/location> warp to myProject
# ✨ Warped to myProject.
# Now, the current working directory is C:/path/to/my/project
```

*Remove a warp*

```powershell
$ warp remove myProject
# ✅ Removed warp
```

*List all registered warps*

```powershell
$ warp list
# 📖 Registered warps
# 
# 'myProject' ➡️ C:/path/to/my/project
# 
# Total: 1 warps.
```

## Future improvements

- Remove the necessity of the `to` keyword when navigating to a warp. This syntax should become possible: `warp myProject`
- Implementation in `bash`. For now, warp requires Powershell to be installed on your system.
