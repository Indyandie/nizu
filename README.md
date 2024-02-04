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

## OBS Studio

- [Plugins](https://nixos.wiki/wiki/OBS_Studio)
- [Pipewire](https://nixos.wiki/wiki/PipeWire)

## Hyprland

- [XNM1](https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles)

## Dev

- [vscodium](https://nixos.wiki/wiki/VSCodium)

## Javascript

- [NPM Packages](https://matthewrhone.dev/nixos-npm-globally)

### Node

#### Yarn

##### Corepack

Enabling **corepack** aka `corepack enable` is very tricky in nixos. I still dont fully understand the configuration that I ended up with. Using the configuration in [home-manager](./home-manager.nix) and running `corepack prepare` made everyone happy, **Yarn** and **GIthub actions**. We'll see what happens.

