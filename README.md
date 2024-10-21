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

## Troubleshooting

Falls der folgende Fehler auftritt:
#13 0.724 🏃 Checking /tmp/vsix/SAS.sas-lsp-1.11.0.vsix ... [/tmp/vsix/SAS.sas-lsp-1.11.0.vsix]
#13 0.731   End-of-central-directory signature not found.  Either this file is not
#13 0.731   a zipfile, or it constitutes one disk of a multi-part archive.  In the
#13 0.731   latter case the central directory and zipfile comment will be found on
#13 0.731   the last disk(s) of this archive.

überprüfe ob die Extension den richtigen Dateityp hat:
file SAS.sas-lsp-1.11.0.vsix
SAS.sas-lsp-1.11.0.vsix: Zip archive data, at least v2.0 to extract, compression method=deflate
Die Datei sollte nicht gzip Format haben, was beispielsweise auftreten kann, wenn sie mit curl heruntergeladen wurde.

Nicht:
SAS.sas-lsp-1.11.0.vsix: gzip compressed data, max speed, from FAT filesystem (MS-DOS, OS/2, NT), original size modulo 2^32 8721202
