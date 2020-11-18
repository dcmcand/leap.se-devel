---
title: Packaging in GNU/Linux
summary: what is our current packaging strategy
subtitle: why snap and not ... ?
authors:
- admin
tags:
- ramblings
- whynot
- snap
- flatpack
- linux
categories:
- packaging
date: "2020-06-18T00:00:00Z"
lastmod: "2020-06-18T00:00:00Z"
featured: false
draft: false
---

We get frequently asked why we don't do flatpack or appimage or arch packages 
or... for our VPN. There are many distros and many package managers in GNU/Linux. Sadly our 
time is limited and we have to decide what we focus our energies on. And 
currently in GNU/Linux we are focusing our work on [snap 
packages](https://snapcraft.io/riseup-vpn).

We know, snap has many problems. Packages often don't work well in distros not 
based on debian ([#272](https://0xacab.org/leap/bitmask-vpn/-/issues/272), 
[#77](https://0xacab.org/leap/bitmask-vpn/-/issues/77)). It's a centralized 
platform, controlled by one commercial entity and [not everybody agrees with 
their decisions](https://jatan.blog/2020/05/02/ubuntu-snap-obsession-has-snapped-me-off-of-it/).

Our primary target audience has always been the less computer-savvy users. In 
GNU/Linux most of them use ubuntu. That has been our main reason to focus 
our energies on supporting ubuntu first. And snap makes it very easy to include 
software in ubuntu which is convenient too.  Also the most used 
distros around are debian based, and snap usually works well on those.

Knowing that not everybody likes snap, we produce [.deb 
packages](https://riseup.net/en/vpn/linux#package-installation) as well and we 
do our best to keep them up to date.

One of the other options we have explored is flatpack. I think its architecture 
is great, its security is really nice and it solves some of the problems of snap 
(it's not centralized, the control is in the users, ...). But flatpack is designed 
to containerize the applications, making it impossible to package something like a 
VPN, because it needs to modify the network configuration and the firewall 
which is by design not allowed by flatpack. So flatpack is not an option for us.

Snap does containerize as well, but this is something that you can disable when 
you make the snap by using the 'classic' mode. We do that to be able to package 
a VPN into snap.

From the core team we might not have the time in the near future to work on any 
other packages. But we will welcome any contributors. If you would like to 
package the VPN for your favourite package manager we'll be really happy to 
help. Don't hesitate to [open an 
issue](https://0xacab.org/leap/bitmask-vpn/-/issues/new) to discuss it there, 
pass by on 
[irc](https://kiwiirc.com/client/irc.freenode.net:+6697/?nick=guest?#leap) or 
write to our [mailing list](discuss-subscribe@leap.se).
