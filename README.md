# nizu

## User

Update the username `yourusername` with your username...

```sh
find . -maxdepth 1 -type f -name "*.nix" | \
xargs -I {} \
sed -i '' -e 's/yourusername/mango/g' {}
```

## Steam

- [flatpak](https://flathub.org/apps/com.valvesoftware.Steam) <- using this
- [nix wiki](https://nixos.wiki/wiki/Steam)

### Launch Issues

> It's launching properly after I fixed an issue with **wofi**.

Having issues with **steam** possibly due to my machine and hyprland config. I was using the flatpack version but it suddenly stopped working. Then switched to the nix version and it wouldn't open.

#### Hacks

```sh
pkill steam

# then run steam
steam

# OR

steam --reset
```

### Exit Issues

When exiting steam it get's stuck because of the `gldriverquery` process, killing the process shuts steam down.

