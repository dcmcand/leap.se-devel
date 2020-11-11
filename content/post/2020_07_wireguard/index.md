---
title: On wireguard
summary: in which we answer recurring questions about not using wireguard
subtitle: some why-s and why-not-s
authors:
- admin
tags:
- ramblings
- whynot
categories:
- vpn
date: "2020-07-01T00:00:00Z"
lastmod: "2020-07-01T00:00:00Z"
featured: false
draft: false
---

Our VPN is built on top of [OpenVPN](https://openvpn.net/), a well tested and
widely used technology that has been around for almost two decades. As most
software with enough history it has grown with a lot of features and code
complexity. This is great as it has everything that we need to provide a stable
service, but at the same time it brings now and then security issues. The
OpenVPN team has been really good at handling them in a timely manner and in
LEAP we've been lucky to have designed our VPN in a way that prevented us from
being affected by most of the ones that have appeared in the last years.

Since a few years there is a newcomer to the free software VPNs:
[WireGuard](https://wireguard.com/). WireGuard uses nice modern cryptography
primitives, a pretty simple protocol and has a small code base. This makes it a
very fast VPN and probably less prone to security issues.

If WireGuard is so great why don't we ditch OpenVPN and use WireGuard instead?
WireGuard is great, but (yes, there is always a "but") it wasn't designed for
our use cases and it is not trivial to make it work for us.

WireGuard uses UDP, which is great for speed. But many of our users are in
networks that don't allow UDP traffic and for them to be able to connect we
need the VPN to support TCP. We are currently using OpenVPN on TCP mode, but
our plan for the future is to dynamically use UDP if available and if not to
fall back to TCP.

Some time ago there was a discussion about [TCP support in the wireguard
mailing
list](https://lists.zx2c4.com/pipermail/wireguard/2018-March/002496.html), with
proposed solutions like using
[ssf](https://github.com/securesocketfunneling/ssf),
[socat](http://www.dest-unreach.org/socat/) or
[udptunnel](http://www1.cs.columbia.edu/~lennox/udptunnel/). All of them sound
a bit hacky, one extra moving piece that can break.

Another problem is that WireGuard doesn't provide dynamic IP allocation. We
don't know in advance who will be connected to assign static IPs to each
client.  We rely on OpenVPN to do it dynamically each time a client connects.
In WireGuard we would need to build some tooling around to do all this IP
assignment without the service operators getting the possibility to correlate
users and clients to IPs.

Besides all these technical issues there is a security issue, the
authentication protocol of WireGuard is not Forward Secret. That means an
observer recording all conversations only need to wait until the server long
term secret key gets compromised to be able to figure out which client produced
each connection. Let me remark, this doesn't mean that the attacker can decrypt
the traffic, they only see the authentication key, so they can pinpoint a
client being the same in different connections.

While this is a flaw, it is clearly an improvement over TLS 1.2 with client
certificates, which we are currently using with OpenVPN. Previously to TLS 1.3
(the latest version) if you authenticate the clients using a cert, which we use
to avoid having a list of users, the cert is sent unencrypted. That means that
currently an observer does not even need a compromised server private key to
track the users. We do minimize that by rotating the cert frequently and we are
preparing a migration to TLS 1.3, that solves this problem by transferring the
cert over a forward secret channel.

The dynamic IP allocation and the lack of forward secrecy for client
identifiers are being worked on in a separate tool named
[wg-dynamic](https://git.zx2c4.com/wg-dynamic/about/docs/idea.md) which does
handle the IP allocation and rotates the client identifier. So maybe in the
future those will be solved when wg-dynamic becomes more mature.

Right now for us adopting WireGuard would require a lot of development work to
get around those issues and to get a new technology stable enough to be used in
production. We already have our hands full maintaining the existing service and
prefer to prioritize our energies on providing a more stable and smooth VPN.
