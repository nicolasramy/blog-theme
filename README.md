# Blog Theme

```bash
docker run --rm -d --name blog-theme-ghost -p 3001:2368 -v $PWD/content:/var/lib/ghost/content ghost:3-alpine
docker run --rm -d --name blog-theme-ghost -p 3001:2368 ghost:3-alpine
docker run -d --name blog-theme-ghost -v $PWD/content:/var/lib/ghost/content ghost:3-alpine
```

```bash
docker build -t blog-theme .
docker run --rm -i -t --name blog-theme-dev -v $PWD:/app blog-theme sh
```


```bash
zip -r darkelda.zip darkelda
```

