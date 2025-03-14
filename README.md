# e-galax-touch-driver

> A snap containing the eGalaxTouch driver

## Here's what AI says on how to "install" the driver on Ubuntu Core

Installing the eGalax touchscreen driver on Ubuntu Core presents some challenges 
due to its read-only filesystem and security model. Here are the recommended steps for Ubuntu Core:

1. Package the driver as a snap by creating a `snapcraft.yaml`
2. Build and publish the snap `snapcraft`
3. Install the snap on the Ubuntu Core device with `sudo snap install egalax-touch-driver_1.0_amd64.snap --dangerous`
4. Configure the snap to start on boot `snap set egalax-touch-driver autostart=true`
5. Grant necessary permissions: `snap connect egalax-touch-driver:hardware-observe` and `snap connect egalax-touch-driver:raw-usb`
6. Reboot the device to apply changes: `sudo reboot`

### Example snapgcraft.yaml

Below is an example of a snapcraft.yaml file for packaging the eGalax touchscreen driver as a snap. 
This configuration assumes the driver is installed via the provided shell script (setup.sh) 
and requires access to hardware interfaces like USB and raw input.

```yaml
name: egalax-touch-driver
version: '1.0'
summary: eGalax USB Touchscreen Driver
description: |
  This snap packages the eGalax touchscreen driver for Ubuntu Core. It ensures 
  proper touchscreen functionality by installing and running the eGTouch daemon.
base: core22
grade: stable
confinement: strict

apps:
  egalaxtouch:
    command: bin/eGTouchD
    daemon: simple
    restart-condition: always
    plugs:
      - raw-usb
      - hardware-observe
      - input

parts:
  egalax-driver:
    plugin: nil
    source: .
    override-build: |
      mkdir -p $SNAPCRAFT_PART_INSTALL/bin
      cp setup.sh $SNAPCRAFT_PART_INSTALL/
      chmod +x $SNAPCRAFT_PART_INSTALL/setup.sh
      $SNAPCRAFT_PART_INSTALL/setup.sh --auto-install --prefix=$SNAPCRAFT_PART_INSTALL/bin
    stage-packages:
      - libudev1
      - libx11-6

```

Explanation of Key Sections

#### Metadata:

* name: The unique name of the snap.
* version: Version of the driver.
* summary and description: Provide details about the snap.

#### Base:

* core22: Specifies the runtime base for compatibility with Ubuntu Core.

#### Confinement:

* strict: Ensures security by isolating the snap from the host system.

#### Apps:

Defines the eGTouch daemon (eGTouchD) as a service that runs automatically.
Uses plugs to grant access to required hardware interfaces (raw-usb, hardware-observe, and input).

#### Parts:

The e-galax-driver part specifies how to build and package the driver.
The override-build script copies and runs the provided setup.sh to install the driver into the snap environment.
The stage-packages section includes necessary dependencies for running the driver (e.g., libudev1, libx11-6).

See the [whole conversation](https://www.perplexity.ai/search/on-a-ubuntu-desktop-i-have-a-t-RmY1pZpjQIOCgjb7JrxOBg)