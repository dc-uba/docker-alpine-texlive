![](docker_latex_banner.png)

# docker-alpine-texlive
[![](https://images.microbadger.com/badges/version/ivanpondal/alpine-latex.svg)](https://microbadger.com/images/ivanpondal/alpine-latex "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/ivanpondal/alpine-latex.svg)](https://microbadger.com/images/ivanpondal/alpine-latex "Get your own image badge on microbadger.com")

> Minimal TeX Live installation Docker image

The purpose of this image is to have a TeX Live installation with the bare
minimum needed to produce Computer Science reports.

## Setup

1. [Install Docker](https://www.docker.com/get-docker)
2. Add your user to the Docker group (this is to avoid using `sudo` each time
   you need to run a command):

```
sudo groupadd docker
sudo usermod -aG docker $USER
```

Log out and log back in so that your group membership is re-evaluated.

3. Download the image:

```
docker pull ivanpondal/alpine-latex
```

## Run

1. Change your working directory to the latex project root.
2. Run `pdflatex` on your main file:

```
docker run --rm -v $PWD:/workdir:z ivanpondal/alpine-latex pdflatex <TEX_FILE>
```
