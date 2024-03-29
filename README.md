# Docker-Compose Publish

A GitHub Action that builds and publishes images built from docker-compose file.

## Fork notice

This repository is fork from [pennsignals/publish_docker-compose](https://github.com/pennsignals/publish_docker-compose)

## Features

No need to manually build and publish each dockerfile.

Built image are being published to github packages after build.

Images are named after services name in `docker-compose.yml` file.

By default, published images are connected to the repository.

All images have git commit sha tag.

If your action runs on tag push, the image will be tagged with git tag.

For version tag you can set `version` input, which overrides git tags.

Last published image has `latest` tag.

## Example Usage
```
    - name: Publish
      uses: belezyakov/publish_docker-compose@v1.0.2
      with:
        version: '1.0.0' # optional
        docker_compose: 'docker-compose.yml' # required
        repo_token: "${{ secrets.GITHUB_TOKEN }}" # optional
        repo_connect: true # optional
```

## Input

Below is a breakdown of the expected action inputs.

### `version`

Tag to be published.

### `docker_compose`

Which docker-compose file to use.

### `repo_token`

Repository (secret) token.

### `repo_connect`

Images to repository link flag `[true/false]`, set `false` not to link.
