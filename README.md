# Docker-Compose Publish

A GitHub Action that builds and publishes images built from docker-compose file.

## Features

Each dockerfile target must have a `LABEL name="<name>"`. This is used to name the published package.


## Example Usage
```
    - name: Publish
      uses: belezyakov/publish_docker-compose@v1.0.0
      with:
        version: '1.0.0' # optional
        docker_compose: 'docker-compose.build.yml' # required
        repo_token: "${{ secrets.GITHUB_TOKEN }}" # optional
```
