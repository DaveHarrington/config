#!/usr/bin/env python

# sudo python network_watchdog.py -d

import re
import sys
import time
import logging
import logging.handlers
import subprocess

FAVOUR_WIFI = -50 #ms
WIFI_TARGET = "64.64.30.210"
WIFI_GATEWAY = "192.168.1.1"
# WIFI_GATEWAY = "172.20.0.1" # Lighthouse
USB_TARGET = "50.56.215.46"
USB_GATEWAY = "10.0.1.1"

MIN_SWITCH_DELAY = 0
SLEEP_PERIOD = 1
HYSTERISIS_THRESHOLD = 50 #ms
MAX_FILTER_LEN = 3
BUFF_MIN_LEN = 3

WIFI = 'Wi-Fi'
USB = 'Sierra'

def main():
  logger = get_logger(debug=('-d' in sys.argv))
  wifi_pings = []
  usb_pings = []
  current_network = None
  last_switch_time = 0

  while True:
    setup_routes()
    wifi_pings = push(wifi_pings, ping(WIFI_TARGET))
    logger.debug('wifi pings: ' + str(wifi_pings))
    usb_pings = push(usb_pings, ping(USB_TARGET))
    logger.debug('usb pings: ' + str(usb_pings))

    network = best_network(wifi=wifi_pings, usb=usb_pings)
    logger.debug('current, best: {0} {1}'.format(current_network, network))
    rate_limited = time.time() < last_switch_time + MIN_SWITCH_DELAY
    logger.debug('rate limited: ' + str(rate_limited))
    if (not rate_limited and network and network != current_network):
      logger.debug('setting as main: ' + str(network))
      current_network = set_as_main(network)
      last_switch_time = time.time()

    time.sleep(SLEEP_PERIOD)

def best_network(wifi, usb):
  wifi_ave = average(wifi)
  usb_ave = average(usb)

  if not wifi_ave or not usb_ave:
    if not wifi_ave and not usb_ave:
      return
    return WIFI if wifi_ave else USB

  wifi_ave = max(wifi_ave - FAVOUR_WIFI, 0)

  if abs(wifi_ave - usb_ave) < HYSTERISIS_THRESHOLD:
    return

  return WIFI if wifi_ave < usb_ave else USB

regex = re.compile(r'^\(\d+\) (.*)$')
def set_as_main(network):
  networks = configured_networks()
  networks.sort(key=lambda x: x.find(network), reverse=True)
  set_configured_networks(networks)
  return network

def setup_routes():
  current_routes = local('netstat -nrl')
  if not any([re.search(WIFI_TARGET, x) for x in current_routes]):
    sudo("route add {target} {gateway}".format(
      target=WIFI_TARGET, gateway=WIFI_GATEWAY))
  if not any([re.search(USB_TARGET, x) for x in current_routes]):
    sudo("route add {target} {gateway}".format(
      target=USB_TARGET, gateway=USB_GATEWAY))

ping_regex = re.compile(r'.*= (\d+)')
def ping(addr):
  try:
    ping_raw = local("ping -c 1 -t 1 -s 200 %s" % addr)
  except subprocess.CalledProcessError:
    return
  if len(ping_raw) < 7:
    return
  return int(ping_regex.match(ping_raw[5]).group(1))

############################

def configured_networks():
  networks_raw = sudo("networksetup -listnetworkserviceorder")
  return [m.group(1) for m in [regex.match(l) for l in networks_raw] if m]

def set_configured_networks(networks):
  sudo(["networksetup", "-ordernetworkservices"] + networks, split=False)

def delete_routes():
  sudo("route delete {target} {gateway}".format(
    target=WIFI_TARGET, gateway=WIFI_GATEWAY))
  sudo("route delete {target} {gateway}".format(
    target=USB_TARGET, gateway=USB_GATEWAY))

def get_logger(debug=False):
  logging.basicConfig()
  logger = logging.getLogger('network_watchdog')
  logger.setLevel(logging.DEBUG if debug else logging.INFO)

  return logger

def average(buffer_):
  buff_tmp = [x for x in buffer_ if x]
  if len(buff_tmp) < BUFF_MIN_LEN:
    return
  return sum(buff_tmp) / len(buff_tmp)

def local(cmd, split=True):
  cmd = cmd.split() if split else cmd
  return subprocess.check_output(cmd).split('\n')

sudo = local

def push(buffer_, new_val):
  buffer_.append(new_val)
  if len(buffer_) > MAX_FILTER_LEN:
    buffer_.pop(0)
  return buffer_

if __name__ == "__main__":
  current_networks = configured_networks()
  try:
    main()
  except:
    pass
  finally:
    delete_routes()
    set_configured_networks(current_networks)

