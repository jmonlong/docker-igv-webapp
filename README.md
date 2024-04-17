# igv-webapp + http-server

This container can serve an [HTTP server](https://www.npmjs.com/package/http-server) with [igv-webapp](https://github.com/igvteam/igv-webapp) (a Web application with [igv.js](https://github.com/igvteam/igv.js)).
For example, to use IGV remotely on an HPC or on a cloud instance.

It uses an igv.js version that is [slightly tweaked](https://github.com/jmonlong/igv.js). 
The only change I made was the color palette when coloring reads by tags. 
The original colors were too dark and hid the other read markers.

## Usage

Local files will be looked for relative to the `/igv/webapp` directory in the container. 
Hence, to visualize a file at `/my/local/path/to/file.bam` you could ask docker to either:

- bind the volume with something like `-v /my/local/path/to:/igv/webapp/data` and find the file at *URL* `/data/file.bam` in the app
- bind the volume with `-v /my/local/path/to:/igv/webapp/my/local/path` and find the file at *URL* `/my/local/path/to/file.bam` in the app

Note: **don't** bind to `/igv/webapp`, e.g. with `-v /my/local/path/to:/igv/webapp`, because the igv-webapp files would be lost.

## Use on an HPC

On an HPC, start the docker container (maybe on a screen or interactive job):

```
docker run -it -v /dir/upstream/of/bams:/igv/webapp/dir/upstream/of/bams -p 8887:8080 quay.io/jmonlong/igvwebapp http-server /igv/webapp
```

Note: on a shared HPC, you might need to change the port (here *8887*) to one that is not already in use.

Once this is running on the HPC, create a SSH tunnel to forward the ports to your local computer. 
On you local machine: 

```
ssh -N -L 8887:localhost:8887 USER@HOST
```

You should now be able to access the app in a web browser at [localhost:8887](localhost:8887).

Visualize the local BAMs by adding a *Track* by *URL*, and specifying the path as `dir/upstream/of/bams/path/to/file.bam`.

## Use on a cloud instance

1. Start an instance with HTTP/HTTPS access enabled.
2. Optional. Set up the instance
    1. Install Docker
    2. Download data to visualize
3. Start the app on the instance with `docker run -it -v /dir/upstream/of/bams:/igv/webapp/dir/upstream/of/bams -p 80:8080 quay.io/jmonlong/igvwebapp http-server /igv/webapp`
4. Access on a web browser at the public IP of the instance.

