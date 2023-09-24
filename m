Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D89227AC9E7
	for <lists+linux-bcache@lfdr.de>; Sun, 24 Sep 2023 16:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjIXOHM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 24 Sep 2023 10:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjIXOHL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 24 Sep 2023 10:07:11 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E170ADA
        for <linux-bcache@vger.kernel.org>; Sun, 24 Sep 2023 07:07:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 94FA11F38D;
        Sun, 24 Sep 2023 14:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1695564423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tG8Yf0pYHJ7cb4cnUCWNqmuuqq+UiBUjQMAP17YSTZ0=;
        b=amrvCvzJ2jh55ElQXJQVXfARBQ8FmbTYqYcQYUWJL7Qp+Fq5sXsPl4/dPttKVZ4RM+6PX+
        DcI2dXT5RJxSvuCrDKp2Zxl+p+UYzv90zbvMy4QFwfIdE5yfO56i9J7vF+tiSoMu3A8pK1
        LrVeJ29Dts5vMuT1KO8oHbvwU3Wp5SQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1695564423;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tG8Yf0pYHJ7cb4cnUCWNqmuuqq+UiBUjQMAP17YSTZ0=;
        b=qGxzeL1IcVsI0xwLAX2OAAptVRu28NxD5edVxQFMYT6SHy1Rhvdo2YEKu5eb34W4t0yQWX
        EVwVcMNKcUPGCUBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E2DDE13581;
        Sun, 24 Sep 2023 14:07:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CGsqKYZCEGX3MwAAMHmgww
        (envelope-from <colyli@suse.de>); Sun, 24 Sep 2023 14:07:02 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.700.6\))
Subject: Re: Unusual value of optimal_io_size prevents bcache initialization
From:   Coly Li <colyli@suse.de>
In-Reply-To: <f3bbd0b9-1783-e924-4b8c-c825d8eb2ede@devo.com>
Date:   Sun, 24 Sep 2023 22:06:50 +0800
Cc:     Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7BFB15E2-7FC6-40F8-8E26-8F23D12F2CD2@suse.de>
References: <4fd61b55-195f-8dc5-598e-835bd03a00ec@devo.com>
 <iymfluasxp5webd4hbgxqsuzq6jbeojti7lfue5e4wd3xcdn4x@fcpmy7uxgsie>
 <f3bbd0b9-1783-e924-4b8c-c825d8eb2ede@devo.com>
To:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
X-Mailer: Apple Mail (2.3731.700.6)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B49=E6=9C=8823=E6=97=A5 22:29=EF=BC=8CAndrea Tomassetti =
<andrea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Coly,
> thank you very much for your quick reply.
>=20
> On 22/9/23 16:22, Coly Li wrote:
>> On Fri, Sep 22, 2023 at 03:26:46PM +0200, Andrea Tomassetti wrote:
>>> Hi Coly,
>>> recently I was testing bcache on new HW when, while creating a =
bcache device
>>> with make-bcache -B /dev/nvme16n1, I got this kernel WARNING:
>>>=20
>>> ------------[ cut here ]------------
>>> WARNING: CPU: 41 PID: 648 at mm/util.c:630 kvmalloc_node+0x12c/0x178
>>> Modules linked in: nf_conntrack_netlink nf_conntrack nf_defrag_ipv6
>>> nf_defrag_ipv4 nfnetlink_acct wireguard libchacha20poly1305 =
chacha_neon
>>> poly1305_neon ip6_udp_tunnel udp_tunnel libcurve25519_generic =
libchacha
>>> nfnetlink ip6table_filter ip6_tables iptable_filter bpfilter =
nls_iso8859_1
>>> xfs libcrc32c dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua =
bcache
>>> crc64 raid0 aes_ce_blk crypto_simd cryptd aes_ce_cipher crct10dif_ce
>>> ghash_ce sha2_ce sha256_arm64 ena sha1_ce sch_fq_codel drm =
efi_pstore
>>> ip_tables x_tables autofs4
>>> CPU: 41 PID: 648 Comm: kworker/41:2 Not tainted 5.15.0-1039-aws
>>> #44~20.04.1-Ubuntu
>>> Hardware name: DEVO new fabulous hardware/, BIOS 1.0 11/1/2018
>>> Workqueue: events register_bdev_worker [bcache]
>>> pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
>>> pc : kvmalloc_node+0x12c/0x178
>>> lr : kvmalloc_node+0x74/0x178
>>> sp : ffff80000ea4bc90
>>> x29: ffff80000ea4bc90 x28: ffffdfa18f249c70 x27: ffff0003c9690000
>>> x26: ffff00043160e8e8 x25: ffff000431600040 x24: ffffdfa18f249ec0
>>> x23: ffff0003c1d176c0 x22: 00000000ffffffff x21: ffffdfa18f236938
>>> x20: 00000000833ffff8 x19: 0000000000000dc0 x18: 0000000000000000
>>> x17: ffff20de6376c000 x16: ffffdfa19df02f48 x15: 0000000000000000
>>> x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
>>> x11: 0000000000000000 x10: 0000000000000000 x9 : ffffdfa19df8d468
>>> x8 : ffff00043160e800 x7 : 0000000000000010 x6 : 000000000000c8c8
>>> x5 : 00000000ffffffff x4 : 0000000000012dc0 x3 : 0000000100000000
>>> x2 : 00000000833ffff8 x1 : 000000007fffffff x0 : 0000000000000000
>>> Call trace:
>>>  kvmalloc_node+0x12c/0x178
>>>  bcache_device_init+0x80/0x2e8 [bcache]
>>>  register_bdev_worker+0x228/0x450 [bcache]
>>>  process_one_work+0x200/0x4d8
>>>  worker_thread+0x148/0x558
>>>  kthread+0x114/0x120
>>>  ret_from_fork+0x10/0x20
>>> ---[ end trace e326483a1d681714 ]---
>>> bcache: register_bdev() error nvme16n1: cannot allocate memory
>>> bcache: register_bdev_worker() error /dev/nvme16n1: fail to register =
backing
>>> device
>>> bcache: bcache_device_free() bcache device (NULL gendisk) stopped
>>>=20
>>> I tracked down the root cause: in this new HW the disks have an
>>> optimal_io_size of 4096. Doing some maths, it's easy to find out =
that this
>>> makes bcache initialization fails for all the backing disks greater =
than 2
>>> TiB. Is this a well-known limitation?
>>>=20
>>> Analyzing bcache_device_init I came up with a doubt:
>>> ...
>>> n =3D DIV_ROUND_UP_ULL(sectors, d->stripe_size);
>>> if (!n || n > max_stripes) {
>>> pr_err("nr_stripes too large or invalid: %llu (start sector beyond =
end of
>>> disk?)\n",
>>> n);
>>> return -ENOMEM;
>>> }
>>> d->nr_stripes =3D n;
>>>=20
>>> n =3D d->nr_stripes * sizeof(atomic_t);
>>> d->stripe_sectors_dirty =3D kvzalloc(n, GFP_KERNEL);
>>> ...
>>> Is it normal that n is been checked against max_stripes _before_ its =
value
>>> gets changed by a multiply it by sizeof(atomic_t) ? Shouldn't the =
check
>>> happen just before trying to kvzalloc n?
>>>=20
>> The issue was triggered by d->nr_stripes which was orinially from
>> q->limits.io_opt which is 8 sectors. Normally the backing devices =
announce
>> 0 sector io_opt, then d->stripe_size will be 1<< 31 in =
bcache_device_init().
>> Number n from DIV_ROUND_UP_ULL() will be quite small. When io_opt is =
8
>> sectors, number n from DIV_ROUND_UP_ULL() is possible to quite big =
for
>> a large size backing device e.g. 2TB
> Thanks for the explanation, that was already clear to me but I didn't =
included in my previous message. I just quickly hided it with the =
expression "doing some maths".
>=20
>> Therefore the key point is not checking n after it is multiplified by
>> sizeof(atomic_t), the question is from n itself -- the value is too =
big.
> What I was trying to point out with when n gets checked is that there =
are cases in which the check (if (!n || n > max_stripes)) passes but =
then, because n gets multiplied by sizeof(atomic_t) the kvzalloc fails. =
We could have prevented this failing by checking n after multiplying it, =
no?

I noticed this message, the root cause is a too big =E2=80=99n=E2=80=99 =
value, checking it before or after multiplication doesn=E2=80=99t help =
too much. What I want is to avoid the memory allocation failure, not  to =
avoid calling kzalloc() if =E2=80=99n=E2=80=99 value is too big.

>> Maybe bcache should not directly use q->limits.io_opt as =
d->stripe_size,
>> it should be some value less than 1<<31 and aligned to =
optimal_io_size.
>> After the code got merged into kernel for 10+ years, it is time to =
improve
>> this calculation :-) >
> Yeah, one of the other doubts I had was exactly regarding this value =
and if it is still "actual" to calculate it that way. Unfortunately, I =
don't have the expertise to have an opinion on it. Would you be so kind =
to share your knowledge and let me understand why it is calculated this =
way and why is it using the optimal io size? Is it using it to =
"writeback" optimal-sized blokes?
>=20

Most of the conditions when underlying hardware doesn=E2=80=99t declare =
its optimal io size, bcache uses 1<<31 as a default stripe size. It =
works fine for decade, so I will use it and make sure it is aligned to =
value of optimal io size. It should work fine. And I will compose a =
simple patch for this fix.

>>> Another consideration, stripe_sectors_dirty and full_dirty_stripes, =
the two
>>> arrays allocated using n, are being used just in writeback mode, is =
this
>>> correct? In my specific case, I'm not planning to use writeback mode =
so I
>>> would expect bcache to not even try to create those arrays. Or, at =
least, to
>>> not create them during initialization but just in case of a change =
in the
>>> working mode (i.e. write-through -> writeback).
>> Indeed, Mingzhe Zou (if I remember correctly) submitted a patch for =
this
>> idea, but it is blocked by other depending patches which are not =
finished
>> by me. Yes I like the idea to dynamically allocate/free =
d->stripe_sectors_dirty
>> and d->full_dirty_stripes when they are necessary. I hope I may help =
to make
>> the change go into upstream sooner.
>> I will post a patch for your testing.
> This would be great! Thank you very much! On the other side, if =
there's anything I can do to help I would be glad to contribute.

I will post a simple patch for the reported memory allocation failure =
for you to test soon.

Thanks.

Coly Li

