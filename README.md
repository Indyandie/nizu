# nizu

Update the username `yourusername` with your username...

```sh
find . -maxdepth 1 -type f -name "*.nix" | \
xargs -I {} \
sed -i '' -e 's/yourusername/mango/g' {}
```