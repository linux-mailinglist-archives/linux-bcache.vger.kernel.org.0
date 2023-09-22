Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288687AB374
	for <lists+linux-bcache@lfdr.de>; Fri, 22 Sep 2023 16:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbjIVOW4 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 22 Sep 2023 10:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbjIVOWy (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 22 Sep 2023 10:22:54 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A228B102
        for <linux-bcache@vger.kernel.org>; Fri, 22 Sep 2023 07:22:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5C44F21B6C;
        Fri, 22 Sep 2023 14:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1695392566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RuKLOYHuBkY94Um+vMtAmn3wOefE3RYhQGZqvJ9O/IY=;
        b=olKALr67WiWrRmM+jcoUUTebwNKLqslufaxGyXzghLAUWnWqiU+c9aJRwDxggJGrMQ9ZAo
        l6rd0fSn+IGqBB9ejxKF81JR6lk4NL5cPw2KL1IFGc6gtJdtp7n+wldSxAY5Td8kklOA/I
        gLy4hQLiL1VCn8NY95KsgfBlb6v1kC8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1695392566;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RuKLOYHuBkY94Um+vMtAmn3wOefE3RYhQGZqvJ9O/IY=;
        b=eRIk3Qucb4pbVVzXrq04sWUZ2B6MRejEmLoEOY/VAgN6FuGtpwMWNNxf4mYjwJ99Le6WdF
        U79ZxZkn4o0wNgCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6D90513478;
        Fri, 22 Sep 2023 14:22:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id JnBNLTSjDWUAewAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 22 Sep 2023 14:22:44 +0000
Date:   Fri, 22 Sep 2023 22:22:42 +0800
From:   Coly Li <colyli@suse.de>
To:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
Cc:     linux-bcache@vger.kernel.org
Subject: Re: Unusual value of optimal_io_size prevents bcache initialization
Message-ID: <iymfluasxp5webd4hbgxqsuzq6jbeojti7lfue5e4wd3xcdn4x@fcpmy7uxgsie>
References: <4fd61b55-195f-8dc5-598e-835bd03a00ec@devo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4fd61b55-195f-8dc5-598e-835bd03a00ec@devo.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, Sep 22, 2023 at 03:26:46PM +0200, Andrea Tomassetti wrote:
> Hi Coly,
> recently I was testing bcache on new HW when, while creating a bcache device
> with make-bcache -B /dev/nvme16n1, I got this kernel WARNING:
> 
> ------------[ cut here ]------------
> WARNING: CPU: 41 PID: 648 at mm/util.c:630 kvmalloc_node+0x12c/0x178
> Modules linked in: nf_conntrack_netlink nf_conntrack nf_defrag_ipv6
> nf_defrag_ipv4 nfnetlink_acct wireguard libchacha20poly1305 chacha_neon
> poly1305_neon ip6_udp_tunnel udp_tunnel libcurve25519_generic libchacha
> nfnetlink ip6table_filter ip6_tables iptable_filter bpfilter nls_iso8859_1
> xfs libcrc32c dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua bcache
> crc64 raid0 aes_ce_blk crypto_simd cryptd aes_ce_cipher crct10dif_ce
> ghash_ce sha2_ce sha256_arm64 ena sha1_ce sch_fq_codel drm efi_pstore
> ip_tables x_tables autofs4
> CPU: 41 PID: 648 Comm: kworker/41:2 Not tainted 5.15.0-1039-aws
> #44~20.04.1-Ubuntu
> Hardware name: DEVO new fabulous hardware/, BIOS 1.0 11/1/2018
> Workqueue: events register_bdev_worker [bcache]
> pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : kvmalloc_node+0x12c/0x178
> lr : kvmalloc_node+0x74/0x178
> sp : ffff80000ea4bc90
> x29: ffff80000ea4bc90 x28: ffffdfa18f249c70 x27: ffff0003c9690000
> x26: ffff00043160e8e8 x25: ffff000431600040 x24: ffffdfa18f249ec0
> x23: ffff0003c1d176c0 x22: 00000000ffffffff x21: ffffdfa18f236938
> x20: 00000000833ffff8 x19: 0000000000000dc0 x18: 0000000000000000
> x17: ffff20de6376c000 x16: ffffdfa19df02f48 x15: 0000000000000000
> x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
> x11: 0000000000000000 x10: 0000000000000000 x9 : ffffdfa19df8d468
> x8 : ffff00043160e800 x7 : 0000000000000010 x6 : 000000000000c8c8
> x5 : 00000000ffffffff x4 : 0000000000012dc0 x3 : 0000000100000000
> x2 : 00000000833ffff8 x1 : 000000007fffffff x0 : 0000000000000000
> Call trace:
>  kvmalloc_node+0x12c/0x178
>  bcache_device_init+0x80/0x2e8 [bcache]
>  register_bdev_worker+0x228/0x450 [bcache]
>  process_one_work+0x200/0x4d8
>  worker_thread+0x148/0x558
>  kthread+0x114/0x120
>  ret_from_fork+0x10/0x20
> ---[ end trace e326483a1d681714 ]---
> bcache: register_bdev() error nvme16n1: cannot allocate memory
> bcache: register_bdev_worker() error /dev/nvme16n1: fail to register backing
> device
> bcache: bcache_device_free() bcache device (NULL gendisk) stopped
> 
> I tracked down the root cause: in this new HW the disks have an
> optimal_io_size of 4096. Doing some maths, it's easy to find out that this
> makes bcache initialization fails for all the backing disks greater than 2
> TiB. Is this a well-known limitation?
> 
> Analyzing bcache_device_init I came up with a doubt:
> ...
> 	n = DIV_ROUND_UP_ULL(sectors, d->stripe_size);
> 	if (!n || n > max_stripes) {
> 		pr_err("nr_stripes too large or invalid: %llu (start sector beyond end of
> disk?)\n",
> 			n);
> 		return -ENOMEM;
> 	}
> 	d->nr_stripes = n;
> 
> 	n = d->nr_stripes * sizeof(atomic_t);
> 	d->stripe_sectors_dirty = kvzalloc(n, GFP_KERNEL);
> ...
> Is it normal that n is been checked against max_stripes _before_ its value
> gets changed by a multiply it by sizeof(atomic_t) ? Shouldn't the check
> happen just before trying to kvzalloc n?
> 

The issue was triggered by d->nr_stripes which was orinially from
q->limits.io_opt which is 8 sectors. Normally the backing devices announce
0 sector io_opt, then d->stripe_size will be 1<< 31 in bcache_device_init().
Number n from DIV_ROUND_UP_ULL() will be quite small. When io_opt is 8
sectors, number n from DIV_ROUND_UP_ULL() is possible to quite big for
a large size backing device e.g. 2TB.

Therefore the key point is not checking n after it is multiplified by
sizeof(atomic_t), the question is from n itself -- the value is too big.

Maybe bcache should not directly use q->limits.io_opt as d->stripe_size,
it should be some value less than 1<<31 and aligned to optimal_io_size.

After the code got merged into kernel for 10+ years, it is time to improve
this calculation :-)

> Another consideration, stripe_sectors_dirty and full_dirty_stripes, the two
> arrays allocated using n, are being used just in writeback mode, is this
> correct? In my specific case, I'm not planning to use writeback mode so I
> would expect bcache to not even try to create those arrays. Or, at least, to
> not create them during initialization but just in case of a change in the
> working mode (i.e. write-through -> writeback).

Indeed, Mingzhe Zou (if I remember correctly) submitted a patch for this
idea, but it is blocked by other depending patches which are not finished
by me. Yes I like the idea to dynamically allocate/free d->stripe_sectors_dirty
and d->full_dirty_stripes when they are necessary. I hope I may help to make
the change go into upstream sooner.

I will post a patch for your testing.

Thanks in advance.

-- 
Coly Li
