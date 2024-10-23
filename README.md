# Ghost Blog Theme

A simple repository to create Ghost Themes with TailwindCSS, HTMx and AlpineJS 

## Install

```shell
make installdirs configure images
```

Or simply

```shell
make install
```

## Start

Run the development stack

```shell
make up
```

Create a new theme

```shell
export THEME=Example && make new-theme
```

Change `name` in  `app/themes/$THEME/package.json`

Build a distributed version of the theme for Ghost 

```shell
export THEME=Example && make build-theme
```

If finished or deprecated, you can remove the theme with

```shell
export THEME=Example && make remove-theme
```
