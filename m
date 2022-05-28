Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 646AA536A7B
	for <lists+linux-bcache@lfdr.de>; Sat, 28 May 2022 05:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353941AbiE1D5Y (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 May 2022 23:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiE1D5X (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 May 2022 23:57:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFAB35EBCD;
        Fri, 27 May 2022 20:57:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CFED6CE26B8;
        Sat, 28 May 2022 03:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707C8C34100;
        Sat, 28 May 2022 03:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653710236;
        bh=hPdRKRSbGNtynRtPm6nGXdsDdNGivcCdDbeGsIRnlj4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BSN/iHMUqDTJpKStecbkXDNjqvyffM67d9WHWbR296ZE9fuj1QJa4TL/US4Kz6OxR
         JL2xUiiLxfK541zlWnV9Tv7QR2PGnJEl6Ox10wC5fNW8S07/xf/HKGonemGuGEm5H8
         65TfQXM1M0VIbhHWQ1j9OWXYOtoYgV7Doms56j5YqNYjcXglovYWIs/vUd4BGnwnzC
         ZFFufetr/p9Wlk6e7l3uHVooTwse/U4Ntok+bfXqpv3sVG9aveZR+rG8wlUyQxg4sd
         FBifA60Oqx1p5K1qs+LWIPQFlqvCWYeeUaonUC68m/fkJ/3R33nw6LYnKcxMxHmZR6
         3qsXrYzngn7eA==
Date:   Fri, 27 May 2022 21:57:12 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Christoph Hellwig <hch@infradead.org>, Coly Li <colyli@suse.de>,
        Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>,
        linux-block@vger.kernel.org
Subject: Re: [RFC] Add sysctl option to drop disk flushes in bcache? (was:
 Bcache in writes direct with fsync)
Message-ID: <YpGdmDeCZXBF2IOH@kbusch-mbp.dhcp.thefacebook.com>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com>
 <958894243.922478.1652201375900@mail.yahoo.com>
 <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net>
 <27ef674d-67e-5739-d5d8-f4aa2887e9c2@ewheeler.net>
 <YoxuYU4tze9DYqHy@infradead.org>
 <5486e421-b8d0-3063-4cb9-84e69c41b7a3@ewheeler.net>
 <Yo1BRxG3nvGkQoyG@kbusch-mbp.dhcp.thefacebook.com>
 <7759781b-dac-7f84-ff42-86f4b1983ca1@ewheeler.net>
 <Yo28kDw8rZgFWpHu@infradead.org>
 <a2ed37b8-2f4a-ef7a-c097-d58c2b965af3@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2ed37b8-2f4a-ef7a-c097-d58c2b965af3@ewheeler.net>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, May 27, 2022 at 06:52:22PM -0700, Eric Wheeler wrote:
> Hi Keith, Christoph:
> 
> Adriano who started this thread (cc'ed) reported that setting 
> queue/write_cache to "write back" provides much higher latency on his NVMe 
> than "write through"; I tested a system here and found the same thing.
> 
> Here is Adriano's summary:
> 
>         # cat /sys/block/nvme0n1/queue/write_cache
>         write through
>         # ioping -c10 /dev/nvme0n1 -D -Y -WWW -s4K
>         ...
>         min/avg/max/mdev = 60.0 us / 78.7 us / 91.2 us / 8.20 us
>                                      ^^^^ ^^
> 
>         # for i in /sys/block/*/queue/write_cache; do echo 'write back' > $i; done
>         # ioping -c10 /dev/nvme0n1 -D -Y -WWW -s4K
>         ...
>         min/avg/max/mdev = 1.81 ms / 1.89 ms / 2.01 ms / 82.3 us
>                                      ^^^^ ^^

With the "write back" setting, I find that the writes dispatched from ioping
will have the force-unit-access bit set in the commands, so it is expected to
take longer.
