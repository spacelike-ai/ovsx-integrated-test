Abhängigkeiten installieren:
```sh
dnf install -y podman npm jq git
```

In die RedHat Docker registry einloggen:
```sh
podman login registry.redhat.io
```

In der Datei `additional-extensions.json` befinden sich die zusätzlich zu installierenden Erweiterungen.

Image bauen:
```sh
./build-image.sh 3.12 <image_registry> <image_org> <image_tag>
```

Image pushen:
```sh
podman push "<image_registry>/<image_org>/pluginregistry-rhel8:<image_tag>"
```

Die `CheCluster` resource anpassen:
```yaml
spec:
  components:
    pluginRegistry:
      deployment:
        containers:
          - image: <image_registry>/<image_org>/pluginregistry-rhel8:<image_tag>
      openVSXURL: ''
```
