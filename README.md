# ✨Warp

This short powershell script adresses a recurrent issue I face when programming : **slow navigation through directories**, especially through recurrent directories.

**Warp** lets you assign a name to a directory in your file system, and navigate directly to a directory via its name.


## Examples


*Create a warp*

```powershell
$ warp set myProject
# ✨ Added warp 'myProject' here.
```


*Navigate to a warp*

```powershell
$ warp to myProject
# ✨ Warped to myProject.
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
# 'myProject' ➡️ C:\path\to\my\project
# 
# Total: 1 warps.
```
