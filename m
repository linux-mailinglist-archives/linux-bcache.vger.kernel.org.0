Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46FF67AE05F
	for <lists+linux-bcache@lfdr.de>; Mon, 25 Sep 2023 22:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbjIYUl0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 25 Sep 2023 16:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjIYUl0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 25 Sep 2023 16:41:26 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA652BE
        for <linux-bcache@vger.kernel.org>; Mon, 25 Sep 2023 13:41:19 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 5E63D49;
        Mon, 25 Sep 2023 13:41:19 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id PyaLHV2fbpjP; Mon, 25 Sep 2023 13:41:14 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 54B0545;
        Mon, 25 Sep 2023 13:41:14 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 54B0545
Date:   Mon, 25 Sep 2023 13:41:08 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Coly Li <colyli@suse.de>
cc:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>,
        Bcache Linux <linux-bcache@vger.kernel.org>
Subject: Re: Unusual value of optimal_io_size prevents bcache
 initialization
In-Reply-To: <7BFB15E2-7FC6-40F8-8E26-8F23D12F2CD2@suse.de>
Message-ID: <8e19179-342d-6449-8c9-531fe3fbd16@ewheeler.net>
References: <4fd61b55-195f-8dc5-598e-835bd03a00ec@devo.com> <iymfluasxp5webd4hbgxqsuzq6jbeojti7lfue5e4wd3xcdn4x@fcpmy7uxgsie> <f3bbd0b9-1783-e924-4b8c-c825d8eb2ede@devo.com> <7BFB15E2-7FC6-40F8-8E26-8F23D12F2CD2@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-2120772645-1695674474=:31246"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2120772645-1695674474=:31246
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Sun, 24 Sep 2023, Coly Li wrote:
> > 2023年9月23日 22:29，Andrea Tomassetti <andrea.tomassetti-opensource@devo.com> 写道：
> > 
> > Hi Coly,
> > thank you very much for your quick reply.
> > 
> > On 22/9/23 16:22, Coly Li wrote:
> >> On Fri, Sep 22, 2023 at 03:26:46PM +0200, Andrea Tomassetti wrote:
> >>> Hi Coly,
> >>> recently I was testing bcache on new HW when, while creating a bcache device
> >>> with make-bcache -B /dev/nvme16n1, I got this kernel WARNING:
> >>> 
> >>> ------------[ cut here ]------------
> >>> WARNING: CPU: 41 PID: 648 at mm/util.c:630 kvmalloc_node+0x12c/0x178
> >>> Modules linked in: nf_conntrack_netlink nf_conntrack nf_defrag_ipv6
> >>> nf_defrag_ipv4 nfnetlink_acct wireguard libchacha20poly1305 chacha_neon
> >>> poly1305_neon ip6_udp_tunnel udp_tunnel libcurve25519_generic libchacha
> >>> nfnetlink ip6table_filter ip6_tables iptable_filter bpfilter nls_iso8859_1
> >>> xfs libcrc32c dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua bcache
> >>> crc64 raid0 aes_ce_blk crypto_simd cryptd aes_ce_cipher crct10dif_ce
> >>> ghash_ce sha2_ce sha256_arm64 ena sha1_ce sch_fq_codel drm efi_pstore
> >>> ip_tables x_tables autofs4
> >>> CPU: 41 PID: 648 Comm: kworker/41:2 Not tainted 5.15.0-1039-aws
> >>> #44~20.04.1-Ubuntu
> >>> Hardware name: DEVO new fabulous hardware/, BIOS 1.0 11/1/2018
> >>> Workqueue: events register_bdev_worker [bcache]
> >>> pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> >>> pc : kvmalloc_node+0x12c/0x178
> >>> lr : kvmalloc_node+0x74/0x178
> >>> sp : ffff80000ea4bc90
> >>> x29: ffff80000ea4bc90 x28: ffffdfa18f249c70 x27: ffff0003c9690000
> >>> x26: ffff00043160e8e8 x25: ffff000431600040 x24: ffffdfa18f249ec0
> >>> x23: ffff0003c1d176c0 x22: 00000000ffffffff x21: ffffdfa18f236938
> >>> x20: 00000000833ffff8 x19: 0000000000000dc0 x18: 0000000000000000
> >>> x17: ffff20de6376c000 x16: ffffdfa19df02f48 x15: 0000000000000000
> >>> x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
> >>> x11: 0000000000000000 x10: 0000000000000000 x9 : ffffdfa19df8d468
> >>> x8 : ffff00043160e800 x7 : 0000000000000010 x6 : 000000000000c8c8
> >>> x5 : 00000000ffffffff x4 : 0000000000012dc0 x3 : 0000000100000000
> >>> x2 : 00000000833ffff8 x1 : 000000007fffffff x0 : 0000000000000000
> >>> Call trace:
> >>>  kvmalloc_node+0x12c/0x178
> >>>  bcache_device_init+0x80/0x2e8 [bcache]
> >>>  register_bdev_worker+0x228/0x450 [bcache]
> >>>  process_one_work+0x200/0x4d8
> >>>  worker_thread+0x148/0x558
> >>>  kthread+0x114/0x120
> >>>  ret_from_fork+0x10/0x20
> >>> ---[ end trace e326483a1d681714 ]---
> >>> bcache: register_bdev() error nvme16n1: cannot allocate memory
> >>> bcache: register_bdev_worker() error /dev/nvme16n1: fail to register backing
> >>> device
> >>> bcache: bcache_device_free() bcache device (NULL gendisk) stopped
> >>> 
> >>> I tracked down the root cause: in this new HW the disks have an
> >>> optimal_io_size of 4096. Doing some maths, it's easy to find out that this
> >>> makes bcache initialization fails for all the backing disks greater than 2
> >>> TiB. Is this a well-known limitation?
> >>> 
> >>> Analyzing bcache_device_init I came up with a doubt:
> >>> ...
> >>> n = DIV_ROUND_UP_ULL(sectors, d->stripe_size);
> >>> if (!n || n > max_stripes) {
> >>> pr_err("nr_stripes too large or invalid: %llu (start sector beyond end of
> >>> disk?)\n",
> >>> n);
> >>> return -ENOMEM;
> >>> }
> >>> d->nr_stripes = n;
> >>> 
> >>> n = d->nr_stripes * sizeof(atomic_t);
> >>> d->stripe_sectors_dirty = kvzalloc(n, GFP_KERNEL);
> >>> ...
> >>> Is it normal that n is been checked against max_stripes _before_ its value
> >>> gets changed by a multiply it by sizeof(atomic_t) ? Shouldn't the check
> >>> happen just before trying to kvzalloc n?
> >>> 
> >> The issue was triggered by d->nr_stripes which was orinially from
> >> q->limits.io_opt which is 8 sectors. Normally the backing devices announce
> >> 0 sector io_opt, then d->stripe_size will be 1<< 31 in bcache_device_init().
> >> Number n from DIV_ROUND_UP_ULL() will be quite small. When io_opt is 8
> >> sectors, number n from DIV_ROUND_UP_ULL() is possible to quite big for
> >> a large size backing device e.g. 2TB
> > Thanks for the explanation, that was already clear to me but I didn't included in my previous message. I just quickly hided it with the expression "doing some maths".
> > 
> >> Therefore the key point is not checking n after it is multiplified by
> >> sizeof(atomic_t), the question is from n itself -- the value is too big.
> > What I was trying to point out with when n gets checked is that there are cases in which the check (if (!n || n > max_stripes)) passes but then, because n gets multiplied by sizeof(atomic_t) the kvzalloc fails. We could have prevented this failing by checking n after multiplying it, no?
> 
> I noticed this message, the root cause is a too big ’n’ value, checking it before or after multiplication doesn’t help too much. What I want is to avoid the memory allocation failure, not  to avoid calling kzalloc() if ’n’ value is too big.
> 
> >> Maybe bcache should not directly use q->limits.io_opt as d->stripe_size,
> >> it should be some value less than 1<<31 and aligned to optimal_io_size.
> >> After the code got merged into kernel for 10+ years, it is time to improve
> >> this calculation :-) >
> > Yeah, one of the other doubts I had was exactly regarding this value and if it is still "actual" to calculate it that way. Unfortunately, I don't have the expertise to have an opinion on it. Would you be so kind to share your knowledge and let me understand why it is calculated this way and why is it using the optimal io size? Is it using it to "writeback" optimal-sized blokes?
> > 
> 
> Most of the conditions when underlying hardware doesn’t declare its optimal io size, bcache uses 1<<31 as a default stripe size. It works fine for decade, so I will use it and make sure it is aligned to value of optimal io size. It should work fine. And I will compose a simple patch for this fix.
> 
> >>> Another consideration, stripe_sectors_dirty and full_dirty_stripes, the two
> >>> arrays allocated using n, are being used just in writeback mode, is this
> >>> correct? In my specific case, I'm not planning to use writeback mode so I
> >>> would expect bcache to not even try to create those arrays. Or, at least, to
> >>> not create them during initialization but just in case of a change in the
> >>> working mode (i.e. write-through -> writeback).
> >> Indeed, Mingzhe Zou (if I remember correctly) submitted a patch for this
> >> idea, but it is blocked by other depending patches which are not finished
> >> by me. Yes I like the idea to dynamically allocate/free d->stripe_sectors_dirty
> >> and d->full_dirty_stripes when they are necessary. I hope I may help to make
> >> the change go into upstream sooner.
> >> I will post a patch for your testing.
> > This would be great! Thank you very much! On the other side, if there's anything I can do to help I would be glad to contribute.
> 
> I will post a simple patch for the reported memory allocation failure for you to test soon.
> 
> Thanks.
> 
> Coly Li
> 
> 


Hi Coly and Andrea:

Years ago I wrote a patch to make stripe_size and 
partial_stripes_expensive configurable:

https://lore.kernel.org/lkml/yq1fspvq99j.fsf@ca-mkp.ca.oracle.com/T/

A modern version of this could be merged with bcache-tools support. There 
are still RAID controllers that either do not report io_opt, and Andrea's 
issue highlights the problem with io_opt being too small.

--
Eric Wheeler


--8323328-2120772645-1695674474=:31246--
