Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A51486E5C
	for <lists+linux-bcache@lfdr.de>; Fri,  7 Jan 2022 01:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343586AbiAGAM5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 6 Jan 2022 19:12:57 -0500
Received: from mx.ewheeler.net ([173.205.220.69]:54532 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232819AbiAGAM5 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 6 Jan 2022 19:12:57 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 84E6081;
        Thu,  6 Jan 2022 16:12:56 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id qcarr-0d7S8J; Thu,  6 Jan 2022 16:12:55 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 979E140;
        Thu,  6 Jan 2022 16:12:55 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 979E140
Date:   Thu, 6 Jan 2022 16:12:53 -0800 (PST)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     linux-bcache@vger.kernel.org
cc:     Coly Li <colyli@suse.de>, mingzhe.zou@easystack.cn
Subject: Hot-grow bcache backing device.
Message-ID: <8c3eff7-ab0-c627-d0df-5ebdd1ecc1bb@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coli an Mingzhe:

Since Mingzhe brought up full_dirty_stripes in the other thread: some time 
ago I was looking into hot-resize of bcache devices.  Usually I resize by 
unregister/re-register but it would be nice to do hot.

While reviewing the code for feasibility the only snag I found was safely 
resizing full_dirty_stripes allocation before updating d->nr_stripes and 
calling set_capacity(d->disk, bdev_nr_sectors(dc->bdev)).

I think hot resize of a bdev should be simple and I have a few questions:

1. Should the newly resized bits of full_dirty_stripes just be zeroed?

2. Besides d->nr_stripes and full_dirty_stripes, does anything else need 
   to change size?  Long ago Kent confirmed that the cachedev structures 
   are bdev-size agnostic.

3. Are there any bcache locks to hold when resizing?

4. Is there something like "realloc()" to grow the allocation (I didn't 
   see kvzrealloc())---or would we need to kvzalloc into a new buffer, 
   copy in, and free the old one?

For reference, from bcache_device_init():
        n = DIV_ROUND_UP_ULL(sectors, d->stripe_size);
        [...]
        d->nr_stripes = n;

        n = d->nr_stripes * sizeof(atomic_t);
        d->stripe_sectors_dirty = kvzalloc(n, GFP_KERNEL);
        if (!d->stripe_sectors_dirty)
                return -ENOMEM;

        n = BITS_TO_LONGS(d->nr_stripes) * sizeof(unsigned long);
>>>>    d->full_dirty_stripes = kvzalloc(n, GFP_KERNEL); 



--
Eric Wheeler
