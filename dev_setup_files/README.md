## Copy the yocto final image to a SDcard
Make sure your configuration includes

```
IMAGE_FSTYPES += "wic wic.bmap"
```
Run the following command (as an example) to copy the final image to the SD card. Note that the final image is usually found under `./build/tmp/deploy/images/raspberrypi3-64/`:
```
sudo bmaptool copy ./sample-image-raspberryppi3-64.wic /dev/mmcblk0
```
For more information, read [here](https://www.yoctoproject.org/docs/2.4.2/dev-manual/dev-manual.html#creating-partitioned-images-using-wic).

Additionally, consider the following links:

- https://www.schneier.com/blog/archives/2014/01/security_risks_9.html
- https://elinux.org/images/6/6f/Security-issues.pdf