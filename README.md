<a href="https://offen.dev/">
    <img src="https://offen.github.io/press-kit/offen-material/gfx-GitHub-Offen-logo.svg" alt="Offen logo" title="Offen" width="150px"/>
</a>

# Demo
Script to download and start an Offen demo

---

This script is availabe at `https://demo.offen.dev` and can be used as a convenience shortcut for running an Offen demo on your system:

```sh
curl -sS https://demo.offen.dev | bash
```

---

### Upload the file to AWS S3

Using valid credentials you can update the script using:

```
$ aws s3 cp demo.sh s3://offen-demo
```
