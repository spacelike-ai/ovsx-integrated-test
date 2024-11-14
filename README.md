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

Das Image kann auch mittels Tekton Task in `tekton.yaml` gebaut und gepusht werden:

```yaml
apiVersion: tekton.dev/v1beta1
kind: TaskRun
metadata:
  name: ovsx-build
spec:
  taskRef:
    name: ovsx-build
  params:
    - name: source_repo
      value: ... Das Repository von diesem README.
    - name: devspaces_version
      value: 3.12
    - name: output_registry
      value:
    - name: output_image_namespace
      value:
    - name: output_image_tag
      value:
    - name: upstream_registry_user
      value: ... Benutzer für den Lesezugriff auf die RedHat Registry.
    - name: upstream_registry_password
      value:
```

Das erzeuge image wird auf `<output_registry>/<output_image_namespace>/pluginregistry-rhel8:output_image_tag` gepusht.
