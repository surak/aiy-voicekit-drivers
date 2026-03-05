KVER ?= $(shell uname -r)
KDIR ?= /lib/modules/$(KVER)/build
EXTRA_DIR ?= /lib/modules/$(KVER)/extra

.PHONY: all build modules aiy sound leds clean install help

all: build

build: modules

modules: aiy sound leds

aiy:
	$(MAKE) -C aiy KVER=$(KVER) KDIR=$(KDIR)

sound:
	$(MAKE) -C sound KVERSION=$(KVER)

leds:
	$(MAKE) -C leds KVERSION=$(KVER)

clean:
	$(MAKE) -C aiy clean KVER=$(KVER) KDIR=$(KDIR)
	$(MAKE) -C sound clean KVERSION=$(KVER)
	$(MAKE) -C leds clean KVERSION=$(KVER)

install: modules
	install -d "$(EXTRA_DIR)"
	install -m 0644 aiy/aiy/mfd/aiy-io-i2c.ko "$(EXTRA_DIR)/"
	install -m 0644 aiy/aiy/gpio/gpio-aiy-io.ko "$(EXTRA_DIR)/"
	install -m 0644 aiy/aiy/pwm/pwm-aiy-io.ko "$(EXTRA_DIR)/"
	install -m 0644 aiy/aiy/iio/adc/aiy-adc.ko "$(EXTRA_DIR)/"
	install -m 0644 sound/rl6231.ko "$(EXTRA_DIR)/"
	install -m 0644 sound/rt5645.ko "$(EXTRA_DIR)/"
	install -m 0644 sound/snd-aiy-voicebonnet.ko "$(EXTRA_DIR)/"
	install -m 0644 leds/leds-ktd202x.ko "$(EXTRA_DIR)/"
	depmod -a "$(KVER)"

help:
	@echo "Targets:"
	@echo "  make / make build  Build all legacy V2 modules"
	@echo "  make clean         Clean all legacy V2 module artifacts"
	@echo "  sudo make install  Install modules into /lib/modules/\$$KVER/extra"
