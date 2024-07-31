# Nix Overlays

Overlays are a pattern for taking and modifying an existing package set. This allows us to pin packages to a specific version, different from what is provided by NixPkgs, create custom patches or change default values.

[Documentation](https://nixos.wiki/wiki/Overlays)

## Example

```nix
# An overlay is a function returning the final attribute set by modifying the previous attribute set
final: prev: {
  foo = prev.foo.bar = "buz";
}
```
