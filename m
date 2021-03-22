Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93775344AB2
	for <lists+linux-bcache@lfdr.de>; Mon, 22 Mar 2021 17:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhCVQJ5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 22 Mar 2021 12:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbhCVQJb (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 22 Mar 2021 12:09:31 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE161C061762
        for <linux-bcache@vger.kernel.org>; Mon, 22 Mar 2021 09:09:29 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id v2so7740004vsq.11
        for <linux-bcache@vger.kernel.org>; Mon, 22 Mar 2021 09:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=8bfiPb54R3PveBoanB3skXrw/7+gLM5S1WgUXRifPBw=;
        b=Z6fc6TgPdmsxBww/yqNpUJvnUhPWHHr89j68OjEJeSe+N21NznSNaorHnzRHskSO/r
         It/XCLcByIR5xzHi8HivKBLU5hpKzU/RMRrFWv+MFfvsyeC8tpY0CuEdW0IKisiZ39Yu
         Rzep0aTx+sKz1wgfteDBLnLFaDu2pOuARwpgNxb/VHz9RUXhxex4Y+hlnOGG+xTVapWd
         dBYu2clRoM9nG+al9hQ6odCex6MSgM/8W3z6MuJfRLyLkThjkcfLW7Gq+Pi1iP/lOHJM
         FQ3kHEHWeKTAD25UzrSApgbG30bDwg5hxQX3Pj5O37N6XPNyAOfm3isjiMDyBGHdc7hy
         IKhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=8bfiPb54R3PveBoanB3skXrw/7+gLM5S1WgUXRifPBw=;
        b=cPpLwaf2TZE6TSdv5PhHH4coFmduqCzay215jtHE4Oj7zoM64KNB0Mm1gmRk+fF5pD
         FWRoUO4IOtKl85u+lhoFgi+PKTNp7BHNoCqsYVpSdgjfaKgYjyScaxOp9dejRQPvCChP
         3yM6bRJ6DqgnjZd/xHGIxhjLGurLupOBIYQCDb8bjqHFOO6bP9gaNtc2bq8eDf+guZDH
         3Fv/3sgUHbOjH4+JeJefrJhUL28rfNXtpfOiCwzexUDNlLH1s4zBBwCO7bRmgwrBiyYX
         IqLQw4xYztCble/PoTGbH27Eu3jhi014XOXzyuQZsWfzmgc+WvJo0ORUzRgbRC1YNN08
         hWvg==
X-Gm-Message-State: AOAM532I/y57K3/4YLROvZ8rFzavB9dsml5Ac8nLYJAx34N3T/fJsUPV
        Q1uraVpwjf/43arLffLsM9XZb2wZtIdN8aT2QAFVtqAUI6o=
X-Google-Smtp-Source: ABdhPJyb8F+07ACnN5z4BIV9wS8JG0akh3QPGTHbS/iba1OF/ygdtN/yIORSOQw4j1wBgimXZJ/cUzv9mj4TGdVV3Mg=
X-Received: by 2002:a67:d99c:: with SMTP id u28mr348366vsj.53.1616429368665;
 Mon, 22 Mar 2021 09:09:28 -0700 (PDT)
MIME-Version: 1.0
From:   Marc Smith <msmith626@gmail.com>
Date:   Mon, 22 Mar 2021 11:09:17 -0500
Message-ID: <CAH6h+hfr4vkdk8x38oVmZAGABJ-ecfW-QGs09yTSKkF7=VFpaQ@mail.gmail.com>
Subject: Cache Device Failure Expectations
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi,

I'm using bcache in a Linux 5.4.69 kernel, and I'm testing transient
cache device failures with a backing backing device using 'writeback'
mode, and with several gigabytes of dirty data (that has not reached
the backing device).

In my first test, the cache devices are using the default "unregister"
value for the "errors" sysfs attribute knob (for bcache cache devices
in /sys/fs/bcache/...). When I induce a cache device failure, bcache
backing devices stop, the cache device is detached from all affected
backing devices, and I/O errors are returned on subsequent access
attempts to the backing devices. This all works as I think it would
based on how it's configured.

The downside to "unregister" is when I reboot the system (with the
cache block device reinstated/working), the backing devices come up
but with no cache device attached! So this certainly causes file
system corruption as dirty data is not present on the backing device
(since the backing device is started without the cache device).

On the second test run, I used "panic" for the "unregister" sysfs
value, and this works cleaner, most of the time. When I induce a cache
block device failure, the system then panics, but the cache device
stays associated with the backing devices -- and dirty data can then
flush to the backing device. On this second test, when the system
booted back up, one cache device failed to start:
...
[ 333.116149] bcache: prio_read() bad csum reading priorities
[ 333.116151] bcache: prio_read() bad magic reading priorities
[ 333.116636] bcache: bch_cache_set_error() bcache: error on
2f255344-bb44-44b9-930d-90f23b384e9c:
[ 333.116637] corrupted btree at bucket 473, block 44, 504 keys
[ 333.116638] bcache: bch_cache_set_error() , disabling caching
[ 333.116638]
[ 333.116649] bcache: register_cache() error dm-12: failed to run cache set
[ 333.116650] bcache: register_bcache() error : failed to register device
...

This seemed to be a temporary problem -- I rebooted the system again,
and then the bcache cache device started without issue. I did not
check for data loss / corruption in this instance.

A third test run using "panic" mode resulted in everything coming back
up normally, and seemingly operating just fine (no cache/backing
device start errors). I did not check for data loss / corruption in
this instance either.


So, I guess just a couple questions to solidify my expectations on
this type of transient cache device failure (cache block device fails,
but then can come back later fully intact):
- It sounds like for handling this case, "panic" mode for the "errors"
sysfs attribute is best since it does not detach the cache device from
backing devices
- Is this safe/reliable (transient cache device failures)? Obviously
it's not preferred, but should I expect any problems should this occur
and using "panic" mode? No metadata corruption on the cache device is
expected?


Thanks for your time. Appreciate the great work on bcache!

--Marc
